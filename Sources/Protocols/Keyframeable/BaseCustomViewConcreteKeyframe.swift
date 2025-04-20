//
//  BaseCustomViewConcreteKeyframe.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/20/25.
//

import UIKit

public protocol BaseCustomViewConcreteKeyframe: BaseConcreteKeyframe {
  
  func applyBaseViewCustomKeyframe(toTarget keyframeTarget: KeyframeTarget);
  
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
  ) {
    guard let keyframeTarget = keyframeTarget as? KeyframeTarget else {
      return;
    };
    
    self.applyBaseViewCustomKeyframe(toTarget: keyframeTarget);
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
    
    return try self.createAnimations(
      forTarget: keyframeTarget,
      withPrevKeyframe: keyframeConfigPrev as? Self,
      forPropertyAnimator: propertyAnimator
    );
  };
};
