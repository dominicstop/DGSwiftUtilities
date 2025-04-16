//
//  GenericViewConcreteKeyframe.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/16/25.
//

import Foundation
import UIKit


public struct GenericViewConcreteKeyframe:
  BaseViewConcreteKeyframe,
  BaseLayerConcreteKeyframe
{
  public static var `default`: Self = .init(
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
  
  public typealias PartialKeyframe = GenericViewPartialKeyframe;
  public typealias KeyframeTarget = UIView;

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
};
