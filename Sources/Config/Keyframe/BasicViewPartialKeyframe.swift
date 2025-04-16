//
//  BasicViewPartialKeyframe.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/17/25.
//

import UIKit


public struct BasicViewPartialKeyframe<KeyframeTarget: UIView>: BaseViewPartialKeyframe {
  
  public typealias ConcreteKeyframe = BasicViewConcreteKeyframe<KeyframeTarget>;
  
  public static var empty: Self {
    .init();
  };

  public var opacity: CGFloat?;
  public var backgroundColor: UIColor?;
  public var transform: Transform3D?;
  
  public init(
    opacity: CGFloat? = nil,
    backgroundColor: UIColor? = nil,
    transform: Transform3D? = nil
  ) {
    self.opacity = opacity;
    self.backgroundColor = backgroundColor;
    self.transform = transform;
  };
};
