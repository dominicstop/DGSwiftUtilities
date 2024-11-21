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
  
  public func createPath(
    forPoints points: [CGPoint],
    inRect targetRect: CGRect
  ) -> UIBezierPath {
  
    switch self {
      case .straight:
        let pathOperations =
          Self.createPathUsingStraightLines(forPoints: points);
          
        return pathOperations.path;
        
      case let .roundedCornersUniform(cornerRadius):
        let pathOperations = Self.createPathWithRoundedCorners(
          forPoints: points,
          defaultCornerRadius: cornerRadius
        );
        
        return pathOperations.path;
        
      case let .roundedCornersVariadic(cornerRadiusList):
        let pathOperations = Self.createPathWithRoundedCorners(
          forPoints: points,
          defaultCornerRadius: 0
        ) { (_, pointIndex, _) in
          cornerRadiusList[safeIndex: pointIndex] ?? 0;
        };
        
        return pathOperations.path;
        
      case let .roundedCornersCustom(cornerRadiusProvider):
        let pathOperations = Self.createPathWithRoundedCorners(
          forPoints: points,
          defaultCornerRadius: 0,
          cornerRadiusProvider: cornerRadiusProvider
        );
        
        return pathOperations.path;
        
        case let .continuousCurvedCorners(curvinessAmount, curveHeightOffset):
          let pathOperations = Self.createPathWithContinuousCurvedCorners(
            forPoints: points,
            curvinessAmount: curvinessAmount,
            curveHeightOffset: curveHeightOffset
          );
          
          return pathOperations.path;
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
  
  static func createPathUsingStraightLines(
    forPoints points: [CGPoint]
  ) -> [BezierPathOperation] {
  
    guard points.count > 1 else {
      return [];
    };
  
    var pathOperations: [BezierPathOperation] = [];
    
    // move to the first point
    pathOperations.append(
      .moveTo(point: points.first!)
    );
    
    // add lines to the remaining points
    for index in 1 ..< points.count {
      let currentPoint = points[index];
      
      pathOperations.append(
        .addLine(endPoint: currentPoint)
      );
    };
    
    // close path
    pathOperations.append(.close);
    return pathOperations;
  };
  
  static func createPathWithRoundedCorners(
    forPoints points: [CGPoint],
    defaultCornerRadius: CGFloat,
    cornerRadiusProvider: PolygonCornerRadiusProvider? = nil,
    shouldClampCornerRadius: Bool = true
  ) -> [BezierPathOperation] {
    
    var pathOperations: [BezierPathOperation] = [];
  
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
        pathOperations.append(
          .moveTo(point: triangleSmaller.leadingPoint)
        );
        
      } else {
        pathOperations.append(
          .addLine(endPoint: triangleSmaller.leadingPoint)
        );
      };
      
      pathOperations.append(
        .addQuadCurve(
          endPoint: triangleSmaller.trailingPoint,
          controlPoint: triangleSmaller.topPoint
        )
      );
    };
    
    pathOperations.append(.close);
    return pathOperations;
  };
  
  static func createPathWithContinuousCurvedCorners(
    forPoints points: [CGPoint],
    curvinessAmount: CGFloat,
    curveHeightOffset: CGFloat = 0
  ) -> [BezierPathOperation] {
    
    var pathOperations: [BezierPathOperation] = [];
        
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
        pathOperations.append(
          .moveTo(point: startPoint)
        );
        
      } else {
        pathOperations.append(
          .addLine(endPoint: startPoint)
        );
      };
      
      pathOperations.append(
        .addLine(endPoint: leadingCurveStartPoint)
      );
      
      pathOperations.append(
        .addCurve(
          endPoint: trailingCurveEndPoint,
          controlPoint1: leadingCurveEndPoint,
          controlPoint2: trailingCurveStartPoint
        )
      );
    };
    
    return pathOperations;
  };
};
