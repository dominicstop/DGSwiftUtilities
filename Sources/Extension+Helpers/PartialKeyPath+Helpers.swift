//
//  PartialKeyPath+Helpers.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/12/25.
//

public extension PartialKeyPath {
  
  func asWritableKePath<T>(
    forType type: T.Type = T.self
  ) -> WritableKeyPath<Root, T>? {
    
    self as? WritableKeyPath<Root, T>;
  };
  
  func setValue<T>(
    forType type: T.Type = T.self,
    forTarget target: inout Root,
    with newValue: T
  ) throws {
    
    if let writableKeyPath = self.asWritableKePath(forType: T.self) {
      target[keyPath: writableKeyPath] = newValue;
    };
    
    if let writableKeyPath = self.asWritableKePath(forType: Optional<T>.self) {
      target[keyPath: writableKeyPath] = newValue;
    };
    
    throw GenericError(
      errorCode: .unexpectedNilValue,
      description:
          "Could not write to `PartialKeyPath`: \(self) with new value: \(newValue)"
        + " because a `WritableKeyPath` with type \(String(describing: type))"
        + " could not be created."
    );
  };
};
