//
//  SymbolScale+EnumCaseStringRepresentable.swift
//  
//
//  Created by Dominic Go on 8/9/24.
//

import UIKit

@available(iOS 13.0, *)
extension UIImage.SymbolScale: EnumCaseStringRepresentable {

  public var caseString: String {
    switch self {
      case .`default`:
        return "default";
        
      case .unspecified:
        return "unspecified";
        
      case .small:
        return "small";
        
      case .medium:
        return "medium";
        
      case .large:
        return "large";
        
      @unknown default:
        return "unknown";
    };
  }
};
