//
//  BasicViewConcreteKeyframe.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/17/25.
//

import UIKit


public struct BasicViewConcreteKeyframe: BaseViewConcreteKeyframe {
  
  public typealias PartialKeyframe = BasicViewPartialKeyframe;
  public typealias KeyframeTarget = PartialKeyframe.KeyframeTarget;
  
  public static let `default`: Self = .init(
    opacity: 1,
    backgroundColor: .systemBackgroundWithFallback,
    transform: .identity
  );
  
  public var opacity: CGFloat;
  public var backgroundColor: UIColor;
  public var transform: Transform3D;
  
  init(
    opacity: CGFloat,
    backgroundColor: UIColor,
    transform: Transform3D
  ) {
    self.opacity = opacity;
    self.backgroundColor = backgroundColor;
    self.transform = transform;
  };
};
