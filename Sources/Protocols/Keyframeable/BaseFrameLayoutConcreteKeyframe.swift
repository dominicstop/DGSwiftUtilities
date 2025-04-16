//
//  BaseFrameLayoutConcreteKeyframe.swift
//
//  Created by Dominic Go on 12/26/24.
//

import UIKit


public protocol BaseFrameLayoutConcreteKeyframe:
  BaseConcreteKeyframe,
  KeyframeAppliable where
    KeyframeTarget: UIView,
    PartialKeyframe: BaseFrameLayoutPartialKeyframe
{
  var frame: CGRect { get set };
  var contentPadding: UIEdgeInsets { get set };
};

// MARK: - BaseFrameLayoutConcreteKeyframe+Helpers
// --------------------------------------

public extension BaseFrameLayoutConcreteKeyframe {
  
  static var baseFrameLayoutPartialToConcreteKeyframePropertyMap: KeyframePropertyMap {
    return [
      .init(keyPath: \.frame): .init(keyPath: \.frame),
      .init(keyPath: \.contentPadding): .init(keyPath: \.contentPadding),
    ];
  };
  
  static func extractBaseFrameLayoutPartialToConcreteKeyframePropertyMap<T: BaseConcreteKeyframe>(
    forType concreteKeyframeType: T.Type = T.self
  ) -> T.KeyframePropertyMap {
    
    var map: T.KeyframePropertyMap = [:];

    for (key, value) in Self.baseFrameLayoutPartialToConcreteKeyframePropertyMap {
      let partialKeyframeKeyPath = key as? T.KeyframePropertyMap.Key;
      let concreteKeyframeKeyPath = value as? T.KeyframePropertyMap.Value;
      
      map[partialKeyframeKeyPath!] = concreteKeyframeKeyPath!;
    };
    
    return map;
  };
  
  var contentPaddingAdjusted: UIEdgeInsets {
    .init(
      top   :  self.contentPadding.top,
      left  :  self.contentPadding.left,
      bottom: -self.contentPadding.bottom,
      right : -self.contentPadding.right
    );
  };
  
  @discardableResult
  func applyBaseFrameLayoutKeyframe(
    toTargetView targetView: KeyframeTarget,
    constraintTarget: UIView? = nil,
    constraintLeft: NSLayoutConstraint?,
    constraintRight: NSLayoutConstraint?,
    constraintTop: NSLayoutConstraint?,
    constraintBottom: NSLayoutConstraint?
  ) -> (
    didChangeFrame: Bool,
    didChangeConstraints: Bool
  ) {
  
    self.applyBaseLayoutKeyframe(
      toView: targetView,
      constraintLeft: constraintLeft,
      constraintRight: constraintRight,
      constraintTop: constraintTop,
      constraintBottom: constraintBottom
    );
  };


  @discardableResult
  func applyBaseLayoutKeyframe(
    toView view: UIView,
    constraintLeft: NSLayoutConstraint?,
    constraintRight: NSLayoutConstraint?,
    constraintTop: NSLayoutConstraint?,
    constraintBottom: NSLayoutConstraint?
  ) -> (
    didChangeFrame: Bool,
    didChangeConstraints: Bool
  ) {
  
    let didChangeFrame = view.frame != self.frame;
    view.frame = self.frame;
    
    let padding = self.contentPaddingAdjusted;
    var didChangeConstraints = false;
    
    if let constraintLeft = constraintLeft,
       constraintLeft.constant != padding.left
    {
      constraintLeft.constant = padding.left;
      didChangeConstraints = true;
    };
    
    if let constraintRight = constraintRight,
       constraintRight.constant != padding.right
    {
      constraintRight.constant = padding.right;
      didChangeConstraints = true;
    };
    
    if let constraintTop = constraintTop,
       constraintTop.constant != padding.top
    {
      constraintTop.constant = padding.top;
      didChangeConstraints = true;
    };
    
    if let constraintBottom = constraintBottom,
       constraintBottom.constant != padding.bottom
    {
      constraintBottom.constant = padding.bottom;
      didChangeConstraints = true;
    };
    
    return (didChangeFrame, didChangeConstraints);
  };
};
