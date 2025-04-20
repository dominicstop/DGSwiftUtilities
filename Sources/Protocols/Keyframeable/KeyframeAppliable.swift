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
  
  func applyBaseLayerKeyframe(
    toLayer targetLayer: CALayer
  ){
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
  };
  
  func applyBaseKeyframe(
    toView targetView: UIView,
    edgeConstraintsOverride: BaseFrameLayoutConcreteKeyframe.EdgeConstraints? = nil
  ) where KeyframeTarget: UIView {
    
    if let baseViewKeyframe = self as? (any BaseViewConcreteKeyframe) {
      baseViewKeyframe.applyBaseViewKeyframe(toView: targetView);
    };
    
    if let baseFrameLayoutKeyframe = self as? (any BaseFrameLayoutConcreteKeyframe) {
      baseFrameLayoutKeyframe.applyBaseFrameLayoutKeyframe(
        toView: targetView,
        edgeConstraintsOverride: edgeConstraintsOverride
      );
    };
  };
};
