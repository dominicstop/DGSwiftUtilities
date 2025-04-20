//
//  KeyframeAppliable.swift
//
//
//  Created by Dominic Go on 12/26/24.
//

import UIKit


public protocol KeyframeAppliable<KeyframeTarget> {

  associatedtype KeyframeTarget;

  func apply(toTarget target: KeyframeTarget) throws;
};

// MARK: - KeyframeAppliable+Helpers
// ------------------------------

public extension KeyframeAppliable {
  
  func apply<T>(
    toTarget target: T,
    withType type: T.Type = T.self
  ) throws {
    
    guard let target = target as? KeyframeTarget else {
      return;
    };
    
    try self.apply(toTarget: target);
  };
  
  func applyBaseLayerKeyframe<T: CALayer>(toLayer targetLayer: T){
    if let baseBorderKeyframe = self as? (any BaseLayerBorderConcreteKeyframe) {
      baseBorderKeyframe
        .applyBaseLayerBorderKeyframe(toLayer: targetLayer);
    };
    
    if let baseShadowKeyframe = self as? (any BaseLayerShadowConcreteKeyframe) {
      baseShadowKeyframe
        .applyBaseLayerShadowKeyframe(toLayer: targetLayer);
    };
    
    if let baseCornerRadiusKeyframe = self as? (any BaseLayerSystemCornerRadiusConcreteKeyframe) {
      baseCornerRadiusKeyframe
        .applyBaseLayerSystemCornerRadiusKeyframe(toLayer: targetLayer);
    };
    
    if let baseLayerCustomKeyframe = self as? (any BaseLayerCustomConcreteKeyframe) {
      baseLayerCustomKeyframe.applyBaseLayerCustomKeyframe(
        toTarget: targetLayer,
        withType: T.self
      );
    };
  };
  
  func applyBaseKeyframe<T: UIView>(
    toView targetView: T,
    edgeConstraintsOverride: EdgeConstraints? = nil
  ) {
    
    if let baseViewKeyframe = self as? (any BaseViewConcreteKeyframe) {
      baseViewKeyframe.applyBaseViewKeyframe(toView: targetView);
    };
    
    if let baseFrameLayoutKeyframe = self as? (any BaseFrameLayoutConcreteKeyframe) {
      baseFrameLayoutKeyframe.applyBaseFrameLayoutKeyframe(
        toView: targetView,
        edgeConstraintsOverride: edgeConstraintsOverride
      );
    };
    
    if let baseViewCustomKeyframe = self as? (any BaseCustomViewConcreteKeyframe) {
      baseViewCustomKeyframe.applyBaseViewCustomKeyframe(
        toTarget: targetView,
        withType: T.self
      );
    };
  };
};
