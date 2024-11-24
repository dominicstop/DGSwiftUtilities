//
//  ViewKeyframeable.swift
//  Experiments-Misc
//
//  Created by Dominic Go on 11/13/24.
//

import UIKit


public class ViewKeyframeable: UIView {

  // MARK: - Embedded Types
  // ----------------------

  public enum AnimationState {
    case noAnimation;
    
    case pendingAnimation(
      animationBase: CABasicAnimation,
      pendingAnimations: [CABasicAnimation],
      currentFrame: CGRect,
      nextFrame: CGRect
    );
    
    case animating(
      animationBase: CABasicAnimation,
      currentAnimations: [CABasicAnimation],
      prevFrame: CGRect,
      nextFrame: CGRect
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
        case let .pendingAnimation(_, _, currentFrame, nextFrame):
          return currentFrame != nextFrame;
        
        case let .animating(_, _, currentFrame, nextFrame):
          return currentFrame != nextFrame;
          
        default:
          return false;
      };
    };
    
    var animationBase: CABasicAnimation? {
      switch self {
        case let .pendingAnimation(animationBase, _, _, _):
          return animationBase;
        
        case let .animating(animationBase, _, _, _):
          return animationBase;
          
        default:
          return nil;
      };
    };
  };
  
  // MARK: - Properties
  // ------------------
  
  public var prevFrame: CGRect?;
  
  public var animationState: AnimationState = .noAnimation;
  public var isExplicitlyBeingAnimated: Bool?;
  
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

  public var layerMaskShape: ShapePreset = .none {
    didSet {
      guard !self.isAnimating else {
        return;
      };
      
      self.updateLayerMask();
    }
  };
  
  // MARK: - View Lifecycle
  // ----------------------
  
  public override func layoutSubviews() {
    super.layoutSubviews();
    self.updateLayers();
  };
  
  // MARK: - Methods (Private)
  // -------------------------
  
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
          let currentFrame =
               self.layer.presentation()?.frame
            ?? self.prevFrame
            ?? .zero;
          
          return .pendingAnimation(
            animationBase: animationBase,
            pendingAnimations: [],
            currentFrame: currentFrame,
            nextFrame: self.frame
          );
          
        case let .pendingAnimation(
          animationBase,
          pendingAnimations,
          currentFrame,
          nextFrame
        ):
          return .animating(
            animationBase: animationBase,
            currentAnimations: pendingAnimations,
            prevFrame: currentFrame,
            nextFrame: nextFrame
          );
          
        default:
          // no changes
          return animationStateCurrent;
      };
    }();
        
    self.animationState = animationStateNext
    self.updateLayerMask();
  };
  
  private func updateLayerMask(){
    switch self.animationState {
      case .noAnimation:
        guard !self.bounds.isEmpty else {
          return;
        };
        
        let shapePathMask =
          self.layerMaskShape.createPath(inRect: self.bounds);
        
        let maskShape = CAShapeLayer();
        maskShape.path = shapePathMask.cgPath;
        
        self.layer.mask = maskShape;
          
      case let .pendingAnimation(
        animationBase,
        pendingAnimations,
        currentFrame,
        nextFrame
      ):
        let currentShapeMask = self.layer.mask as! CAShapeLayer;
        
        let pathAnimation = animationBase.copy() as! CABasicAnimation;
        pathAnimation.keyPath = #keyPath(CAShapeLayer.path);
        
        let currentShapeMaskPath =
             currentShapeMask.presentation()?.path
          ?? currentShapeMask.path;
        
        let nextShapeMaskPath: CGPath = {
          let maskPath =
            self.layerMaskShape.createPath(inRect: nextFrame);
            
          return maskPath.cgPath;
        }();
        
        pathAnimation.fromValue = currentShapeMaskPath;
        pathAnimation.toValue = nextShapeMaskPath;
        
        pathAnimation.delegate = self;
        
        currentShapeMask.add(pathAnimation, forKey: "pathAnimation");
        currentShapeMask.path = nextShapeMaskPath;
        
        let pendingAnimationsNext = pendingAnimations + [pathAnimation];
        
        self.animationState = .pendingAnimation(
          animationBase: animationBase,
          pendingAnimations: pendingAnimationsNext,
          currentFrame: currentFrame,
          nextFrame: nextFrame
        );
        
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

extension ViewKeyframeable: CAAnimationDelegate {
  
  public func animationDidStart(_ anim: CAAnimation) {
    switch self.animationState {
      case let .pendingAnimation(
        animationBase,
        pendingAnimations,
        currentFrame,
        nextFrame
      ):
        self.animationState = .animating(
          animationBase: animationBase,
          currentAnimations: pendingAnimations,
          prevFrame: currentFrame,
          nextFrame: nextFrame
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
