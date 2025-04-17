//
//  InterpolationFallbackBehavior.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/17/25.
//

import Foundation


public enum InterpolationFallbackBehavior: String, CaseIterable, InitializableFromString {
  
  case copyValueStart;
  case copyValueEnd;
  case copyBothSplitInHalf;
  case copyBothSplitInQuarter;
  case copyBothSplitInThreeQuarters;
  
  func getValue<T, U: BinaryFloatingPoint>(
    startValue: T,
    endValue: T,
    percent: U
  ) -> T {
    
    switch self {
      case .copyValueStart:
        return startValue;
        
      case .copyValueEnd:
        return endValue;
        
      case .copyBothSplitInHalf:
        return percent > 0.5 ? endValue : startValue;
        
      case .copyBothSplitInQuarter:
        return percent <= 0.25 ? startValue : endValue;
        
      case .copyBothSplitInThreeQuarters:
        return percent > 0.75 ? endValue : startValue;
    };
  };
};
