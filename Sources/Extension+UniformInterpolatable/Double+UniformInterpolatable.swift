//
//  Double+UniformInterpolatable.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/11/25.
//

import Foundation

extension Double: UniformInterpolatable {

  public typealias InterpolatableValue = Self;

  public static func lerp(
    valueStart: InterpolatableValue,
    valueEnd: InterpolatableValue,
    percent: CGFloat,
    easing: InterpolationEasing?
  ) -> InterpolatableValue {
    
    return InterpolatorHelpers.lerp(
      valueStart: valueStart,
      valueEnd: valueEnd,
      percent: percent,
      easing: easing
    );
  };
};
