//
//  CAGradientLayerType+EnumCaseStringRepresentable.swift
//
//
//  Created by Dominic Go on 8/9/24.
//

import Foundation
import QuartzCore

extension CAGradientLayerType: EnumCaseStringRepresentable {
  
  public var caseString: String {
    switch self {
      case .axial:
        return "axial";
        
      case .conic:
        return "conic";
        
      case .radial:
        return "radial";
        
      default:
        return "unknown";
    };
  };
};
