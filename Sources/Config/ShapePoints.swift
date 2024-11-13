//
//  ShapePoints.swift
//  Experiments-Misc
//
//  Created by Dominic Go on 11/13/24.
//

import UIKit


public enum ShapePoints {
  case regularPolygon(numberOfSides: Int);
  
  public func createPoints(
    forFrame enclosingFrame: CGRect,
    shouldScaleToFitTargetRect: Bool = true,
    shouldPreserveAspectRatioWhenScaling: Bool = false
  ) -> [CGPoint] {
    var points: [CGPoint] = [];
    
    switch self {
      case let .regularPolygon(numberOfSides):
        let centerX = enclosingFrame.midX;
        let centreY = enclosingFrame.midY;
        
        let radius = enclosingFrame.width / 2;
        let angle = 2 * (.pi / CGFloat(numberOfSides));
        
        for index in 0 ..< numberOfSides {
          let currentPoint = CGFloat(index);
          
          let x = centerX + radius * sin(currentPoint * angle);
          let y = centreY + radius * cos(currentPoint * angle);
          
          points.append(.init(x: x, y: y));
        };
    };
    
    if !shouldScaleToFitTargetRect {
      return points;
    };
    
    let pointsScaledToFit = points.scalePointsToFit(
      targetRect: enclosingFrame,
      shouldPreserveAspectRatio: shouldPreserveAspectRatioWhenScaling
    );
    
    return pointsScaledToFit;
  };
  
  public func createPath(forFrame enclosingFrame: CGRect) -> UIBezierPath {
    var points = self.createPoints(forFrame: enclosingFrame);
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
  
  public func createShape(forFrame enclosingFrame: CGRect) -> CAShapeLayer {
    let path = self.createPath(forFrame: enclosingFrame);
    
    // assign the path to the shape
    let shapeLayer = CAShapeLayer();
    shapeLayer.path = path.cgPath;
    
    return shapeLayer;
  };
};

