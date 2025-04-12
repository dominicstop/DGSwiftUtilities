//
//  SettableNilValues.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/12/25.
//

public protocol SettableNilValues {
  mutating func setNilValues(with otherValue: Self);
};
