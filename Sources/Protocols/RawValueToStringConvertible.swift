//
//  RawValueToStringConvertible.swift
//  
//
//  Created by Dominic Go on 12/31/24.
//

import Foundation

public protocol RawValueToStringConvertible:
  // manual conformance needed
  StringMappedRawRepresentable,
  CaseIterable,
  // auto conformance created
  EnumCaseStringRepresentable,
  InitializableFromString
{
  // no-op
};

// MARK: - RawValueToStringConvertible+InitializableFromString (Default)
//----------------------------------------------------------------------

extension RawValueToStringConvertible {
  public init(fromString string: String) throws {
    guard let rawValue = Self.getRawValue(forCaseName: string),
          let match: Self = .init(rawValue: rawValue)
    else {
      throw GenericError(
        errorCode: .invalidArgument,
        description: "Invalid string value",
        extraDebugValues: [
          "string": string,
          "type": String(describing: Self.self),
        ]
      );
    };
    
    self = match;
  };
};
