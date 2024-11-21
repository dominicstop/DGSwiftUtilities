//
//  PointConnectionStrategy.swift
//  
//
//  Created by Dominic Go on 11/20/24.
//

import UIKit


public enum PointConnectionStrategy {

  case straight;
  
  case roundedCornersUniform(cornerRadius: CGFloat);
  
  case roundedCornersVariadic(cornerRadiusList: [CGFloat]);
  
  case roundedCornersCustom(cornerRadiusProvider: PolygonCornerRadiusProvider);
  
  case continuousCurvedCorners(
    curvinessAmount: CGFloat,
    curveHeightOffset: CGFloat = 0
  );
  
  // MARK: - Functions
  // -----------------
  
  func createPath(
    forPoints points: [CGPoint],
    inRect targetRect: CGRect
  ) -> UIBezierPath {
  
    switch self {
      case .straight:
        let path = UIBezierPath();
        
        guard points.count > 1 else {
          return path;
        };
        
        // move to the first point
        path.move(to: points.first!);
        
        // add lines to the remaining points
        for index in 1 ..< points.count {
          let currentPoint = points[index];
          path.addLine(to: currentPoint);
        };
        
        // close path
        path.close();
        return path;
        
      case let .roundedCornersUniform(cornerRadius):
        return Self.createPathWithRoundedCorners(
          forPoints: points,
          defaultCornerRadius: cornerRadius
        );
        
      case let .roundedCornersVariadic(cornerRadiusList):
        return Self.createPathWithRoundedCorners(
          forPoints: points,
          defaultCornerRadius: 0
        ) { (_, pointIndex, _) in
          cornerRadiusList[safeIndex: pointIndex] ?? 0;
        };
        
      case let .roundedCornersCustom(cornerRadiusProvider):
        return Self.createPathWithRoundedCorners(
          forPoints: points,
          defaultCornerRadius: 0,
          cornerRadiusProvider: cornerRadiusProvider
        );
        
        case let .continuousCurvedCorners(curvinessAmount, curveHeightOffset):
          return Self.createPathWithContinuousCurvedCorners(
            forPoints: points,
            curvinessAmount: curvinessAmount,
            curveHeightOffset: curveHeightOffset
          );
    };
  };
};

// MARK: - Static Members
// ----------------------

public extension PointConnectionStrategy {

 // MARK: - Static Helpers
 // ----------------------

  typealias PolygonCornerRadiusProvider = (
    _ points: [CGPoint],
    _ pointIndex: Int,
    _ currentCorner: Triangle
  ) -> CGFloat;
  
  static func createPathWithRoundedCorners(
    forPoints points: [CGPoint],
    defaultCornerRadius: CGFloat,
    cornerRadiusProvider: PolygonCornerRadiusProvider? = nil,
    shouldClampCornerRadius: Bool = true
  ) -> UIBezierPath {
  
    let path = UIBezierPath();
  
    for index in 0 ..< points.count {
      let pointPrev = points[cyclicIndex: index - 1];
      let pointCurrent = points[index];
      let pointNext = points[cyclicIndex: index + 1];
      
      let triangle: Triangle = .init(
        topPoint: pointCurrent,
        leadingPoint: pointPrev,
        trailingPoint: pointNext
      );
      
      let cornerRadiusRaw = {
        guard let cornerRadiusProvider = cornerRadiusProvider else {
          return defaultCornerRadius;
        };
        
        return cornerRadiusProvider(points, index, triangle);
      }();
      
      let cornerRadius = {
        guard shouldClampCornerRadius else {
          return cornerRadiusRaw;
        };
        
        // TODO: magic number, doesn't properly clamp
        let cornerRadiusMax = triangle.height / 1.75;
        
        return min(cornerRadiusRaw, cornerRadiusMax);
      }();
      let triangleSmaller = triangle.resizedTriangleRelativeToTopPoint(
        toNewHeight: cornerRadius
      );
      
      if index == 0 {
        path.move(to: triangleSmaller.leadingPoint);
        
      } else {
        path.addLine(to: triangleSmaller.leadingPoint);
      };
      
      path.addQuadCurve(
        to: triangleSmaller.trailingPoint,
        controlPoint: triangleSmaller.topPoint
      );
    };
    
    path.close();
    return path;
  };
  
  static func createPathWithContinuousCurvedCorners(
    forPoints points: [CGPoint],
    curvinessAmount: CGFloat,
    curveHeightOffset: CGFloat = 0
  ) -> UIBezierPath {
    
    let path = UIBezierPath();
        
    for index in 0 ..< points.count {
      let pointPrev = points[cyclicIndex: index - 1];
      let pointCurrent = points[index];
      let pointNext = points[cyclicIndex: index + 1];
      
      let triangle: Triangle = .init(
        topPoint: pointCurrent,
        leadingPoint: pointPrev,
        trailingPoint: pointNext
      );
      
      let leadingSide = triangle.leadingSide;
      let startPoint = leadingSide.startPoint;
      
      let leadingCurveStartPoint =
        leadingSide.traverse(byPercent: curvinessAmount);
        
      let leadingCurveEndPoint: CGPoint = {
        if curvinessAmount == 0 {
          return triangle.topPoint;
        };
        
        let innerLine: Line = .init(
          startPoint: triangle.topPoint,
          endPoint: leadingCurveStartPoint
        );
        
        return innerLine.traverse(byPercent: curveHeightOffset);
      }();
      
      let trailingSide = triangle.trailingSide;
      
      let trailingCurveEndPoint =
        trailingSide.traverse(byPercent: curvinessAmount);
        
      let trailingCurveStartPoint = {
        if curvinessAmount == 0 {
          return triangle.topPoint;
        };
        
        let innerLine: Line = .init(
          startPoint: triangle.topPoint,
          endPoint: trailingCurveEndPoint
        );
        
        return innerLine.traverse(byPercent: curveHeightOffset);
      }();
      
      if index == 0 {
        path.move(to: startPoint);
        
      } else {
        path.addLine(to: startPoint);
      };
      
      path.addLine(to: leadingCurveStartPoint);
      
      path.addCurve(
        to: trailingCurveEndPoint,
        controlPoint1: leadingCurveEndPoint,
        controlPoint2: trailingCurveStartPoint
      );
    };
    
    return path
  };
};
 
