//
//  ViewKeyframeable.swift
//  Experiments-Misc
//
//  Created by Dominic Go on 11/13/24.
//

import UIKit


public class ShapeView: UIView {

  // MARK: - Embedded Types
  // ----------------------

  public enum AnimationState {
    case noAnimation;
    
    case pendingAnimation(
      animationBase: CABasicAnimation,
      pendingAnimations: [CABasicAnimation],
      currentFrame: CGRect,
      nextFrame: CGRect,
      currentPath: CGPath,
      nextPath: CGPath
    );
    
    case animating(
      animationBase: CABasicAnimation,
      currentAnimations: [CABasicAnimation],
      prevFrame: CGRect,
      nextFrame: CGRect,
      prevPath: CGPath,
      nextPath: CGPath
    );
    
    var isAnimating: Bool {
      switch self {
        case .pendingAnimation, .animating:
          return true;
          
        default:
          return false;
      };
    };
    
    var isAnimatingFrame: Bool {
      switch self {
        case let .pendingAnimation(_, _, currentFrame, nextFrame, _, _):
          return currentFrame != nextFrame;
        
        case let .animating(_, _, currentFrame, nextFrame, _, _):
          return currentFrame != nextFrame;
          
        default:
          return false;
      };
    };
    
    var animationBase: CABasicAnimation? {
      switch self {
        case let .pendingAnimation(animationBase, _, _, _, _, _):
          return animationBase;
        
        case let .animating(animationBase, _, _, _, _, _):
          return animationBase;
          
        default:
          return nil;
      };
    };
    
    mutating func appendAnimations(_ animations: [CABasicAnimation]){
      switch self {
        case let .pendingAnimation(
          animationBase,
          pendingAnimations,
          currentFrame,
          nextFrame,
          currentPath,
          nextPath
        ):
          self = .pendingAnimation(
            animationBase: animationBase,
            pendingAnimations: pendingAnimations + animations,
            currentFrame: currentFrame,
            nextFrame: nextFrame,
            currentPath: currentPath,
            nextPath: nextPath
          );
          
        default:
          #if DEBUG
          assertionFailure("can only append animations to `.pendingAnimation`");
          #endif
          break;
      };
    };
    
    mutating func appendAnimation(_ animation: CABasicAnimation){
      self.appendAnimations([animation]);
    };
  };
  
  // MARK: - Properties
  // ------------------
  
  public var borderLayer: CAShapeLayer!;
  public var prevFrame: CGRect?;
  
  public var animationState: AnimationState = .noAnimation;
  public var isExplicitlyBeingAnimated: Bool?;
  
  // MARK: - Animatable Properties
  // -----------------------------
  
  public var maskShapeConfig: ShapePreset = .none {
    didSet {
      guard !self.isAnimating else {
        return;
      };
      
      self.updateLayers();
    }
  };
  
  private var _borderStyleCurrent: ShapeLayerStrokeStyle = .noBorder;
  private var _borderStylePending: ShapeLayerStrokeStyle?;
  public var borderStyle: ShapeLayerStrokeStyle {
    get {
      if let pendingValue = self._borderStylePending {
        return pendingValue;
      };
      return self._borderStyleCurrent;
    }
    set {
      self._borderStylePending = newValue;
      if !self.isAnimating {
        self.updateBorderLayer();
      };
    }
  };
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var isAnimating: Bool {
    if UIView.inheritedAnimationDuration > 0 {
      return true;
    };
    
    if let isExplicitlyBeingAnimated = self.isExplicitlyBeingAnimated,
       isExplicitlyBeingAnimated
    {
      return true;
    };
    
    return false;
  };
  
  // MARK: - View Lifecycle
  // ----------------------
  
  public override func layoutSubviews() {
    super.layoutSubviews();
    self.updateLayers();
  };
  
  // MARK: - Methods (Private)
  // -------------------------
  
  private func setupBorderLayerIfNeeded(){
    guard self.borderLayer == nil else {
      return;
    };
    
    let borderLayer = CAShapeLayer();
    borderLayer.fillColor = nil;
    
    self.borderLayer = borderLayer;
    self.layer.insertSublayer(borderLayer, at: 0);
    borderLayer.zPosition = .greatestFiniteMagnitude;
  };
  
