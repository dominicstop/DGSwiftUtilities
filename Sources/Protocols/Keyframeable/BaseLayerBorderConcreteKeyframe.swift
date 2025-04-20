//
//  BaseLayerBorderConcreteKeyframe.swift
//  AdaptiveModal
//
//  Created by Dominic Go on 4/15/25.
//

import UIKit


public protocol BaseLayerBorderConcreteKeyframe<KeyframeTarget>:
  BaseConcreteKeyframe,
  KeyframeAppliable where
    PartialKeyframe: BaseLayerBorderPartialKeyframe
{
  associatedtype KeyframeTarget;
  
  var borderWidth: CGFloat { get set };
  var borderColor: UIColor { get set };
};

// MARK: - BaseLayerBorderConcreteKeyframe+Helpers
// ---------------------------------------

public extension BaseLayerBorderConcreteKeyframe {
  
  static var baseLayerBorderPartialToConcreteKeyframePropertyMap: KeyframePropertyMap {
    return [
      .init(keyPath: \.borderColor): .init(keyPath: \.borderColor),
      .init(keyPath: \.borderWidth): .init(keyPath: \.borderWidth),
    ];
  };
  
  static func extractBaseLayerShadowPartialToConcreteKeyframePropertyMap<T: BaseConcreteKeyframe>(
    forType concreteKeyframeType: T.Type = T.self
  ) -> T.KeyframePropertyMap {
    
    var map: T.KeyframePropertyMap = [:];

    for (key, value) in Self.baseLayerBorderPartialToConcreteKeyframePropertyMap {
      let partialKeyframeKeyPath = key as? T.KeyframePropertyMap.Key;
      let concreteKeyframeKeyPath = value as? T.KeyframePropertyMap.Value;
      
      map[partialKeyframeKeyPath!] = concreteKeyframeKeyPath!;
    };
    
    return map;
  };
  
  func applyBaseLayerBorderKeyframe(toLayer layer: CALayer) {
    layer.borderWidth = self.borderWidth;
    layer.borderColor = self.borderColor.cgColor;
  };

  func applyBaseLayerBorderKeyframe(toView view: UIView) {
    self.applyBaseLayerBorderKeyframe(toLayer: view.layer);
  };
  
  func createBaseLayerBorderAnimations<T>(
    forTarget keyframeTarget: T,
    withPrevKeyframe keyframeConfigPrev: (any BaseLayerBorderConcreteKeyframe)?,
    forPropertyAnimator propertyAnimator: UIViewPropertyAnimator?
  ) throws -> Keyframeable.PropertyAnimatorAnimationBlocks {
    
    return (
      setup: {
        // no-op
      },
      applyKeyframe: {
        switch keyframeTarget {
          case let targetView as UIView:
            self.applyBaseLayerBorderKeyframe(toView: targetView);
            
          case let targetLayer as CALayer:
            self.applyBaseLayerBorderKeyframe(toLayer: targetLayer);
            
          default:
            break;
        };
        
      },
      completion: { _ in
        // no-op
      }
    );
  };
  
  // MARK: - Chain Setter Methods
  // ----------------------------
  
  func withBorderWidth(_ newValue: CGFloat) -> Self {
    var copy = self;
    copy.borderWidth = newValue;
    return copy;
  };
  
  func withBorderColor(_ newValue: UIColor) -> Self {
    var copy = self;
    copy.borderColor = newValue;
    return copy;
  };
};
