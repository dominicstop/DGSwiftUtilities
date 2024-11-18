//
//  ShapePoints.swift
//  Experiments-Misc
//
//  Created by Dominic Go on 11/13/24.
//

import UIKit


public enum ShapePoints {
  case regularPolygon(numberOfSides: Int);
  
  case regularStarPolygon(
    numberOfSpikes: Int,
    innerRadius: CGFloat? = nil,
    spikeRadius: CGFloat
  );
  
  public func createPoints(
    forFrame enclosingFrame: CGRect,
    shouldScaleToFitTargetRect: Bool,
    shouldPreserveAspectRatioWhenScaling: Bool,
    shouldCenterToFrameIfNeeded: Bool = true
  ) -> [CGPoint] {
  
    var points: [CGPoint] = [];
    
    switch self {
      case let .regularPolygon(numberOfSides):
        let radius = enclosingFrame.width / 2;
        let angleIncrement = 360 / CGFloat(numberOfSides);
        
        points = Self.createPointsForRegularPolygon(
          center: enclosingFrame.centerPoint,
          radius: radius,
          numberOfSides: numberOfSides
        );
        
      case let .regularStarPolygon(numberOfSpikes, innerRadius, outerRadius):
        points = Self.createPointsForStar(
          center: enclosingFrame.centerPoint,
          outerRadius: outerRadius,
          innerRadius: innerRadius,
          numberOfPoints: numberOfSpikes
        );
    };
    
    // 3 bits, 8 possible combinations
    switch (
      shouldScaleToFitTargetRect,
      shouldPreserveAspectRatioWhenScaling,
      shouldCenterToFrameIfNeeded
    ) {
      // no scaling, centered
      case (false, _, true):
        return points.centerPoints(toTargetRect: enclosingFrame);
      
      // scale to fit
      case (true, true, _):
        return points.scalePointsToFit(
          targetRect: enclosingFrame,
          shouldPreserveAspectRatio: true
        );
      
      // scale and preserve aspect ratio, centered
      case (true, false, true):
        let pointsScaledToFit = points.scalePointsToFit(
          targetRect: enclosingFrame,
          shouldPreserveAspectRatio: true
        );
        
        return pointsScaledToFit.centerPoints(toTargetRect: enclosingFrame);
      
      // scale and preserve aspect ratio, no centering
      case (true, false, false):
        return points.scalePointsToFit(
          targetRect: enclosingFrame,
          shouldPreserveAspectRatio: true
        );
        
      // no scaling or centering
      default:
        return points;
    };
  };
  
  public func createPath(
    forFrame enclosingFrame: CGRect,
    shouldScaleToFitTargetRect: Bool,
    shouldPreserveAspectRatioWhenScaling: Bool,
    shouldCenterToFrameIfNeeded: Bool = true
  ) -> UIBezierPath {
  
    var points = self.createPoints(
      forFrame: enclosingFrame,
      shouldScaleToFitTargetRect: shouldScaleToFitTargetRect,
      shouldPreserveAspectRatioWhenScaling: shouldPreserveAspectRatioWhenScaling,
      shouldCenterToFrameIfNeeded: shouldCenterToFrameIfNeeded
    );
      
    let path = UIBezierPath();
        
    // move to the first point
    let firstPoint = points.removeFirst();
    path.move(to: firstPoint);
    
    // add lines to the remaining points
    for point in points {
      path.addLine(to: point);
    };
    
    // close path
    path.close();
    return path;
  };
  
  public func createShape(
    forFrame enclosingFrame: CGRect,
    shouldScaleToFitTargetRect: Bool,
    shouldPreserveAspectRatioWhenScaling: Bool,
    shouldCenterToFrameIfNeeded: Bool = true
  ) -> CAShapeLayer {
  
    let path = self.createPath(
      forFrame: enclosingFrame,
      shouldScaleToFitTargetRect: shouldScaleToFitTargetRect,
      shouldPreserveAspectRatioWhenScaling: shouldPreserveAspectRatioWhenScaling,
      shouldCenterToFrameIfNeeded: shouldCenterToFrameIfNeeded
    );
    
    // assign the path to the shape
    let shapeLayer = CAShapeLayer();
    shapeLayer.path = path.cgPath;
    
    return shapeLayer;
  };
};


// MARK: - ShapePoints+StaticHelpers
// ---------------------------------

public extension ShapePoints {
  static func createPointsForRegularPolygon(
    center: CGPoint,
    radius: CGFloat,
    numberOfSides: Int
  ) -> [CGPoint] {
    
    let angleIncrement = 360 / CGFloat(numberOfSides);
    
    return (0 ..< numberOfSides).map {
      let angle: Angle<CGFloat> = .degrees(CGFloat($0) * angleIncrement);
      
      return angle.getPointAlongCircle(
        withRadius: radius,
        usingCenter: center
      );
    };
  };
  
  static func createPointsForStar(
    center: CGPoint,
    outerRadius: CGFloat,
    innerRadius: CGFloat? = nil,
    numberOfPoints: Int
  ) -> [CGPoint] {
          
    let innerRadius = innerRadius ?? outerRadius / 2.5;
    
    let angleIncrement = 360 / CGFloat(numberOfPoints);
    let angleIncrementHalf = angleIncrement / 2;
    
    return (0 ..< numberOfPoints).reduce(into: []) {
      let index = CGFloat($1);
    
      let innerAngle: Angle<CGFloat> = .degrees(index * angleIncrement);
      
      let innerPoint = innerAngle.getPointAlongCircle(
        withRadius: innerRadius,
        usingCenter: center
      );
      
      $0.append(innerPoint);
      
      let outerAngle: Angle<CGFloat> = .degrees(innerAngle.degrees + angleIncrementHalf);
      
      let outerPoint = outerAngle.getPointAlongCircle(
        withRadius: outerRadius,
        usingCenter: center
      );
      
      $0.append(outerPoint);
    };
  };
  
  static func createPathForRoundedPolygon(
    forPoints points: [CGPoint],
    cornerRadius: CGFloat
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