  private func updateLayers(){
    let animationStateCurrent = self.animationState;
    
    let animationBase: CABasicAnimation? = {
      if let animationBaseCurrent = animationStateCurrent.animationBase {
        return animationBaseCurrent;
      };
      
      if let isExplicitlyBeingAnimated = self.isExplicitlyBeingAnimated,
         !isExplicitlyBeingAnimated
      {
        return nil;
      };
      
      let animationBase = self.layer.recursivelyFindParentAnimation(
        forKeys: CALayer.commonAnimationKeys,
        shouldSkipCurrentLayer: false,
        forType: CABasicAnimation.self
      );
      
      return animationBase;
    }();
    
    let animationStateNext: AnimationState = {
      guard let animationBase = animationBase else {
        return .noAnimation;
      };
      
      switch animationStateCurrent {
        case .noAnimation:
          let nextFrame = self.bounds;
          
          let currentFrame =
               self.layer.presentation()?.bounds
            ?? self.prevFrame
            ?? .zero;
            
          guard let currentShapeMask = self.layer.mask as? CAShapeLayer else {
            return .noAnimation;
          };
          
          let currentShapeMaskPath =
               currentShapeMask.presentation()?.path
            ?? currentShapeMask.path!;
          
          let nextShapeMaskPath: CGPath = {
            let maskPath =
              self.maskShapeConfig.createPath(inRect: nextFrame);
              
            return maskPath.cgPath;
          }();
          
          return .pendingAnimation(
            animationBase: animationBase,
            pendingAnimations: [],
            currentFrame: currentFrame,
            nextFrame: nextFrame,
            currentPath: currentShapeMaskPath,
            nextPath: nextShapeMaskPath
          );
          
        case let .pendingAnimation(
          animationBase,
          pendingAnimations,
          currentFrame,
          nextFrame,
          currentPath,
          nextPath
        ):
          return .animating(
            animationBase: animationBase,
            currentAnimations: pendingAnimations,
            prevFrame: currentFrame,
            nextFrame: nextFrame,
            prevPath: currentPath,
            nextPath: nextPath
          );
          
        default:
          // no changes
          return animationStateCurrent;
      };
    }();
        
    self.animationState = animationStateNext
    self.updateLayerMask();
    self.updateBorderLayer();
  };
  
  private func updateLayerMask(){
    switch self.animationState {
      case .noAnimation:
        guard !self.bounds.isEmpty else {
          return;
        };
        
        let shapePathMask =
          self.maskShapeConfig.createPath(inRect: self.bounds);
        
        let maskShape = CAShapeLayer();
        maskShape.path = shapePathMask.cgPath;
        
        self.layer.mask = maskShape;
          
      case let .pendingAnimation(animationBase, _, _, _, currentPath, nextPath):
        let animationKay = "pathAnimation";
        let currentShapeMask = self.layer.mask as! CAShapeLayer;
        
        guard currentShapeMask.animation(forKey: animationKay) == nil else {
          break;
        };
        
        let pathAnimation = animationBase.copy() as! CABasicAnimation;
        pathAnimation.keyPath = #keyPath(CAShapeLayer.path);
        
        pathAnimation.fromValue = currentPath;
        pathAnimation.toValue = nextPath;
        
        pathAnimation.delegate = self;
        
        currentShapeMask.add(pathAnimation, forKey: animationKay);
        currentShapeMask.path = nextPath;
        
        self.animationState.appendAnimations([pathAnimation]);
        
      case .animating:
        break;
    };
  };
  
