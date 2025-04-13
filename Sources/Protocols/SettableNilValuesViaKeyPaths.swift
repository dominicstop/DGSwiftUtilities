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
    self.setNilValuesRecursively(with: otherValue);
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
  
  mutating func setNilValuesRecursively(with otherValue: Self) {
    Self.allNilValueKeyPaths.forEach {
      let newValue = otherValue[keyPath: $0.partialKeyPath];
      let oldValue = self[keyPath: $0.partialKeyPath];
      
      switch (newValue, oldValue) {
        case (
          let newValue as Optional<any SettableNilValues>,
          let oldValue as Optional<any SettableNilValues>
        ):

          guard let newValue = newValue,
                oldValue != nil
          else {
            fallthrough;
          };
          
          do {
            // create copy then write to copy
            var mergedValue = oldValue!;
            try mergedValue.setNilValues(withSomeValue: newValue);
            
            // attempt merge and overwrite
            try $0.setValue(
              target: &self,
              withValue: mergedValue
            );
            
          } catch {
            fallthrough;
          };
          
        default:
          let newValue = otherValue[keyPath: $0.partialKeyPath];
          
          try? $0.setValueIfNil(
            target: &self,
            withValue: newValue
          );
      };
    };
  };
};

public extension SettableNilValues {
  
  mutating func setNilValues(withSomeValue otherValue: some SettableNilValues) throws {
    guard let otherValue = otherValue as? Self else {
      throw GenericError(
        errorCode: .typeCastFailed,
        description:
            "The `otherValue` of type: \(type(of: otherValue)), could not be"
          + " casted to current type of: \(Self.self).",
        extraDebugValues: [
          "self": self,
          "otherValue": otherValue,
        ]
      )
    };
    
    self.setNilValues(with: otherValue);
  };
};
