//
//  AnyWritableKeyPathTests.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 4/13/25.
//

import Testing
import Foundation
@testable import DGSwiftUtilities

struct AnyWritableKeyPathTests {
  
  @Test func test_setValue() async throws {
    var transform: Transform3D = .init();
    
    let keyPath: AnyWritableKeyPath<Transform3D> = .init(keyPath: \.translateX);
    try keyPath.setValue(
      target: &transform,
      valueType: CGFloat.self,
      withValue: 30.0
    );
    #expect(transform.translateX == 30.0);
    
    let keyPath2: AnyWritableKeyPath<Transform3D> = .init(keyPath: \.translateY);
    try keyPath2.setValue(
      target: &transform,
      valueType: CGFloat.self,
      withValue: 99
    );
    #expect(transform.translateY == 99);
  };
  
  @Test func test_setValueIfNil() async throws {
    struct TestStruct {
      var translateX: CGFloat? = nil;
      var translateY: CGFloat? = nil;
    };
    
    var transform: TestStruct = .init();
    transform.translateX = 100.0;
    
    try AnyWritableKeyPath<TestStruct>
      .init(keyPath: \.translateX)
      .setValueIfNil(
        target: &transform,
        valueType: CGFloat.self,
        withValue: 30.0
      );
    
    #expect(transform.translateX == 100.0);
    
    try AnyWritableKeyPath<TestStruct>
      .init(keyPath: \.translateY)
      .setValueIfNil(
        target: &transform,
        valueType: CGFloat.self,
        withValue: 30.0
      );
    
    #expect(transform.translateY == 30.0);
  };
};
