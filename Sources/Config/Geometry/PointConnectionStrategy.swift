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
    cornerRadiusProvider: PolygonCornerRadiusProvider? = nil
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
      
      let cornerRadius = {
        guard let cornerRadiusProvider = cornerRadiusProvider else {
          return defaultCornerRadius;
        };
        
        return cornerRadiusProvider(points, index, triangle);
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
};
 
