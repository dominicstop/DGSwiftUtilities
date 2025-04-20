//
//  BaseViewConcreteKeyframe.swift
//  AdaptiveModal
//
//  Created by Dominic Go on 4/14/25.
//

import UIKit


public protocol BaseViewConcreteKeyframe<KeyframeTarget>:
  BaseConcreteKeyframe where
    KeyframeTarget: UIView,
    PartialKeyframe: BaseViewPartialKeyframe
{

  var opacity: CGFloat { get set };
  var transform: Transform3D { get set };
  var backgroundColor: UIColor { get set };
};

// MARK: - BaseViewConcreteKeyframe+Default
// --------------------------------------

public extension BaseViewConcreteKeyframe {

};

// MARK: - BaseViewConcreteKeyframe+Helpers
// --------------------------------------

public extension BaseViewConcreteKeyframe {
  
  static var baseViewPartialToConcreteKeyframePropertyMap: KeyframePropertyMap {
    return [
      .init(keyPath: \.opacity): .init(keyPath: \.opacity),
      .init(keyPath: \.transform): .init(keyPath: \.transform),
      .init(keyPath: \.backgroundColor): .init(keyPath: \.backgroundColor),
    ];
  };
  
  static func extractBaseViewPartialToConcreteKeyframePropertyMap<T: BaseConcreteKeyframe>(
    forType concreteKeyframeType: T.Type = T.self
  ) -> T.KeyframePropertyMap {
    
    var map: T.KeyframePropertyMap = [:];

    for (key, value) in Self.baseViewPartialToConcreteKeyframePropertyMap {
      let partialKeyframeKeyPath = key as? T.KeyframePropertyMap.Key;
      let concreteKeyframeKeyPath = value as? T.KeyframePropertyMap.Value;
      
      map[partialKeyframeKeyPath!] = concreteKeyframeKeyPath!;
    };
    
    return map;
  };
  
  func applyBaseViewKeyframe(toView targetView: UIView) {
    targetView.alpha = self.opacity
    targetView.layer.transform = self.transform.transform3D;
    targetView.backgroundColor = self.backgroundColor;
  };
  
  func createBaseViewAnimations(
    forView targetView: UIView,
    withPrevKeyframe keyframeConfigPrev: (any BaseViewConcreteKeyframe)?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> Keyframeable.PropertyAnimatorAnimationBlocks {
    
    return (
      setup: {
        // no-op
      },
      applyKeyframe: {
        self.applyBaseViewKeyframe(toView: targetView);
      },
      completion: { _ in
        // no-op
      }
    );
  };
  
  // MARK: - Chain Setter Methods
  // ----------------------------
  
  func withOpacity(_ opacity: CGFloat) -> Self {
    var copy = self;
    copy.opacity = opacity;
    return copy;
  };
  
  func withTransform(_ transform: Transform3D) -> Self {
    var copy = self;
    copy.transform = transform;
    return copy;
  };
  
  func withBackgroundColor(_ backgroundColor: UIColor) -> Self {
    var copy = self;
    copy.backgroundColor = backgroundColor;
    return copy;
  };
};
