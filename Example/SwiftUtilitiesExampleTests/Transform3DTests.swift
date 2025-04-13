//
//  Transform3DTests.swift
//  SwiftUtilitiesExampleTests
//
//  Created by Dominic Go on 4/12/25.
//

import Testing
@testable import DGSwiftUtilities


struct Transform3DTests {
  
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
}
