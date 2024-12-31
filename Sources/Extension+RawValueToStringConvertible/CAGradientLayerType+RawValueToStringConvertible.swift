//
//  CAGradientLayerType+RawValueToStringConvertible.swift
//
//
//  Created by Dominic Go on 8/9/24.
//

import Foundation
import QuartzCore

extension CAGradientLayerType: RawValueToStringConvertible {
  
  // MARK: - CaseIterable
  // --------------------
  
  public static var allCases: [Self] = [
    .axial,
    .conic,
    .radial,
  ];
  
  // MARK: - StringMappedRawRepresentable
  // ------------------------------------
  
  public var caseString: String {
    switch self {
      case .axial:
        return "axial";
        
      case .conic:
        return "conic";
        
      case .radial:
        return "radial";
        
      default:
        #if DEBUG
        fatalError("not impl.");
        #else
        return "unknown";
        #endif
    };
  };
};