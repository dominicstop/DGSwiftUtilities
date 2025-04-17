//
//  BasicViewConcreteKeyframeTests.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 4/17/25.
//

import Testing
import Foundation
@testable import DGSwiftUtilities


struct BasicViewConcreteKeyframeTests {
  
  typealias ConcreteKeyframe = BasicViewConcreteKeyframe;
  typealias PartialKeyframe = BasicViewPartialKeyframe;
  
  @Test func verifyConcreteToPartialKeyframeConversion() async throws {
    let concreteKeyframe: ConcreteKeyframe = .init(
      opacity: 1,
      backgroundColor: .white,
      transform: .init(
        translateX: 100,
        translateY: 100,
        translateZ: 100,
        scaleX: 100,
        scaleY: 100,
        rotateX: .degrees(100),
        rotateY: .degrees(100),
        rotateZ: .degrees(100),
        perspective: 1,
        skewX: 100,
        skewY: 100
      )
    );
    
    let partialKeyframe: PartialKeyframe = concreteKeyframe.asPartialKeyframe;
    let concreteKeyframe2: ConcreteKeyframe = .init(from: partialKeyframe);
    let partialKeyframe2: PartialKeyframe = .init(from: concreteKeyframe2);
    
    print(
      #function,
      "\n - original:", concreteKeyframe,
      "\n - pass #1:", partialKeyframe,
      "\n - pass #2:", concreteKeyframe2,
      "\n"
    );
    
    for (_, keyPathPair) in ConcreteKeyframe.partialToConcreteKeyframePropertyMap.enumerated() {
      let partialKeyframePath = keyPathPair.key.partialKeyPath;
      let concreteKeyframePath = keyPathPair.value.partialKeyPath;
      
      let concreteKeyframeValue = concreteKeyframe[keyPath: concreteKeyframePath];
      let concreteKeyframeValue2 = concreteKeyframe2[keyPath: concreteKeyframePath];
      
      let partialKeyframeValue = try #require(
        partialKeyframe[keyPath: partialKeyframePath],
        """
        keyPath: `\(partialKeyframePath.valueTypeAsString)` is empty
        but is expected to have a value of \(concreteKeyframeValue)
        """
      );
      
      let partialKeyframeValue2 = try #require(
        partialKeyframe2[keyPath: partialKeyframePath],
        """
        2nd pass failed: concrete -> partial -> concrete -> partial. 
        keyPath: `\(partialKeyframePath.valueTypeAsString)` is empty
        but is expected to have a value of \(concreteKeyframeValue).
        """
      );
      
