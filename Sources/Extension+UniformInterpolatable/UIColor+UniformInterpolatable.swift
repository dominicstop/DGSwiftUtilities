//
//  UIColor+UniformInterpolatable.swift
//
//
//  Created by Dominic Go on 7/22/24.
//

import UIKit

extension UIColor: UniformInterpolatable {

  public typealias InterpolatableValue = UIColor;
  
  public static func lerp(
    valueStart colorStart: InterpolatableValue,
    valueEnd colorEnd: InterpolatableValue,
    percent: CGFloat,
    easing: InterpolationEasing?
  ) -> InterpolatableValue {
    
    var colorStartHSBA = colorStart.hsba;
    var colorEndHSBA = colorEnd.hsba;
    
    let result_h = InterpolatorHelpers.lerp(
      valueStart: colorStartHSBA.h,
      valueEnd: colorEndHSBA.h,
      percent: percent,
      easing: easing
    );
    
    let result_s = InterpolatorHelpers.lerp(
      valueStart: colorStartHSBA.s,
      valueEnd: colorEndHSBA.s,
      percent: percent,
      easing: easing
    );
    
    let result_b = InterpolatorHelpers.lerp(
      valueStart: colorStartHSBA.b,
      valueEnd: colorEndHSBA.b,
      percent: percent,
      easing: easing
    );
    
    let result_a = InterpolatorHelpers.lerp(
      valueStart: colorStartHSBA.a,
      valueEnd: colorEndHSBA.a,
      percent: percent,
      easing: easing
    );
    
    return .init(
      hue: result_h,
      saturation: result_s,
      brightness: result_b,
      alpha: result_a
    );
  };
};

