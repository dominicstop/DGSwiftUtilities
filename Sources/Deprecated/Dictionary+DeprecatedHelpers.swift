//
//  Dictionary+DeprecatedHelpers.swift
//  
//
//  Created by Dominic Go on 12/16/24.
//

import UIKit


public extension Dictionary where Key == String {
  
  @available(*, deprecated, renamed: "getValueFromDictionary")
  func getValueFromDictionary<T>(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> T {
    
    try self.getValue(forKey: key, type: type);
  };
  
  @available(*, deprecated, renamed: "getValueFromDictionary")
  func getValueFromDictionary<T: InitializableFromDictionary>(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> T {
    
    try self.getValue(forKey: key, type: type);
  };
  
  @available(*, deprecated, renamed: "getValueFromDictionary")
  func getValueFromDictionary<T: CreatableFromDictionary>(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> T {
    
    try self.getValue(forKey: key, type: type);
  };
  
  @available(*, deprecated, renamed: "getValueFromDictionary")
  func getValueFromDictionary<T: InitializableFromString>(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> T {
    
    try self.getValue(forKey: key, type: type);
  }
  
  @available(*, deprecated, renamed: "getValueFromDictionary")
  func getValueFromDictionary<T: OptionSet & InitializableFromString>(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> T {
    
    try self.getValue(forKey: key, type: type);
  }
  
  @available(*, deprecated, renamed: "getColorFromDictionary")
  func getColorFromDictionary(forKey key: String) throws -> UIColor {
    try self.getColor(forKey: key);
  };
  
  @available(*, deprecated, renamed: "xxx")
  func getEnumFromDictionary<T: RawRepresentable<String>>(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> T {
    
    try self.getEnum(forKey: key, type: type);
  };
  
  @available(*, deprecated, renamed: "getEnumFromDictionary")
  func getEnumFromDictionary<
    T: EnumCaseStringRepresentable & CaseIterable
  >(
    forKey key: String,
    type: T.Type = T.self
  ) throws -> T {
  
    try self.getEnum(forKey: key, type: type);
  };
  
  @available(*, deprecated, renamed: "getKeyPathFromDictionary")
  func getKeyPathFromDictionary<
    KeyPathRoot: StringKeyPathMapping,
    KeyPathValue
  >(
    forKey key: String,
    rootType: KeyPathRoot.Type,
    valueType: KeyPathValue.Type
  ) throws -> KeyPath<KeyPathRoot, KeyPathValue> {
    
    try self.getKeyPath(
      forKey: key,
      rootType: rootType,
      valueType: valueType
    );
  };
  
  @available(*, deprecated, renamed: "getValueFromDictionary")
  func getValueFromDictionary<T: RawRepresentable, U>(
    forKey key: String,
    type: T.Type = T.self,
    rawValueType: U.Type = T.RawValue.self
  ) throws -> T where T: RawRepresentable<U> {
    
    try self.getValue(
      forKey: key,
      type: type,
      rawValueType: rawValueType
    );
  };
  
  @available(*, deprecated, renamed: "getValueFromDictionary")
  func getValueFromDictionary<T>(
    forKey key: String,
    type: T.Type = T.self,
    fallbackValue: T
  ) -> T {
    
    self.getValue(
      forKey: key,
      type: type,
      fallbackValue: fallbackValue
    );
  };
  
  @available(*, deprecated, renamed: "getValueFromDictionary")
  func getValueFromDictionary<T: RawRepresentable, U>(
    forKey key: String,
    type: T.Type = T.self,
    rawValueType: U.Type = T.RawValue.self,
    fallbackValue: T
  ) -> T where T: RawRepresentable<U> {
    
    self.getValue(
      forKey: key,
      type: type,
      rawValueType: rawValueType,
      fallbackValue: fallbackValue
    );
  };
};
