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
  
  public func createRawPoints(
    forFrame enclosingFrame: CGRect
  ) -> [CGPoint] {
    switch self {
      case let .regularPolygon(numberOfSides):
        let radius = enclosingFrame.width / 2;
        
        return Self.createPointsForRegularPolygon(
          center: enclosingFrame.centerPoint,
          radius: radius,
          numberOfSides: numberOfSides
        );
        
      case let .regularStarPolygon(numberOfSpikes, innerRadius, outerRadius):
        return Self.createPointsForStar(
          center: enclosingFrame.centerPoint,
          outerRadius: outerRadius,
          innerRadius: innerRadius,
          numberOfPoints: numberOfSpikes
        );
    };
  };
  
  public func createPoints(
    forFrame enclosingFrame: CGRect,
    shouldScaleToFitTargetRect: Bool,
    shouldPreserveAspectRatioWhenScaling: Bool,
    shouldCenterToFrameIfNeeded: Bool = true
  ) -> [CGPoint] {
  
    let points = self.createRawPoints(forFrame: enclosingFrame);
    
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
    shouldCenterToFrameIfNeeded: Bool = true,
    pointConnectionStrategy: PointConnectionStrategy = .straight
  ) -> UIBezierPath {
  
    let points = self.createPoints(
      forFrame: enclosingFrame,
      shouldScaleToFitTargetRect: shouldScaleToFitTargetRect,
      shouldPreserveAspectRatioWhenScaling: shouldPreserveAspectRatioWhenScaling,
      shouldCenterToFrameIfNeeded: shouldCenterToFrameIfNeeded
    );
    
    return pointConnectionStrategy.createPath(
      forPoints: points,
      inRect: enclosingFrame
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
      forFrame: enclosingFrame,
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

