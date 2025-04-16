//
//  GenericViewConcreteKeyframe.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/16/25.
//

import Foundation
import UIKit


public struct GenericViewConcreteKeyframe<KeyframeTarget: UIView>:
  BaseViewConcreteKeyframe,
  BaseLayerConcreteKeyframe
{
  public typealias PartialKeyframe = GenericViewPartialKeyframe<KeyframeTarget>;
  public typealias KeyframeTarget = KeyframeTarget;
  
  public static var `default`: Self {
    .init(
      opacity: 1,
      backgroundColor: .systemBackgroundWithFallback,
      transform: .identity,
      borderWidth: 0,
      borderColor: .clear,
      shadowColor: .clear,
      shadowOffset: .zero,
      shadowOpacity: 0,
      shadowRadius: 0,
      cornerRadius: 0,
      cornerMask: .allCorners
    );
  };
  

  public var opacity: CGFloat;
  public var backgroundColor: UIColor;
  public var transform: Transform3D;

  public var borderWidth: CGFloat;
  public var borderColor: UIColor;

  public var shadowColor: UIColor;
  public var shadowOffset: CGSize;
  public var shadowOpacity: CGFloat;
  public var shadowRadius: CGFloat;

  public var cornerRadius: CGFloat;
  public var cornerMask: CACornerMask;
  
  public init(
    opacity: CGFloat =
      Self.default.opacity,
    
    backgroundColor: UIColor =
      Self.default.backgroundColor,
    
    transform: Transform3D =
      Self.default.transform,
    
    borderWidth: CGFloat =
      Self.default.borderWidth,
    
    borderColor: UIColor =
      Self.default.borderColor,
    
    shadowColor: UIColor =
      Self.default.shadowColor,
    
    shadowOffset: CGSize =
      Self.default.shadowOffset,
    
    shadowOpacity: CGFloat =
      Self.default.shadowOpacity,
    
    shadowRadius: CGFloat =
      Self.default.shadowRadius,
    
    cornerRadius: CGFloat =
      Self.default.cornerRadius,
    
    cornerMask: CACornerMask =
      Self.default.cornerMask
  ) {
    self.opacity = opacity;
    self.backgroundColor = backgroundColor;
    self.transform = transform;
    self.borderWidth = borderWidth;
    self.borderColor = borderColor;
    self.shadowColor = shadowColor;
    self.shadowOffset = shadowOffset;
    self.shadowOpacity = shadowOpacity;
    self.shadowRadius = shadowRadius;
    self.cornerRadius = cornerRadius;
    self.cornerMask = cornerMask;
  }
};
