//
//  LayerMaskShape.swift
//  Experiments-Misc
//
//  Created by Dominic Go on 11/13/24.
//

import UIKit


public enum LayerMaskShape {
  
  case rectRoundedVariadic(
    cornerRadiusTopLeft: CGFloat = .leastNonzeroMagnitude,
    cornerRadiusTopRight: CGFloat = .leastNonzeroMagnitude,
    cornerRadiusBottomLeft: CGFloat = .leastNonzeroMagnitude,
    cornerRadiusBottomRight: CGFloat = .leastNonzeroMagnitude
  );
  
  case rectRoundedUniform(cornerRadius: CGFloat);
  
  public func createPath(forRect rect: CGRect) -> UIBezierPath {
    switch self {
      case let .rectRoundedVariadic(
        cornerRadiusTopLeft,
        cornerRadiusTopRight,
        cornerRadiusBottomLeft,
        cornerRadiusBottomRight
      ):
        // temp
        return .init(
          shouldRoundRect: rect,
          topLeftRadius: cornerRadiusTopLeft,
          topRightRadius: cornerRadiusTopRight,
          bottomLeftRadius: cornerRadiusBottomLeft,
          bottomRightRadius: cornerRadiusBottomRight
        );
        
      case let .rectRoundedUniform(cornerRadius):
        // temp
        return .init(
          shouldRoundRect: rect,
          topLeftRadius: cornerRadius,
          topRightRadius: cornerRadius,
          bottomLeftRadius: cornerRadius,
          bottomRightRadius: cornerRadius
        );
    };
  };
};


public extension LayerMaskShape {
  static var none: Self =
    .rectRoundedUniform(cornerRadius: .leastNonzeroMagnitude);
};
