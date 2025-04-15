//
//  BaseLayerKeyframeConfig.swift
//  
//
//  Created by Dominic Go on 12/25/24.
//

import UIKit


public protocol BaseLayerKeyframeConfig<KeyframeTarget>: BaseKeyframeConfig where KeyframeTarget: UIView {
  
  associatedtype KeyframeTarget;
  
  var borderWidth: CGFloat? { get set };
  var borderColor: UIColor? { get set };
  
  var shadowColor: UIColor? { get set };
  var shadowOffset: CGSize? { get set };
  var shadowOpacity: CGFloat? { get set };
  var shadowRadius: CGFloat? { get set };
  
  var cornerRadius: CGFloat? { get set };
  var cornerMask: CACornerMask? { get set };
  
  func applyBaseLayerKeyframe(toTarget targetView: KeyframeTarget);
};

// MARK: - BaseLayerKeyframeConfig+Default
// ---------------------------------------

public extension BaseLayerKeyframeConfig {
  
  func applyBaseLayerKeyframe(toTarget targetView: KeyframeTarget) {
    self.applyBaseLayerKeyframe(toLayer: targetView.layer);
  };
};

// MARK: - BaseLayerKeyframeConfig+Helpers
// ---------------------------------------

public extension BaseLayerKeyframeConfig {
  
  func applyBaseLayerKeyframe(toLayer layer: CALayer) {
    if let borderWidth = self.borderWidth {
      layer.borderWidth = borderWidth;
    };
    
    layer.borderColor = self.borderColor?.cgColor;
    layer.shadowColor = self.shadowColor?.cgColor
    
    if let shadowOffset = self.shadowOffset {
      layer.shadowOffset = shadowOffset;
    };
    
    if let shadowOpacity = self.shadowOpacity {
      layer.shadowOpacity = .init(shadowOpacity);
    };
    
    if let shadowRadius = self.shadowRadius {
      layer.shadowRadius = shadowRadius;
    };
    
    if let cornerRadius = self.cornerRadius {
      layer.cornerRadius = cornerRadius;
    };
    
    if let cornerMask = self.cornerMask {
      layer.maskedCorners = cornerMask;
    };
  };

  func applyBaseLayerKeyframe(toView view: UIView) {
    self.applyBaseLayerKeyframe(toLayer: view.layer);
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
  
  func withShadowColor(_ newValue: UIColor) -> Self {
    var copy = self;
    copy.shadowColor = newValue;
    return copy;
  };
  
  func withShadowOffset(_ newValue: CGSize) -> Self {
    var copy = self;
    copy.shadowOffset = newValue;
    return copy;
  };
  
  func withShadowOpacity(_ newValue: CGFloat) -> Self {
    var copy = self;
    copy.shadowOpacity = newValue;
    return copy;
  };
  
  func withShadowRadius(_ newValue: CGFloat) -> Self {
    var copy = self;
    copy.shadowRadius = newValue;
    return copy;
  };
  
  func withCornerRadius(_ newValue: CGFloat) -> Self {
    var copy = self;
    copy.cornerRadius = newValue;
    return copy;
  };
  
  func withCornerMask(_ newValue: CACornerMask) -> Self {
    var copy = self;
    copy.cornerMask = newValue;
    return copy;
  };
};
