//
//  StringMappedRawRepresentable.swift
//  
//
//  Created by Dominic Go on 12/31/24.
//

import Foundation


public protocol StringMappedRawRepresentable: RawRepresentable where RawValue: Hashable {

  typealias CaseNameToRawValueMap = Dictionary<String, RawValue>;
  typealias RawValueToCaseNameMap = Dictionary<RawValue, String>;
  
  static var caseNameToRawValueMap: CaseNameToRawValueMap { get };
  static var rawValueToCaseNameMap: RawValueToCaseNameMap { get };
};

// MARK: - StringMappedRawRepresentable+Default
// --------------------------------------------

fileprivate typealias SharedCacheEntry = (
  caseNameToRawValueMap: Dictionary<String, AnyHashable>,
  rawValueToCaseNameMap: Dictionary<AnyHashable, String>
);

fileprivate var SharedCache: Dictionary<String, SharedCacheEntry> = [:];

public extension StringMappedRawRepresentable where Self: CaseIterable & EnumCaseStringRepresentable {

  // MARK: - Caching Logic
  // ---------------------

  fileprivate static var sharedCacheKey: String {
    .init(describing: self);
  };
  
  fileprivate static var associatedCacheEntry: SharedCacheEntry? {
    get {
      SharedCache[Self.sharedCacheKey];
    }
    set {
      SharedCache[Self.sharedCacheKey] = newValue;
    }
  };
  
  fileprivate static var cachedCaseNameToRawValueMap: CaseNameToRawValueMap? {
    get {
      guard let cacheEntry = self.associatedCacheEntry else {
        return nil
      };
      
      return (cacheEntry.caseNameToRawValueMap as! CaseNameToRawValueMap);
    }
    set {
      guard let newValue = newValue else {
        return;
      };
      
      self.associatedCacheEntry?.caseNameToRawValueMap = newValue;
    }
  };
  
  fileprivate static var cachedRawValueToCaseNameMap: RawValueToCaseNameMap? {
    get {
      guard let cacheEntry = self.associatedCacheEntry else {
        return nil
      };
      
      return (cacheEntry.rawValueToCaseNameMap as! RawValueToCaseNameMap);
    }
    set {
      guard let newValue = newValue else {
        return;
      };
      
      self.associatedCacheEntry?.rawValueToCaseNameMap = newValue;
    }
  };
  
  fileprivate static func createMapIfNeeded() -> (
    caseNameToRawValueMap: CaseNameToRawValueMap,
    rawValueToCaseNameMap: RawValueToCaseNameMap
  ){
  
    if let cachedCaseNameToRawValueMap = Self.cachedCaseNameToRawValueMap,
       let cachedRawValueToCaseNameMap = Self.cachedRawValueToCaseNameMap
    {
      return (cachedCaseNameToRawValueMap, cachedRawValueToCaseNameMap);
    };
  
    var caseNameToRawValueMap: CaseNameToRawValueMap = [:];
    var rawValueToCaseNameMap: RawValueToCaseNameMap = [:];
    
    Self.allCases.forEach {
      caseNameToRawValueMap[$0.caseString] = $0.rawValue;
      rawValueToCaseNameMap[$0.rawValue] = $0.caseString;
    };
    
    Self.cachedCaseNameToRawValueMap = caseNameToRawValueMap;
    Self.cachedRawValueToCaseNameMap = rawValueToCaseNameMap;
    
    return (caseNameToRawValueMap, rawValueToCaseNameMap);
  };
  
  // MARK: - Default
  // ---------------
    
  static var caseNameToRawValueMap: CaseNameToRawValueMap {
    let maps = Self.createMapIfNeeded();
    return maps.caseNameToRawValueMap;
  };
  
  static var rawValueToCaseNameMap: RawValueToCaseNameMap {
    let maps = Self.createMapIfNeeded();
    return maps.rawValueToCaseNameMap;
  };
};

// MARK: - StringMappedRawRepresentable+StaticHelpers
// --------------------------------------------------

public extension StringMappedRawRepresentable {
  
  static func getRawValue(forCaseName caseName: String) -> RawValue? {
    Self.caseNameToRawValueMap[caseName];
  };
  
  static func getCaseName(forRawValue rawValue: RawValue) -> String? {
    Self.rawValueToCaseNameMap[rawValue];
  };
};

// MARK: - InitializableFromString+StringMappedRawRepresentable
// ------------------------------------------------------------

extension InitializableFromString where Self: StringMappedRawRepresentable  {
  
  public init(fromString string: String) throws {
    guard let rawValue = Self.getRawValue(forCaseName: string),
          let match = Self.init(rawValue: rawValue)
    else {
      throw GenericError(
        errorCode: .invalidArgument,
        description: "Invalid string value",
        extraDebugValues: [
          "string": string,
        ]
      );
    };
    
    self = match;
  };
};
