//
//  AnyWritableKeyPath.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/13/25.
//

import Foundation

///
/// Type-erased  `WritableKeyPath`
///
/// * In order to use `WritableKeyPath<Root, Value>`, the `Root` generic has to match the actual
///   type the property you are writing to.
///
/// * This means that the `Value` generic parameter will not work with `Any` , and must be resolved to
///   it's actual type.
///
/// * As such if you use `PartialKeyPath`'s and want to cast them into `WritableKeyPath`, you
///   cannot simply just use `Any`, and must use it's actual type.
///
public struct AnyWritableKeyPath<Root> {
  
  public typealias PartialKeyPath = Swift.PartialKeyPath<Root>;
  
  private let setValueBlock: (
    _ target: inout Root,
    _ newValue: Any
  ) throws -> Void;
  
  private var metadataKeyPathDesc: String;

  public var partialKeyPath: PartialKeyPath;
  
  public init<U>(keyPath: WritableKeyPath<Root, U>){
    self.partialKeyPath = keyPath;
    self.metadataKeyPathDesc = String(describing: keyPath);
    
    self.setValueBlock = {
      guard let newValue = $1 as? U else {
        throw GenericError(
          errorCode: .typeCastFailed,
          description:
            """
            Unable to write value of: \($1) via key path: \(keyPath) to 
            target: \(type(of: Root.self)) because the type of value 
            is: \(type(of: $1)), and  does not match the required 
            type of: \(type(of: U.self))
            """,
          extraDebugValues: [
            "keyPath": keyPath,
            "target": $0,
            "newValue": $1,
          ]
        );
      };
      
      $0[keyPath: keyPath] = newValue;
    };
  };
  
  public func asOptionalUnwrappable(target: Root) -> OptionalUnwrappable? {
    let currentValue = target[keyPath: self.partialKeyPath];
    
    guard currentValue is ExpressibleByNilLiteral,
          let optionalValue = currentValue as? OptionalUnwrappable
    else {
      return nil;
    };
    
    return optionalValue;
  };
  
  public func setValue<T>(
    target: inout Root,
    valueType: T.Type = T.self,
    withValue newValue: T
  ) throws {
    
    try self.setValueBlock(&target, newValue);
  };
  
  public func setValueIfNil<T>(
    target: inout Root,
    valueType: T.Type = T.self,
    withValue newValue: T
  ) throws {
    
    guard let optionalValue = self.asOptionalUnwrappable(target: target) else {
      let currentValue = target[keyPath: self.partialKeyPath];
      
      throw GenericError(
        errorCode: .guardCheckFailed,
        description:
          """
          Unable to replace current value of \(currentValue) with 
          new value of: \(newValue) via key path: \(self.partialKeyPath) to 
          target: \(type(of: Root.self)) because it is not Optional 
          """,
        extraDebugValues: [
          "target": target,
        ]
      );
    };
    
    guard optionalValue.isNil else {
      return;
    };
    
    try self.setValueBlock(&target, newValue);
  };
};

// MARK: - AnyWritableKeyPath+Equatable
// ------------------------------------

extension AnyWritableKeyPath: Equatable {
  
  public static func == (lhs: Self, rhs: Self) -> Bool {
       lhs.partialKeyPath == rhs.partialKeyPath
    && lhs.metadataKeyPathDesc == rhs.metadataKeyPathDesc;
  };
};

// MARK: - AnyWritableKeyPath+Hashable
// -----------------------------------

extension AnyWritableKeyPath: Hashable {
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.partialKeyPath);
    hasher.combine(self.metadataKeyPathDesc);
  };
}
