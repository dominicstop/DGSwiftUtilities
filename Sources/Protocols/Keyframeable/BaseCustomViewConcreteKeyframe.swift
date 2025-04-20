//
//  BaseCustomViewConcreteKeyframe.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/20/25.
//

import UIKit

public protocol BaseCustomViewConcreteKeyframe: BaseConcreteKeyframe {
  
  func applyBaseViewCustomKeyframe(
    toTarget keyframeTarget: KeyframeTarget
  ) throws;
  
  func createBaseViewCustomAnimations(
    forTarget keyframeTarget: KeyframeTarget,
    withPrevKeyframe keyframeConfigPrev: Self?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> Keyframeable.PropertyAnimatorAnimationBlocks;
};


public extension BaseCustomViewConcreteKeyframe {
  
  func applyBaseViewCustomKeyframe<T>(
    toTarget keyframeTarget: T,
    withType targetType: T.Type = T.self
  ) throws {
    guard let keyframeTarget = keyframeTarget as? KeyframeTarget else {
      return;
    };
    
    try self.applyBaseViewCustomKeyframe(toTarget: keyframeTarget);
  };
  
  func createBaseViewCustomAnimations<T>(
    forTarget keyframeTarget: T,
    withType targetType: T.Type = T.self,
    withPrevKeyframe keyframeConfigPrev: (any BaseCustomViewConcreteKeyframe)?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> Keyframeable.PropertyAnimatorAnimationBlocks {
    
    guard let keyframeTarget = keyframeTarget as? KeyframeTarget else {
      throw GenericError(errorCode: .typeCastFailed);
    };
    
    return try self.createBaseViewCustomAnimations(
      forTarget: keyframeTarget,
      withPrevKeyframe: keyframeConfigPrev as? Self,
      forPropertyAnimator: propertyAnimator
    );
  };
};
