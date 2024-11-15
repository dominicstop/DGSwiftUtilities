//
//  CGPoint+Helpers.swift
//  
//
//  Created by Dominic Go on 11/15/24.
//

import Foundation


public extension CGPoint {

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
