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
};
