//
//  Tranform3D+TestHelpers.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/17/25.
//

import Foundation


public extension Transform3D {
  
  func multiplied(by multiplier: CGFloat) -> Self {
    .init(
      translateX: self.translateX * multiplier,
      translateY: self.translateY * multiplier,
      translateZ: self.translateZ * multiplier,
      scaleX: self.scaleX * multiplier,
      scaleY: self.scaleY * multiplier,
      rotateX: .degrees(self.rotateX.degrees * multiplier),
      rotateY: .degrees(self.rotateY.degrees * multiplier),
      rotateZ: .degrees(self.rotateZ.degrees * multiplier),
      perspective: self.perspective * multiplier,
      skewX: self.skewX * multiplier,
      skewY: self.skewY * multiplier
    )
  };
};
