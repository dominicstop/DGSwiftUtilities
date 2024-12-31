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
