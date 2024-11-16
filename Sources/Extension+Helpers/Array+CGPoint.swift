//
//  Array+CGPoint.swift
//  Experiments-Misc
//
//  Created by Dominic Go on 11/13/24.
//

import Foundation


public extension Array where Element == CGPoint {

  func getBoundingBoxForPoints() -> CGRect {
    let valuesX = self.map { $0.x };
    let valuesY = self.map { $0.y };
    
    let minX = valuesX.min() ?? 0;
    let minY = valuesY.min() ?? 0;
    
    let maxX = valuesX.max() ?? 0;
    let maxY = valuesY.max() ?? 0;
    
    return .init(
      minX: minX,
      minY: minY,
      maxX: maxX,
      maxY: maxY
    );
  };

  func scalePointsToFit(
    targetRect: CGRect,
    shouldPreserveAspectRatio: Bool = false
  ) -> [Self.Element] {
    let boundingBox = self.getBoundingBoxForPoints();
    
    // calculate the scaling factors
    let scaleX = targetRect.width / boundingBox.width;
    let scaleY = targetRect.height / boundingBox.height;
    
    let minScaleFactor = Swift.min(scaleX, scaleY);
    
    let scaleXAdj = shouldPreserveAspectRatio
      ? minScaleFactor
      : scaleX;
      
    let scaleYAdj = shouldPreserveAspectRatio
      ? minScaleFactor
      : scaleY;
      
    // Create the scaled points
    var scaledPoints: [CGPoint] = [];
    for point in self {
      let scaledX = (point.x - boundingBox.minX) * scaleXAdj;
      let scaledXAdj = scaledX + targetRect.origin.x;
    
      let scaledY = (point.y - boundingBox.minY) * scaleYAdj;
      let scaledYAdj = scaledY + targetRect.origin.y;
      
      let scaledPoint: CGPoint = .init(x: scaledXAdj, y: scaledYAdj);
      scaledPoints.append(scaledPoint);
    };
    
    return scaledPoints;
  };
};
