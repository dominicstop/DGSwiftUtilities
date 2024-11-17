//
//  File 2.swift
//  
//
//  Created by Dominic Go on 7/10/24.
//

import Foundation


public extension BinaryFloatingPoint {
  
  var asWholeNumberExact: Int? {
    Int(exactly: self)
  };

  var isWholeNumber: Bool {
    self.asWholeNumberExact != nil;
  };
  
  /// Rounds the double to decimal places value
  func roundToPlaces(_ places: Int) -> Self {
    let divisorRaw = pow(10.0, .init(places));
    let divisor = Self(divisorRaw);
    
    return (self * divisor).rounded() / divisor;
  };
  
  func cutOffDecimalsAfter(_ places:Int) -> Self {
    let divisorRaw = pow(10.0, .init(places));
    let divisor = Self(divisorRaw);
    
    return (self * divisor).rounded(.towardZero) / divisor;
  };
};
