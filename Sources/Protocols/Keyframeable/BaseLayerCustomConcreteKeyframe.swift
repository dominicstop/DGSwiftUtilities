//
//  BaseLayerCustomConcreteKeyframe.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/20/25.
//

import UIKit


public protocol BaseLayerCustomConcreteKeyframe: BaseConcreteKeyframe {
  
  func applyBaseLayerCustomKeyframe(
    toTarget keyframeTarget: KeyframeTarget
  ) throws;
  
  func createBaseLayerCustomAnimations(
    forTarget keyframeTarget: KeyframeTarget,
    withPrevKeyframe keyframeConfigPrev: Self?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> Keyframeable.PropertyAnimatorAnimationBlocks;
};


public extension BaseLayerCustomConcreteKeyframe {
  
  func applyBaseLayerCustomKeyframe<T>(
    toTarget keyframeTarget: T,
    withType targetType: T.Type = T.self
  ) throws {
    
    guard let keyframeTarget = keyframeTarget as? KeyframeTarget else {
      return;
    };
    
    try self.applyBaseLayerCustomKeyframe(toTarget: keyframeTarget);
  };
  
  func createBaseLayerCustomAnimations<T>(
    forTarget keyframeTarget: T,
    withType targetType: T.Type = T.self,
    withPrevKeyframe keyframeConfigPrev: (any BaseLayerCustomConcreteKeyframe)?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> Keyframeable.PropertyAnimatorAnimationBlocks {
    
    guard let keyframeTarget = keyframeTarget as? KeyframeTarget else {
      throw GenericError(errorCode: .typeCastFailed);
    };
    
    return try self.createAnimations(
      forTarget: keyframeTarget,
      withPrevKeyframe: keyframeConfigPrev as? Self,
      forPropertyAnimator: propertyAnimator
    );
  };
};