  private func updateBorderLayer(){
    let borderStyleCurrent = self._borderStyleCurrent;
    
    let borderStylePending =
         self._borderStylePending
      ?? borderStyleCurrent;
        
    defer {
      self._borderStyleCurrent = borderStylePending;
      self._borderStylePending = nil;
    };
    
    
    switch self.animationState {
      case .noAnimation:
        self.setupBorderLayerIfNeeded();
        
        guard !self.bounds.isEmpty else {
          return;
        };
        
        let maskShape = self.layer.mask as! CAShapeLayer;
        self.borderLayer.path = maskShape.path;
        borderStylePending.apply(toShape: self.borderLayer);
        
      case let .pendingAnimation(animationBase, _, _, _, currentPath, nextPath):
        let pathAnimation: CABasicAnimation? = {
          let animationKey = #keyPath(CAShapeLayer.path);
          
          guard self.borderLayer.animation(forKey: animationKey) == nil else {
            return nil;
          };
          
          let animation = animationBase.copy() as! CABasicAnimation;
          animation.keyPath = animationKey;
          animation.fromValue = currentPath;
          animation.toValue = nextPath;
          
          animation.delegate = self;
          
          self.borderLayer.add(animation, forKey: animationKey);
          self.borderLayer.path = nextPath;
          
          return animation;
        }();
      
        var animations: [CABasicAnimation] = [];
        animations.unwrapThenAppend(pathAnimation);
        
        animations += borderStylePending.createAnimations(
          forShape: self.borderLayer,
          withPrevStyle: borderStyleCurrent,
          usingBaseAnimation: animationBase
        );
        
        self.animationState.appendAnimations(animations);
        
      case .animating:
        break;
    };
  };
  
  #if DEBUG
  func debugLogViewInfo(
    funcName: String = #function
  ){
    let animationBgColor = self.layer.recursivelyFindParentAnimation(
      forKey: #keyPath(CALayer.backgroundColor),
      shouldSkipCurrentLayer: false,
      forType: CABasicAnimation.self
    );
    
    let animationSize = self.layer.recursivelyFindParentAnimation(
      forKey: "bounds.size",
      shouldSkipCurrentLayer: false,
      forType: CABasicAnimation.self
    );
    
    let animationPosition = self.layer.recursivelyFindParentAnimation(
      forKey: #keyPath(CALayer.position),
      shouldSkipCurrentLayer: false,
      forType: CABasicAnimation.self
    );
  
    print(
      "VariadicCornerRadiusView.\(funcName)",
      "\n - frame:", self.frame,
      "\n - bounds:", self.bounds,
      "\n - layer.frame:", self.layer.frame,
      "\n - layer.bounds:", self.layer.bounds,
      "\n - layer.position:", self.layer.position,
      "\n - layer.presentation.frame:", layer.presentation()?.frame.debugDescription ?? "N/A",
      "\n - layer.presentation.bounds:", layer.presentation()?.bounds.debugDescription ?? "N/A",
      "\n - layer.presentation.position:", layer.presentation()?.position.debugDescription ?? "N/A",
      "\n - layer.superlayer:", self.layer.superlayer?.debugDescription ?? "N/A",
      "\n - layer:", self.layer.debugDescription,
      "\n - animationBgColor:", animationBgColor?.debugDescription ?? "N/A",
      "\n - animationSize:", animationSize?.debugDescription ?? "N/A",
      "\n - animationPosition:", animationPosition?.debugDescription ?? "N/A",
      "\n - layer.actions.count:", self.layer.actions?.count ?? -1,
      "\n - inheritedAnimationDuration:", UIView.inheritedAnimationDuration,
      "\n - CATransaction.animationDuration:", CATransaction.animationDuration(),
      "\n"
    );
  };
  #endif
  
  // MARK: - Methods (Public)
  // ------------------------
  
  public func prepareForAnimation(){
    self.isExplicitlyBeingAnimated = true;
  };
};

// MARK: - ViewKeyframeable+CAAnimationDelegate
// --------------------------------------------

extension ShapeView: CAAnimationDelegate {
  
  public func animationDidStart(_ anim: CAAnimation) {
    switch self.animationState {
      case let .pendingAnimation(
        animationBase,
        pendingAnimations,
        currentFrame,
        nextFrame,
        currentPath,
        nextPath
      ):
        self.animationState = .animating(
          animationBase: animationBase,
          currentAnimations: pendingAnimations,
          prevFrame: currentFrame,
          nextFrame: nextFrame,
          prevPath: currentPath,
          nextPath: nextPath
        );
      
      default:
        break;
    };
  };
  
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    switch self.animationState {
      case .animating:
        self.animationState = .noAnimation;
        
      default:
        break;
    };
  };
};
