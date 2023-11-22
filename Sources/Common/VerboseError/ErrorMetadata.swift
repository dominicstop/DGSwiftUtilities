//
//  RNIErrorMetadata.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/18/23.
//

import Foundation

public protocol ErrorMetadata {

  static var domain: String? { get };
  static var parentType: String? { get };
};