      let concreteKeyframeValueRefined = try #require(
        concreteKeyframeValue as? (any Equatable),
        """
        ConcreteKeyframe value of: \(concreteKeyframeValue)
        for key path: \(concreteKeyframePath.valueTypeAsString)
        could not be converted to equatable
        """
      );
      
      let concreteKeyframeValue2Refined = try #require(
        concreteKeyframeValue2 as? (any Equatable),
        """
        ConcreteKeyframe (2nd pass) value of: \(concreteKeyframeValue2)
        for key path: \(concreteKeyframePath.valueTypeAsString)
        could not be converted to comparable
        """
      );
      
      let partialKeyframeValueRefined = try #require(
        partialKeyframeValue as? (any Equatable),
        """
        PartialKeyframe value of: \(partialKeyframeValue)
        for key path: \(partialKeyframePath.valueTypeAsString)
        could not be converted to comparable
        """
      );
      
      let partialKeyframeValue2Refined = try #require(
        partialKeyframeValue2 as? (any Equatable),
        """
        2nd pass failed.
        PartialKeyframe value of: \(partialKeyframeValue2)
        for key path: \(partialKeyframePath.valueTypeAsString)
        could not be converted to comparable
        """
      );
      
      let isEqualForPass1 = concreteKeyframeValueRefined.isEqual(to: partialKeyframeValueRefined);
      
      #expect(
        isEqualForPass1,
        """
        ConcreteKeyframe value of: \(concreteKeyframeValueRefined)
        for ConcreteKeyframe key path: \(concreteKeyframePath.valueTypeAsString),
        did not match PartialKeyframe value of: \(partialKeyframeValueRefined)
        for PartialKeyframe key path: \(partialKeyframePath.valueTypeAsString)
        """
      );
      
      let isEqualForPass2Concrete = concreteKeyframeValueRefined.isEqual(to: concreteKeyframeValue2Refined);
      
      #expect(
        isEqualForPass2Concrete,
        """
        Conversion of: `ConcreteKeyframe (\(concreteKeyframeValueRefined)) 
         -> PartialKeyframe (\(partialKeyframeValueRefined)) 
         -> ConcreteKeyframe (\(concreteKeyframeValue2Refined))`
        for PartialKeyframe key path: \(partialKeyframePath.valueTypeAsString)
        has failed due to divergence of values.
        """
      );
      
      let isEqualForPass2Partial = partialKeyframeValueRefined.isEqual(to: partialKeyframeValue2Refined);
      
      #expect(
        isEqualForPass2Partial,
        """
        Conversion of: `ConcreteKeyframe (\(concreteKeyframeValueRefined)) 
         -> PartialKeyframe (\(partialKeyframeValueRefined)) 
         -> ConcreteKeyframe (\(concreteKeyframeValue2Refined))`
         -> PartialKeyframe (\(partialKeyframeValue2Refined))`
        for PartialKeyframe key path: \(partialKeyframePath.valueTypeAsString)
        and PartialKeyframe key path: \(concreteKeyframePath.valueTypeAsString)
        has failed due to divergence of values.
        """
      );
    }
  };
  
  @Test func test_isZero() async throws {
    let zeroKeyframe: BasicViewConcreteKeyframe = .init(
      opacity: 0,
      backgroundColor: .init(hue: 0, saturation: 0, brightness: 0, alpha: 0),
      transform: .zero
    );
    
    #expect(zeroKeyframe.isZero);
    #expect(zeroKeyframe.opacity.isZero);
    #expect(zeroKeyframe.backgroundColor.isZero);
    #expect(zeroKeyframe.transform.isZero);
    
    let zeroKeyframeDefault: BasicViewConcreteKeyframe = .zero;
    #expect(zeroKeyframeDefault.opacity.isZero);
    #expect(zeroKeyframeDefault.backgroundColor.isZero);
    #expect(zeroKeyframeDefault.transform.isZero);
  };
  
  @Test func testLerping() async throws {
    let startKeyframe: BasicViewConcreteKeyframe = .init(
      opacity: 0,
      backgroundColor: .init(hue: 0, saturation: 0, brightness: 0, alpha: 0),
      transform: .zero
    );
    
    let endKeyframe: BasicViewConcreteKeyframe = .init(
      opacity: 1,
      backgroundColor: .white,
      transform: .init(
        translateX: 100,
        translateY: 100,
        translateZ: 100,
        scaleX: 100,
        scaleY: 100,
        rotateX: .degrees(100),
        rotateY: .degrees(100),
        rotateZ: .degrees(100),
        perspective: 1,
        skewX: 100,
        skewY: 100
      )
    );
    
    let interpolatedToZeroKeyframe = BasicViewConcreteKeyframe.lerp(
      valueStart: startKeyframe,
      valueEnd: endKeyframe,
      percent: 0
    );
    
    #expect(
         interpolatedToZeroKeyframe.opacity
      == startKeyframe.opacity
    );
    
    #expect(
         interpolatedToZeroKeyframe.backgroundColor
      == startKeyframe.backgroundColor
    );
    
    #expect(
         interpolatedToZeroKeyframe.transform
      == startKeyframe.transform
    );
    
    let interpolatedToFullKeyframe = BasicViewConcreteKeyframe.lerp(
      valueStart: startKeyframe,
      valueEnd: endKeyframe,
      percent: 1
    );
    
    
    #expect(
         interpolatedToFullKeyframe.opacity
      == endKeyframe.opacity
    );
    
    #expect(
         interpolatedToFullKeyframe.backgroundColor
      == endKeyframe.backgroundColor
    );
    
    #expect(
         interpolatedToFullKeyframe.transform
      == endKeyframe.transform
    );
    
    let interpolatedToHalfKeyframe = BasicViewConcreteKeyframe.lerp(
      valueStart: startKeyframe,
      valueEnd: endKeyframe,
      percent: 0.5
    );
    
    let halfKeyframe: BasicViewConcreteKeyframe = .init(
      opacity: endKeyframe.opacity / 2,
      backgroundColor: .init(white: 0.5, alpha: 0.5),
      transform: endKeyframe.transform.multiplied(by: 0.5)
    );
    
    #expect(
         interpolatedToHalfKeyframe.opacity
      == halfKeyframe.opacity
    );
    
    #expect(
         interpolatedToHalfKeyframe.backgroundColor
      == halfKeyframe.backgroundColor
    );
    
    #expect(
         interpolatedToHalfKeyframe.transform
      == halfKeyframe.transform
    );
  };
  
  @Test func verifyRangedLerping() async throws {
    let keyframeStart: ConcreteKeyframe = .zero;
    
    let keyframeHalf: ConcreteKeyframe = .init(
      opacity: 0.5,
      backgroundColor: .init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5),
      transform: .init(
        translateX: 100,
        translateY: 100,
        translateZ: 100,
        scaleX: 100,
        scaleY: 100,
        rotateX: .degrees(100),
        rotateY: .degrees(100),
        rotateZ: .degrees(100),
        perspective: 0.5,
        skewX: 100,
        skewY: 100
      )
    );
    
    let keyframeEnd: ConcreteKeyframe = .init(
      opacity: 1,
      backgroundColor: .white,
      transform: .init(
        translateX: 1000,
        translateY: 1000,
        translateZ: 1000,
        scaleX: 1000,
        scaleY: 1000,
        rotateX: .degrees(1000),
        rotateY: .degrees(1000),
        rotateZ: .degrees(1000),
        perspective: 1,
        skewX: 1000,
        skewY: 1000
      )
    );
    
    
    
    let rangeInput: [CGFloat] = [0, 0.5, 1];
    
    let rangeOutput = [
      keyframeStart,
      keyframeHalf,
      keyframeEnd,
    ];
    
    var rangeInterpolator = try ConcreteKeyframe.RangeInterpolator(
      rangeInput: rangeInput,
      rangeOutput: rangeOutput,
      easingProvider: nil
    );
    
    let resultLerpToZero = rangeInterpolator.interpolate(inputValue: 0);
    #expect(resultLerpToZero.isZero);
    
    let resultLerpToQuarter = rangeInterpolator.interpolate(inputValue: 0.25);
    #expect(!resultLerpToQuarter.isZero);
    #expect(resultLerpToQuarter.opacity == keyframeHalf.opacity / 2);
    #expect(resultLerpToQuarter.backgroundColor == .init(red: 0.25, green: 0.25, blue: 0.25, alpha: 0.25));
    #expect(resultLerpToQuarter.transform == keyframeHalf.transform.multiplied(by: 0.5));
    
    let resultLerpToHalf = rangeInterpolator.interpolate(inputValue: 0.5);
    #expect(!resultLerpToHalf.isZero);
    #expect(resultLerpToHalf.opacity == keyframeHalf.opacity);
    #expect(resultLerpToHalf.backgroundColor == keyframeHalf.backgroundColor);
    #expect(resultLerpToHalf.transform == keyframeHalf.transform);
  
    let resultLerpToFull = rangeInterpolator.interpolate(inputValue: 1);
    #expect(!resultLerpToFull.isZero);
    #expect(resultLerpToFull.opacity == keyframeEnd.opacity);
    #expect(resultLerpToFull.backgroundColor == keyframeEnd.backgroundColor);
    #expect(resultLerpToFull.transform == keyframeEnd.transform);
  };
};
