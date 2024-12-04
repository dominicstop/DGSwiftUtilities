//
//  MutableCopy.swift
//  
//
//  Created by Dominic Go on 12/4/24.
//

import Foundation

public protocol MutableCopy {
  
  mutating func mutableCopy() -> UnsafeMutablePointer<Self>;
};

// MARK: - MutableCopy+Default
// ---------------------------

public extension MutableCopy {
  
  /// Example usage:
  /// ```
  /// var transform: Transform3D = .init();
  ///
  /// transform.mutableCopy()
  ///   .withTranslateX(90)
  ///   .withScaleY(3);
  /// ```
  mutating func mutableCopy() -> UnsafeMutablePointer<Self> {
    withUnsafeMutablePointer(to: &self) {
      $0;
    };
  };
};
