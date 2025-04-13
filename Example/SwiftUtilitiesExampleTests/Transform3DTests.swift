//
//  Transform3DTests.swift
//  SwiftUtilitiesExampleTests
//
//  Created by Dominic Go on 4/12/25.
//

import Testing
@testable import DGSwiftUtilities


struct Transform3DTests {

  struct Nested: SettableNilValuesViaKeyPaths, Equatable {
    static var allNilValueKeyPaths: [AnyWritableKeyPath<Self>] = [
      .init(keyPath: \.someDouble),
      .init(keyPath: \.someTransform),
    ];
    
    var someDouble: Double?;
    var someTransform: Transform3D?;
  }
  
  @Test func test_isIdenity() async throws {
    var transform: Transform3D = .init();
    #expect(transform.isIdentity);
    
    transform.rotateX = .degrees(100);
    #expect(!transform.isIdentity);
  };
  
  @Test func testEquality() async throws {
    #expect(Transform3D.identity == Transform3D.identity);
    
    let transform1: Transform3D = .init(
      translateX: 100,
      translateY: 100,
      translateZ: 100,
      scaleX: 100,
      scaleY: 100,
      rotateX: .degrees(100),
      rotateY: .degrees(100),
      rotateZ: .degrees(100),
      perspective: 100,
      skewX: 100,
      skewY: 100
    );
    
    #expect(transform1 != Transform3D.identity);
    
    let transform2: Transform3D = .init(
      translateX: 99,
      translateY: 99,
      translateZ: 99
    );
    
    #expect(transform2 != Transform3D.identity);
    #expect(transform2 != transform1);
    
    let transform1_copy = transform1;
    #expect(transform1 == transform1_copy);
    
  };

  @Test func test_setNilValues() async throws {
    var transform: Transform3D = .init();
    
    let transform2: Transform3D = .init(
      translateX: 100,
      translateY: 100,
      translateZ: 100,
      scaleX: 100,
      scaleY: 100,
      rotateX: .degrees(100),
      rotateY: .degrees(100),
      rotateZ: .degrees(100),
      perspective: 100,
      skewX: 100,
      skewY: 100
    );
    
    transform.setNilValues(with: transform2);
    
    #expect(transform.translateX == transform2.translateX);
    #expect(transform.translateY == transform2.translateY);
    #expect(transform.translateZ == transform2.translateZ);
    #expect(transform.scaleX == transform2.scaleX);
    #expect(transform.scaleY == transform2.scaleY);
    #expect(transform.rotateX == transform2.rotateX);
    #expect(transform.rotateY == transform2.rotateY);
    #expect(transform.rotateZ == transform2.rotateZ);
    #expect(transform.perspective == transform2.perspective);
    #expect(transform.skewX == transform2.skewX);
    #expect(transform.skewY == transform2.skewY);
    
    #expect(transform == transform2);
  };
  
  @Test func test_setNilValuesRecursive() async throws {
    var nested1 = Nested();
    
    var nested2 = Nested();
    nested2.someDouble = 100;
    nested2.someTransform = .init(
      translateX: 100,
      translateY: 100,
      translateZ: 100,
      scaleX: 100,
      scaleY: 100,
      rotateX: .degrees(100),
      rotateY: .degrees(100),
      rotateZ: .degrees(100),
      perspective: 100,
      skewX: 100,
      skewY: 100
    );
    
    print(
      #function,
      "\n - before",
      "\n - nested1:", nested1,
      "\n - nested2:", nested2,
      "\n"
    );
    
    nested1.setNilValues(with: nested2);
    print(
      #function,
      "\n - afer",
      "\n - nested1:", nested1,
      "\n - nested2:", nested2,
      "\n"
    );
    
    #expect(nested1.someDouble == nested2.someDouble);
    
    #expect(
         nested1.someTransform?.translateX
      == nested2.someTransform?.translateX
    );
    
    #expect(
         nested1.someTransform?.translateX
      == nested2.someTransform?.translateX
    );
    
    #expect(
         nested1.someTransform?.translateY
      == nested2.someTransform?.translateY
    );
    
    #expect(
         nested1.someTransform?.translateZ
      == nested2.someTransform?.translateZ
    );
    
    #expect(
         nested1.someTransform?.scaleX
      == nested2.someTransform?.scaleX
    );
    
    #expect(
         nested1.someTransform?.scaleY
      == nested2.someTransform?.scaleY
    );
    
    #expect(
         nested1.someTransform?.rotateX
      == nested2.someTransform?.rotateX
    );
    
    #expect(
         nested1.someTransform?.rotateY
      == nested2.someTransform?.rotateY
    );
    
    #expect(
         nested1.someTransform?.rotateZ
      == nested2.someTransform?.rotateZ
    );
    
    #expect(
         nested1.someTransform?.perspective
      == nested2.someTransform?.perspective
    );
    
    #expect(
         nested1.someTransform?.skewX
      == nested2.someTransform?.skewX
    );
    
    #expect(
         nested1.someTransform?.skewY
      == nested2.someTransform?.skewY
    );
    
    #expect(nested1 == nested1);
    #expect(nested1 == nested2);
    #expect(nested2 == nested2);
    
    var nested3 = Nested();
    nested3.someDouble = 99;
    nested3.someTransform = .init(
      translateX: 99
    );
    
    var nested4 = Nested();
    nested4.someDouble = 100;
    nested4.someTransform = .init(
      translateX: 100,
      translateY: 100,
      translateZ: 100,
      scaleX: 100,
      scaleY: 100,
      rotateX: .degrees(100),
      rotateY: .degrees(100),
      rotateZ: .degrees(100),
      perspective: 100,
      skewX: 100,
      skewY: 100
    );
    
    nested3.setNilValues(with: nested4);
    
    #expect(nested3.someDouble == 99.0);
    #expect(nested3.someTransform?.translateX == 99.0);
    
    #expect(
         nested3.someTransform?.translateY
      == nested4.someTransform?.translateY
    );
    
    #expect(
         nested3.someTransform?.translateZ
      == nested4.someTransform?.translateZ
    );
    
    #expect(
         nested3.someTransform?.scaleX
      == nested4.someTransform?.scaleX
    );
    
    #expect(
         nested3.someTransform?.scaleY
      == nested4.someTransform?.scaleY
    );
    
    #expect(
         nested3.someTransform?.rotateX
      == nested4.someTransform?.rotateX
    );
    
    #expect(
         nested3.someTransform?.rotateY
      == nested4.someTransform?.rotateY
    );
    
    #expect(
         nested3.someTransform?.rotateZ
      == nested4.someTransform?.rotateZ
    );
    
    #expect(
         nested3.someTransform?.perspective
      == nested4.someTransform?.perspective
    );
    
    #expect(
         nested3.someTransform?.skewX
      == nested4.someTransform?.skewX
    );
    
    #expect(
         nested3.someTransform?.skewY
      == nested4.someTransform?.skewY
    );
  };
}
