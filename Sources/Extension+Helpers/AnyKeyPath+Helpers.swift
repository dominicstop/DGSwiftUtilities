//
//  AnyKeyPath+Helpers.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/24/24.
//

import Foundation

///
/// ```
/// print(
///   "\n - keyPath: \(keyPath)",
///   "\n - keyPath describing: \(String(describing: keyPath))",
///   "\n - keyPath.rootTypeAsString: \(keyPath.rootTypeAsString)",
///   "\n - keyPath.valueTypeAsType: \(keyPath.valueTypeAsType)",
///   "\n - keyPath.rootTypeAsType describing: \(String(describing: keyPath.rootTypeAsType))",
///   "\n - keyPath.valueTypeAsType describing: \(String(describing: keyPath.valueTypeAsType))",
/// );
///```
///
/// Log:
/// ```
/// init(keyPath:)
///  - keyPath: \TestPartialKeyframe.someFloat
///  - keyPath describing: \TestPartialKeyframe.someFloat
///  - keyPath.rootTypeAsString: TestPartialKeyframe.Type
///  - keyPath.valueTypeAsType: Optional<CGFloat>
///  - keyPath.rootTypeAsType describing: TestPartialKeyframe
///  - keyPath.valueTypeAsType describing: Optional<CGFloat>
/// ```
///
public extension AnyKeyPath {
  var rootTypeAsString: String {
    return "\(type(of: Self.rootType))";
  };

  var valueTypeAsString: String {
    return "\(type(of: Self.valueType))";
  };
  
  var rootTypeAsType: Any.Type {
    return Self.rootType.self;
  };
  
  var valueTypeAsType: Any.Type {
    return Self.valueType.self;
  };
};
