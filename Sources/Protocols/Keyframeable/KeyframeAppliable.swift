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

// MARK: - BaseKeyframeConfig+Default
// ----------------------------------

public extension KeyframeAppliable {
  
  func apply(
    toTarget target: KeyframeTarget
  ) throws where KeyframeTarget: UIView {
  
    self.applyBaseKeyframe(toView: target);
  };
};

// MARK: - BaseKeyframeConfig+Helpers
// ------------------------------

public extension KeyframeAppliable {
  
  func applyBaseKeyframe(
    toView targetView: KeyframeTarget,
    withEdgeConstraints edgeConstraint: (
      constraintLeft: NSLayoutConstraint,
      constraintRight: NSLayoutConstraint,
      constraintTop: NSLayoutConstraint,
      constraintBottom: NSLayoutConstraint
    )? = nil
  ) where KeyframeTarget: UIView {
  
    if let baseViewKeyframe = self as? (any BaseViewConcreteKeyframe) {
      baseViewKeyframe.applyBaseViewKeyframe(toView: targetView);
    };
    
    if let baseBorderKeyframe = self as? (any BaseLayerBorderConcreteKeyframe) {
      baseBorderKeyframe.applyBaseLayerBorderKeyframe(toView: targetView);
    };
    
    if let baseShadowKeyframe = self as? (any BaseLayerShadowConcreteKeyframe) {
      baseShadowKeyframe.applyBaseLayerShadowKeyframe(toView: targetView);
    };
    
    if let baseCornerRadiusKeyframe = self as? (any BaseLayerSystemCornerRadiusConcreteKeyframe) {
      baseCornerRadiusKeyframe.applyBaseLayerSystemCornerRadiusKeyframe(toView: targetView);
    };
    
    if let baseFrameLayoutKeyframe = self as? (any BaseFrameLayoutConcreteKeyframe),
       let edgeConstraint = edgeConstraint
    {
      baseFrameLayoutKeyframe.applyBaseLayoutKeyframe(
        toView: targetView,
        constraintLeft: edgeConstraint.constraintLeft,
        constraintRight: edgeConstraint.constraintRight,
        constraintTop: edgeConstraint.constraintTop,
        constraintBottom: edgeConstraint.constraintBottom
      );
    };
  };
};
