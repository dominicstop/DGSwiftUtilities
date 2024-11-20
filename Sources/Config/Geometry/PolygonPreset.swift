//
//  PolygonPreset.swift
//  Experiments-Misc
//
//  Created by Dominic Go on 11/13/24.
//

import UIKit


public enum PolygonPreset {
  case regularPolygon(numberOfSides: Int);
  
  case regularStarPolygon(
    numberOfSpikes: Int,
    innerRadius: CGFloat? = nil,
    spikeRadius: CGFloat
  );
  
  // MARK: - Functions
  // -----------------
  
  public func createRawPoints(inRect targetRect: CGRect) -> [CGPoint] {
    switch self {
      case let .regularPolygon(numberOfSides):
        let radius = targetRect.width / 2;
        
        return Self.createPointsForRegularPolygon(
          center: targetRect.centerPoint,
          radius: radius,
          numberOfSides: numberOfSides
        );
        
      case let .regularStarPolygon(numberOfSpikes, innerRadius, outerRadius):
        return Self.createPointsForStar(
          center: targetRect.centerPoint,
          outerRadius: outerRadius,
          innerRadius: innerRadius,
          numberOfPoints: numberOfSpikes
        );
    };
  };
  
  public func createPoints(
    inRect targetRect: CGRect,
    shouldScaleToFitTargetRect: Bool,
    shouldPreserveAspectRatioWhenScaling: Bool,
    shouldCenterToFrameIfNeeded: Bool = true
  ) -> [CGPoint] {
  
    let points = self.createRawPoints(inRect: targetRect);
    
    // 3 bits, 8 possible combinations
    switch (
      shouldScaleToFitTargetRect,
      shouldPreserveAspectRatioWhenScaling,
      shouldCenterToFrameIfNeeded
    ) {
      // no scaling, centered
      case (false, _, true):
        return points.centerPoints(toTargetRect: targetRect);
      
      // scale to fit
      case (true, false, _):
        return points.scalePointsToFit(
          targetRect: targetRect,
          shouldPreserveAspectRatio: false
        );
      
      // scale and preserve aspect ratio, centered
      case (true, true, true):
        let pointsScaledToFit = points.scalePointsToFit(
          targetRect: targetRect,
          shouldPreserveAspectRatio: true
        );
        
        return pointsScaledToFit.centerPoints(toTargetRect: targetRect);
      
      // scale and preserve aspect ratio, no centering
      case (true, true, false):
        return points.scalePointsToFit(
          targetRect: targetRect,
          shouldPreserveAspectRatio: true
        );
        
      // no scaling or centering
      default:
        return points;
    };
  };
  
  public func createPath(
    inRect targetRect: CGRect,
    shouldScaleToFitTargetRect: Bool,
    shouldPreserveAspectRatioWhenScaling: Bool,
    shouldCenterToFrameIfNeeded: Bool = true,
    pointConnectionStrategy: PointConnectionStrategy = .straight
  ) -> UIBezierPath {
  
    let points = self.createPoints(
      inRect: targetRect,
      shouldScaleToFitTargetRect: shouldScaleToFitTargetRect,
      shouldPreserveAspectRatioWhenScaling: shouldPreserveAspectRatioWhenScaling,
      shouldCenterToFrameIfNeeded: shouldCenterToFrameIfNeeded
    );
    
    return pointConnectionStrategy.createPath(
      forPoints: points,
      inRect: targetRect
    );
  };
  
  public func createShape(
    forFrame enclosingFrame: CGRect,
    shouldScaleToFitTargetRect: Bool,
    shouldPreserveAspectRatioWhenScaling: Bool,
    shouldCenterToFrameIfNeeded: Bool = true,
    pointConnectionStrategy: PointConnectionStrategy = .straight
  ) -> CAShapeLayer {
  
    let path = self.createPath(
      inRect: enclosingFrame,
      shouldScaleToFitTargetRect: shouldScaleToFitTargetRect,
      shouldPreserveAspectRatioWhenScaling: shouldPreserveAspectRatioWhenScaling,
      shouldCenterToFrameIfNeeded: shouldCenterToFrameIfNeeded,
      pointConnectionStrategy: pointConnectionStrategy
    );
    
    // assign the path to the shape
    let shapeLayer = CAShapeLayer();
    shapeLayer.path = path.cgPath;
    
    return shapeLayer;
  };
};

// MARK: - ShapePoints+StaticHelpers
// ---------------------------------

public extension PolygonPreset {

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
      
      let outerAngle: Angle<CGFloat> =
        .degrees(innerAngle.degrees + angleIncrementHalf);
      
      let outerPoint = outerAngle.getPointAlongCircle(
        withRadius: outerRadius,
        usingCenter: center
      );
      
      $0.append(outerPoint);
    };
  };
};

