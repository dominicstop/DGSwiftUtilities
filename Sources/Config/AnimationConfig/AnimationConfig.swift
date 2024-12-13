//
//  AnimationConfig.swift
//  swift-programmatic-modal
//
//  Created by Dominic Go on 5/27/23.
//

import UIKit


public enum AnimationConfig: Equatable {
  public static let `default`: Self = .springGesture(
    duration: 0.4,
    dampingRatio: 0.9,
    maxGestureVelocity: 15
  );
  
  case animator(UIViewPropertyAnimator);
  
  case presetCurve(
    duration: TimeInterval,
    curve: UIView.AnimationCurve
  );
  
  case presetSpring(
    duration: TimeInterval,
    dampingRatio: CGFloat
  );
  
  case bezierCurve(
    duration: TimeInterval,
    controlPoint1: CGPoint,
    controlPoint2: CGPoint
  );
  
  case springDamping(
    duration: TimeInterval,
    dampingRatio: CGFloat,
    initialVelocity: CGVector? = nil,
    maxVelocity: CGFloat? = nil
  );
  
  case springPhysics(
    duration: TimeInterval,
    mass: CGFloat,
    stiffness: CGFloat,
    damping: CGFloat,
    initialVelocity: CGVector? = nil,
    maxVelocity: CGFloat? = nil
  );
  
  case springGesture(
    duration: TimeInterval,
    dampingRatio: CGFloat,
    maxGestureVelocity: CGFloat
  );
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var duration: TimeInterval {
    switch self {
      case let .animator(animator):
        return animator.duration;
    
      case let .presetCurve(duration, _):
        return duration;
        
      case let .presetSpring(duration, _):
        return duration;
        
      case let .bezierCurve(duration, _, _):
        return duration;
        
      case let .springDamping(duration, _, _, _):
        return duration;
        
      case let .springPhysics(duration, _, _, _, _, _):
        return duration;
        
      case let .springGesture(duration, _, _):
        return duration;
    };
  };
  
  // MARK: - Functions
  // -----------------
  
  public func createAnimator(
    gestureInitialVelocity: CGVector = .zero
  ) -> UIViewPropertyAnimator {
    
    switch self {
      case let .animator(animator):
        return animator;
    
      case let .presetCurve(duration, curve):
        return .init(duration: duration, curve: curve);
        
      case let .presetSpring(duration, dampingRatio):
        return .init(duration: duration, dampingRatio: dampingRatio);
        
      case let .bezierCurve(duration, controlPoint1, controlPoint2):
        return .init(
          duration: duration,
          controlPoint1: controlPoint1,
          controlPoint2: controlPoint2
        );
        
      case let .springDamping(duration, dampingRatio, initialVelocity, maxVelocity):
        var initialVelocity = initialVelocity ?? gestureInitialVelocity;
        
        if let maxVelocity = maxVelocity {
          initialVelocity = initialVelocity.clamped(minMaxVelocity: maxVelocity);
        };
      
        let timingParams = UISpringTimingParameters(
          dampingRatio: dampingRatio,
          initialVelocity: initialVelocity
        );
        
        return .init(duration: duration, timingParameters: timingParams);
        
      case let .springPhysics(duration, mass, stiffness, damping, initialVelocity, maxVelocity):
        var initialVelocity = initialVelocity ?? gestureInitialVelocity;
        
        if let maxVelocity = maxVelocity {
          initialVelocity = initialVelocity.clamped(minMaxVelocity: maxVelocity);
        };
      
        let timingParams = UISpringTimingParameters(
          mass: mass,
          stiffness: stiffness,
          damping: damping,
          initialVelocity: initialVelocity
        );
        
        return .init(duration: duration, timingParameters: timingParams);
        
      case let .springGesture(duration, dampingRatio, maxGestureVelocity):
        let initialVelocity = gestureInitialVelocity.clamped(
          minMaxVelocity: maxGestureVelocity
        );
      
        let timingParams = UISpringTimingParameters(
          dampingRatio: dampingRatio,
          initialVelocity: initialVelocity
        );
        
        return .init(duration: duration, timingParameters: timingParams);
    };
  };
};
