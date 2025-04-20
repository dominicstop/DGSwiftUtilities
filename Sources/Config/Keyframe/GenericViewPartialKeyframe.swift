//
//  GenericViewPartialKeyframe.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/16/25.
//

import UIKit


public struct GenericViewPartialKeyframe:
  BaseViewPartialKeyframe,
  BaseLayerPartialKeyframe
{
  public typealias KeyframeTarget = UIView;
  public typealias ConcreteKeyframe = GenericViewConcreteKeyframe;
  
  public static var empty: Self = .init();
  
  public var opacity: CGFloat?;
  public var transform: Transform3D?;
  
  public var backgroundColor: UIColor?;
  public var borderWidth: CGFloat?;
  public var borderColor: UIColor?;
  
  public var shadowColor: UIColor?;
  public var shadowOffset: CGSize?;
  public var shadowOpacity: CGFloat?;
  public var shadowRadius: CGFloat?;
  
  public var cornerRadius: CGFloat?;
  public var cornerMask: CACornerMask?;
  
  public init(
    opacity: CGFloat? = nil,
    transform: Transform3D? = nil,
    backgroundColor: UIColor? = nil,
    borderWidth: CGFloat? = nil,
    borderColor: UIColor? = nil,
    shadowColor: UIColor? = nil,
    shadowOffset: CGSize? = nil,
    shadowOpacity: CGFloat? = nil,
    shadowRadius: CGFloat? = nil,
    cornerRadius: CGFloat? = nil,
    cornerMask: CACornerMask? = nil
  ) {
    self.opacity = opacity
    self.transform = transform
    self.backgroundColor = backgroundColor
    self.borderWidth = borderWidth
    self.borderColor = borderColor
    self.shadowColor = shadowColor
    self.shadowOffset = shadowOffset
    self.shadowOpacity = shadowOpacity
    self.shadowRadius = shadowRadius
    self.cornerRadius = cornerRadius
    self.cornerMask = cornerMask
  };
};
