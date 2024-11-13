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
  
  func scalePointsToFitRectangle(targetRect: CGRect) -> [CGPoint] {
    // Find the bounding box for the points
    let minX = self.min { $0.x < $1.x }?.x ?? 0
    let maxX = self.max { $0.x < $1.x }?.x ?? 0
    let minY = self.min { $0.y < $1.y }?.y ?? 0
    let maxY = self.max { $0.y < $1.y }?.y ?? 0
    
    // Calculate the scaling factors
    let scaleX = targetRect.width / (maxX - minX)
    let scaleY = targetRect.height / (maxY - minY)
    
    // Determine the scaling factor to keep the aspect ratio
    let scaleFactor = Swift.min(scaleX, scaleY)
    
    // Create the scaled points
    var scaledPoints: [CGPoint] = []
    for point in self {
        let scaledX = (point.x - minX) * scaleFactor + targetRect.origin.x
        let scaledY = (point.y - minY) * scaleFactor + targetRect.origin.y
        scaledPoints.append(CGPoint(x: scaledX, y: scaledY))
    }
    
    return scaledPoints
  }
  
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
