//
//  CGPoint+Helpers.swift
//  
//
//  Created by Dominic Go on 11/15/24.
//

import Foundation


public extension CGPoint {

  var vectorMagnitude: CGFloat {
    let xSquared = self.x * self.x;
    let ySquared = self.y * self.y;
    
    return sqrt(xSquared + ySquared);
  };
  
  /// convert to unit vector
  /// * converts the vector to have a length/magnitude of 1, while preserving
  ///   the original direction
  ///
  var vectorNormalized: Self {
    let length = self.vectorMagnitude;
    
    let unitVectorX = self.x / length;
    let unitVectorY = self.y / length;
    
    return .init(x: unitVectorX, y: unitVectorY);
  };

  func getDistance(
    fromOtherPoint otherPoint: Self,
    isDeltaAbsolute: Bool = false
  ) -> CGFloat {
  
    let deltaX = {
      let delta = otherPoint.x - self.x;
      return isDeltaAbsolute
        ? abs(delta)
        : delta;
    }();
    
    let deltaY = {
      let delta = otherPoint.y - self.y;
      return isDeltaAbsolute
        ? abs(delta)
        : delta;
    }();
    
    return sqrt(deltaX * deltaX + deltaY * deltaY);
  };
  
  /// calculate angle of point with respect to the center
  func getAngleAlongCircle(withCenter center: Self) -> Angle<CGFloat> {
    let deltaX = self.x - center.x;
    let deltaY = self.y - center.y;
    
    let angleInRadians = atan2(deltaY, deltaX);
    return .radians(angleInRadians).normalized;
  };
  
  func getMidpoint(betweenOtherPoint otherPoint: Self) -> Self {
    let deltaX = self.x + otherPoint.x;
    let midX = deltaX / 2;
    
    let deltaY = self.y + otherPoint.y;
    let midY = deltaY / 2;
    
    return .init(x: midX, y: midY)
  };
  
  func getMidPointAlongsideArc(
    withRadius radius: CGFloat? = nil,
    forOtherPoint trailingPoint: Self,
    usingCenter center: Self
  ) -> Self {
  
    let radius = radius ?? self.getDistance(
      fromOtherPoint: center,
      isDeltaAbsolute: true
    );
    
    let leadingAngle = self.getAngleAlongCircle(withCenter: center);
    let trailingAngle = trailingPoint.getAngleAlongCircle(withCenter: center);

    let midAngle = leadingAngle.computeMidAngle(otherAngle: trailingAngle);
    
    return midAngle.getPointAlongCircle(
      withRadius: radius,
      usingCenter: center
    );
  };
};
