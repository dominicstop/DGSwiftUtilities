//
//  CGPoint+CustomOperators.swift
//  
//
//  Created by Dominic Go on 11/17/24.
//

import Foundation

public extension CGPoint {
  static func +(lhs: Self, rhs: Self) -> Self {
    return .init(
      x: lhs.x + rhs.x,
      y: lhs.y + rhs.y
    );
  };
  
  static func -(lhs: Self, rhs: Self) -> Self {
    return .init(
      x: lhs.x - rhs.x,
      y: lhs.y - rhs.y
    );
  };
  
  static func *(lhs: Self, rhs: Self) -> Self {
    return .init(
      x: lhs.x * rhs.x,
      y: lhs.y * rhs.y
    );
  };
  
  static func /(lhs: Self, rhs: Self) -> Self {
    return .init(
      x: lhs.x / rhs.x,
      y: lhs.y / rhs.y
    );
  };
};
