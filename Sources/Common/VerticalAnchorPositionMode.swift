//
//  AuxiliaryPreviewVerticalAnchorPosition.swift
//  
//
//  Created by Dominic Go on 10/27/23.
//

import Foundation

// TODO: Move to `DGSwiftUtilities`
/// Note: `VerticalAnchorPositionMode` -> `VerticalAnchorPosition`
public enum VerticalAnchorPositionMode: String {
  case top;
  case bottom;
  case automatic;
  
  var verticalAnchorPosition: VerticalAnchorPosition? {
    switch self {
      case .top:
        return .top;
        
      case .bottom:
        return .bottom;
        
      default:
        return nil;
    };
  };
};
