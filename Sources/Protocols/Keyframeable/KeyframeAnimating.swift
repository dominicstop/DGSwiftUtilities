//
//  KeyframeConfigAnimating.swift
//  
//
//  Created by Dominic Go on 12/27/24.
//

import UIKit


public protocol KeyframeAnimating<KeyframeTarget> {
  
  associatedtype KeyframeTarget;
  
  func createAnimations(
    forTarget keyframeTarget: KeyframeTarget,
    withPrevKeyframe keyframeConfigPrev: Self?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> Keyframeable.PropertyAnimatorAnimationBlocks;
};

// MARK: - KeyframeAnimating+Helpers
// ---------------------------------

public extension KeyframeAnimating where Self: KeyframeAppliable {
  
  func createBaseAnimations<T: CALayer>(
    forLayer targetLayer: T,
    withPrevKeyframe keyframeConfigPrev: Self?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> [Keyframeable.PropertyAnimatorAnimationBlocks] {
    
    var animationBlocks: [Keyframeable.PropertyAnimatorAnimationBlocks] = [];
    
    if let baseBorderKeyframe = self as? (any BaseLayerBorderConcreteKeyframe) {
      let blocks = try? baseBorderKeyframe.createBaseLayerBorderAnimations(
        forTarget: targetLayer,
        withPrevKeyframe: keyframeConfigPrev as? (any BaseLayerBorderConcreteKeyframe),
        forPropertyAnimator: propertyAnimator
      );

      animationBlocks.unwrapThenAppend(blocks);
    };
    
    if let baseShadowKeyframe = self as? (any BaseLayerShadowConcreteKeyframe) {
      let blocks = try? baseShadowKeyframe.createBaseLayerShadowAnimations(
        forTarget: targetLayer,
        withPrevKeyframe: keyframeConfigPrev as? (any BaseLayerShadowConcreteKeyframe),
        forPropertyAnimator: propertyAnimator
      );
      
      animationBlocks.unwrapThenAppend(blocks);
    };
    
    if let baseCornerRadiusKeyframe = self as? (any BaseLayerSystemCornerRadiusConcreteKeyframe) {
      let blocks = try? baseCornerRadiusKeyframe.createBaseLayerSystemCornerRadiusAnimations(
        forTarget: targetLayer,
        withPrevKeyframe: keyframeConfigPrev as? (any BaseLayerSystemCornerRadiusConcreteKeyframe),
        forPropertyAnimator: propertyAnimator
      );
      
      animationBlocks.unwrapThenAppend(blocks);
    };
    
    if let baseCustomLayerKeyframe = self as? (any BaseLayerCustomConcreteKeyframe) {
      let blocks = try? baseCustomLayerKeyframe.createBaseLayerCustomAnimations(
        forTarget: targetLayer,
        withType: T.self,
        withPrevKeyframe: keyframeConfigPrev as? (any BaseLayerCustomConcreteKeyframe),
        forPropertyAnimator: propertyAnimator
      );
      
      animationBlocks.unwrapThenAppend(blocks);
    };
    
    return animationBlocks;
  };
  
  func createBaseAnimations<T: UIView>(
    forView targetView: T,
    withPrevKeyframe keyframeConfigPrev: Self?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> [Keyframeable.PropertyAnimatorAnimationBlocks] {
    
    var animationBlocks: [Keyframeable.PropertyAnimatorAnimationBlocks] = [];
    
    if let baseViewKeyframe = self as? (any BaseViewConcreteKeyframe) {
      let blocks = try? baseViewKeyframe.createBaseViewAnimations(
        forView: targetView,
        withPrevKeyframe: keyframeConfigPrev as? (any BaseViewConcreteKeyframe),
        forPropertyAnimator: propertyAnimator
      );

      animationBlocks.unwrapThenAppend(blocks);
    };
    
    if let baseFrameLayoutKeyframe = self as? (any BaseFrameLayoutConcreteKeyframe) {
      let blocks = try? baseFrameLayoutKeyframe.createBaseFrameLayoutAnimations(
        forView: targetView,
        withPrevKeyframe: keyframeConfigPrev as? (any BaseFrameLayoutConcreteKeyframe),
        forPropertyAnimator: propertyAnimator
      );

      animationBlocks.unwrapThenAppend(blocks);
    };
    
    if let baseCustomViewKeyframe = self as? (any BaseCustomViewConcreteKeyframe) {
      let blocks = try? baseCustomViewKeyframe.createBaseViewCustomAnimations(
        forTarget: targetView,
        withType: T.self,
        withPrevKeyframe: keyframeConfigPrev as? (any BaseCustomViewConcreteKeyframe),
        forPropertyAnimator: propertyAnimator
      );
      
      animationBlocks.unwrapThenAppend(blocks);
    };

    return animationBlocks;
  };
};
