//
//  SettableNilValuesViaKeyPaths.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/13/25.
//

public protocol SettableNilValuesViaKeyPaths: SettableNilValues {
  
  static var allNilValueKeyPaths: [AnyWritableKeyPath<Self>] { get }
};

// MARK: - SettableNilValuesViaKeyPaths+SettableNilValues (Default)
// ----------------------------------------------------------------

public extension SettableNilValuesViaKeyPaths {
  
  mutating func setNilValues(with otherValue: Self) {
    Self.allNilValueKeyPaths.forEach {
      let newValue = otherValue[keyPath: $0.partialKeyPath];
      
      try? $0.setValueIfNil(
        target: &self,
        withValue: newValue
      );
    };
  };
};

// MARK: - SettableNilValuesViaKeyPaths+Helpers
// --------------------------------------------

public extension SettableNilValuesViaKeyPaths {
  
  var isAllValuesSet: Bool {
    Self.allNilValueKeyPaths.allSatisfy {
      let value = self[keyPath: $0.partialKeyPath];
      
      guard value is ExpressibleByNilLiteral,
            let optionalValue = value as? OptionalUnwrappable
      else {
        return false;
      };
      
      return optionalValue.isSome();
    };
  };
};
