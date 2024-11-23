//
//  ShapePreset.swift
//  
//
//  Created by Dominic Go on 11/20/24.
//

import UIKit


public enum ShapePreset {
  
  case regularPolygon(
    polygonPreset: PolygonPreset,
    pointAdjustments: PointGroupAdjustment,
    pointConnectionStrategy: PointConnectionStrategy
  );
  
  case rectRoundedCornersVariadic(
    cornerRadiusTopLeft: CGFloat,
    cornerRadiusTopRight: CGFloat,
    cornerRadiusBottomLeft: CGFloat,
    cornerRadiusBottomRight: CGFloat
  );
  
  case oval;
  case circle;
  case semicircle;
  
  // MARK: - Functions
  // -----------------
  
  public func createPath(inRect targetRect: CGRect) -> UIBezierPath {
    switch self {
      case let .regularPolygon(
        polygonPreset,
        pointAdjustments,
        pointConnectionStrategy
      ):
        return polygonPreset.createPath(
          inRect: targetRect,
          pointAdjustments: pointAdjustments,
          pointConnectionStrategy: pointConnectionStrategy
        );
        
      case let .rectRoundedCornersVariadic(
        cornerRadiusTopLeft,
        cornerRadiusTopRight,
        cornerRadiusBottomLeft,
        cornerRadiusBottomRight
      ):
        let minCornerRadius = 0.01;
        return .init(
          shouldRoundRect: targetRect,
          topLeftRadius: max(minCornerRadius, cornerRadiusTopLeft),
          topRightRadius: max(minCornerRadius, cornerRadiusTopRight),
          bottomLeftRadius: max(minCornerRadius, cornerRadiusBottomLeft),
          bottomRightRadius: max(minCornerRadius, cornerRadiusBottomRight)
        );
        
      case .oval:
        return .init(ovalIn: targetRect);
        
      case .circle:
        let smallestDimension = targetRect.size.smallestDimension;
        
        let rectSquare = targetRect.scale(toNewSize: .init(
          width: smallestDimension,
          height: smallestDimension
        ));
        
        let path = UIBezierPath(ovalIn: rectSquare);
        return path;
        
      case .semicircle:
        let radius = targetRect.width / 2;
        let circleCenter = targetRect.bottomMidPoint;
        
        let startAngle: Angle = .degrees(0);
        let endAngle: Angle = .degrees(180);
        
        let path = UIBezierPath();
        path.move(to: targetRect.bottomRightPoint);
        
        path.addArc(
          withCenter: circleCenter,
          radius: radius,
          startAngle: startAngle.radians,
          endAngle: endAngle.radians,
          clockwise: false
        );
        
        path.addLine(to: targetRect.bottomLeftPoint);
        path.close();
        
        return path;
    };
  };
  
  public func createShape(inRect targetRect: CGRect) -> CAShapeLayer {
    let path = self.createPath(inRect: targetRect);
    
    let shape = CAShapeLayer();
    shape.path = path.cgPath;
    
    return shape;
  };
};

// MARK: - Static Alias
// --------------------

public extension ShapePreset {

  static var none: Self = .rectRoundedCornersVariadic(
    cornerRadiusTopLeft: .leastNonzeroMagnitude,
    cornerRadiusTopRight: .leastNonzeroMagnitude,
    cornerRadiusBottomLeft: .leastNonzeroMagnitude,
    cornerRadiusBottomRight: .leastNonzeroMagnitude
  );
  
  static func rectRoundedUniform(cornerRadius: CGFloat) -> Self {
    .rectRoundedCornersVariadic(
      cornerRadiusTopLeft: cornerRadius,
      cornerRadiusTopRight: cornerRadius,
      cornerRadiusBottomLeft: cornerRadius,
      cornerRadiusBottomRight: cornerRadius
    );
  };
    
  // MARK: - `PolygonPreset` (Straight)
  // ----------------------------------
  
  static func regularTriangle(pointAdjustments: PointGroupAdjustment) -> Self {
    .regularPolygon(
      polygonPreset: .regularPolygon(numberOfSides: 3),
      pointAdjustments: pointAdjustments,
      pointConnectionStrategy: .straight
    );
  };
  
  static func regularDiamond(pointAdjustments: PointGroupAdjustment) -> Self {
    .regularPolygon(
      polygonPreset: .regularPolygon(numberOfSides: 4),
      pointAdjustments: pointAdjustments,
      pointConnectionStrategy: .straight
    );
  };
  
  static func regularSquare(pointAdjustments: PointGroupAdjustment) -> Self {
    var pointTransform = pointAdjustments.pointTransform ?? .default;
    
    pointTransform.append(
      otherTransform: .init(rotateZ: .degrees(45))
    );
    
    var pointAdjustments = pointAdjustments;
    pointAdjustments.pointTransform = pointTransform;
  
    return .regularPolygon(
      polygonPreset: .regularPolygon(numberOfSides: 4),
      pointAdjustments: pointAdjustments,
      pointConnectionStrategy: .straight
    );
  };
  
  static func regularPentagon(pointAdjustments: PointGroupAdjustment) -> Self {
    .regularPolygon(
      polygonPreset: .regularPolygon(numberOfSides: 5),
      pointAdjustments: pointAdjustments,
      pointConnectionStrategy: .straight
    );
  };
  
  static func regularHexagon(pointAdjustments: PointGroupAdjustment) -> Self {
    .regularPolygon(
      polygonPreset: .regularPolygon(numberOfSides: 6),
      pointAdjustments: pointAdjustments,
      pointConnectionStrategy: .straight
    );
  };
  
  static func regularHeptagon(pointAdjustments: PointGroupAdjustment) -> Self {
    .regularPolygon(
      polygonPreset: .regularPolygon(numberOfSides: 7),
      pointAdjustments: pointAdjustments,
      pointConnectionStrategy: .straight
    );
  };
  
  static func regularOctagon(pointAdjustments: PointGroupAdjustment) -> Self {
    .regularPolygon(
      polygonPreset: .regularPolygon(numberOfSides: 8),
      pointAdjustments: pointAdjustments,
      pointConnectionStrategy: .straight
    );
  };
};
