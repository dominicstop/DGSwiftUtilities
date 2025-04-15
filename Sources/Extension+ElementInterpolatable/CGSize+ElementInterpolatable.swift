//
//  CGSize+ElementInterpolatable.swift
//  
//
//  Created by Dominic Go on 7/17/24.
//

import Foundation
import CoreGraphics


extension CGSize: ElementInterpolatable {

  public struct InterpolatableElements: OptionSet, CompositeInterpolatableElements {
    public let rawValue: Int;
    
    public static let width  = Self(rawValue: 1 << 0);
    public static let height = Self(rawValue: 1 << 1);
    
    public var associatedAnyKeyPaths: [AnyKeyPath] {
      guard !self.isEmpty else {
        return [];
      };
      
      var keyPaths: [PartialKeyPath<CGSize>] = [];
      
      if self.contains(.height) {
        keyPaths.append(\.height);
      };
      
      if self.contains(.width) {
        keyPaths.append(\.width);
      };
      
      return keyPaths;
    };
    
    public init(rawValue: Int) {
      self.rawValue = rawValue;
    };
  };
  
  public static var interpolatablePropertiesMap: InterpolatableValuesMap = [
    .init(keyPath: \.width): CGFloat.self,
    .init(keyPath: \.height): CGFloat.self,
  ];
};

// MARK: - CGSize+Comparable
// --------------------------

extension CGSize: Swift.Comparable {
  
  public static func < (lhs: Self, rhs: Self) -> Bool {
       lhs.width < rhs.width
    && lhs.height < rhs.height;
  };
};
