//
//  BaseConcreteKeyframe.swift
//  AdaptiveModal
//
//  Created by Dominic on 4/9/25.
//

import UIKit


public protocol BaseConcreteKeyframe<PartialKeyframe>:
  CompositeInterpolatable,
  KeyframeAppliable,
  KeyframeAnimating,
  Equatable
{
  
  associatedtype PartialKeyframe: BasePartialKeyframe;
  
  static var `default`: Self { get };
  
  typealias KeyframePropertyMap = Dictionary<
    AnyWritableKeyPath<PartialKeyframe>,
    AnyWritableKeyPath<Self>
  >;
  
  static var partialToConcreteKeyframePropertyMap: KeyframePropertyMap { get };
};

// MARK: - BaseConcreteKeyframe+Default
// ------------------------------------

public extension BaseConcreteKeyframe {
  
  static var partialToConcreteKeyframePropertyMap: KeyframePropertyMap {
    var combinedMap: KeyframePropertyMap = [:];
    var totalMapCount = 0;
    
    if let concreteKeyframeType =
        Self.self as? any BaseViewConcreteKeyframe.Type
    {
      let extractedMap = concreteKeyframeType
        .extractBaseViewPartialToConcreteKeyframePropertyMap(forType: Self.self);
      
      combinedMap.merge(with: extractedMap);
      totalMapCount += extractedMap.count;
    };
    
    if let concreteKeyframeType =
        Self.self as? any BaseLayerBorderConcreteKeyframe.Type
    {
      let extractedMap = concreteKeyframeType
        .extractBaseLayerShadowPartialToConcreteKeyframePropertyMap(forType: Self.self);
      
      combinedMap.merge(with: extractedMap);
      totalMapCount += extractedMap.count;
    };
    
    if let concreteKeyframeType =
        Self.self as? any BaseLayerShadowConcreteKeyframe.Type
    {
      let extractedMap = concreteKeyframeType
        .extractBaseLayerShadowPartialToConcreteKeyframePropertyMap(forType: Self.self);
      
      combinedMap.merge(with: extractedMap);
      totalMapCount += extractedMap.count;
    };
    
    if let concreteKeyframeType =
        Self.self as? any BaseLayerSystemCornerRadiusConcreteKeyframe.Type
    {
      let extractedMap = concreteKeyframeType
        .extractBaseLayerSystemCornerRadiusPartialToConcreteKeyframePropertyMap(forType: Self.self);
      
      combinedMap.merge(with: extractedMap);
      totalMapCount += extractedMap.count;
    };
    
    #if DEBUG
    if combinedMap.count != totalMapCount {
      print(
        #function,
        "Warning:",
        "\(totalMapCount) properties were extracted from \(String(describing: Self.self)),",
        "but `combinedMap` only contains: \(combinedMap.count)`",
        "some properties might have been overwritten due to key collision"
      );
    }
    #endif
    
    return combinedMap;
  };
}

// MARK: - BaseConcreteKeyframe+KeyframeAppliable (Default Conformance)
// --------------------------------------------------------------------

public extension KeyframeAppliable {
  
  func apply(
    toTarget target: KeyframeTarget
  ) throws where KeyframeTarget: UIView {
  
    self.applyBaseKeyframe(toView: target);
    self.applyBaseLayerKeyframe(toLayer: target.layer);
  };
  
  func apply(
    toTarget target: KeyframeTarget
  ) throws where KeyframeTarget: CALayer {
    
    self.applyBaseLayerKeyframe(toLayer: target);
  };
};
// MARK: - BaseConcreteKeyframe+ZeroRepresentable
// ------------------------------------

extension BaseConcreteKeyframe {
  
  public static var zero: Self {
    var value: Self = .default;
    
    Self.partialToConcreteKeyframePropertyMap.forEach {
      switch $1.partialKeyPath.valueTypeAsType {
        case let type as ZeroRepresentable.Type:
          do {
            try $1.setValue(
              target: &value,
              withValue: type.zero
            );
            
          } catch {
            fallthrough;
          };
          
        default:
          #if DEBUG
          print(
            #function,
            "\n - Unable to set zero value for path: \($1.partialKeyPath)",
            "\n - with type: \($1.partialKeyPath.valueTypeAsString)",
            "\n - using default value of: \(value[keyPath: $1.partialKeyPath])",
            "\n"
          );
          #endif
          break;
      };
    };
    
    return value;
  };
  
  public var isZero: Bool {
    Self.partialToConcreteKeyframePropertyMap.allSatisfy {
      let currentValue = self[keyPath: $1.partialKeyPath];
      
      switch currentValue {
        case let currentValueRefined as ZeroRepresentable:
          return currentValueRefined.isZero;
          
        default:
          return true;
      };
    };
  };
};

// MARK: - BaseConcreteKeyframe+InterpolatableValue
// ------------------------------------

public extension BaseConcreteKeyframe where InterpolatableValue == Self {
  
  static var interpolatablePropertiesMap: InterpolatableValuesMap {
    Self.partialToConcreteKeyframePropertyMap.reduce(into: [:]) {
      let concreteKeyframeAnyKeyPath = $1.value;
      
      guard let uniformInterpolatableType =
              concreteKeyframeAnyKeyPath.partialKeyPath.valueTypeAsType as? any UniformInterpolatable.Type
      else {
        #if DEBUG
        print(
          "BaseConcreteKeyframe.interpolatablePropertiesMap",
          "\n - Error: Could not find uniform interpolatable type for keypath: \(concreteKeyframeAnyKeyPath.partialKeyPath)",
          "\n - Total keyframes to map: \(Self.partialToConcreteKeyframePropertyMap.count)",
          "\n - Current map element count: \($0.count)",
          "\n - Note: Make sure that the concrete keyframe conforms to `UniformInterpolatable"
        );
        #endif
        return;
      };
      
      $0[concreteKeyframeAnyKeyPath] = uniformInterpolatableType;
    }
  };
  
  init() {
    self = .default;
  }
};

// MARK: - BaseConcreteKeyframe+Helpers
// ------------------------------------

public extension BaseConcreteKeyframe {
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var asPartialKeyframe: PartialKeyframe {
    var partialKeyframe: PartialKeyframe = .empty;
    self.apply(toPartialKeyframe: &partialKeyframe);
    return partialKeyframe;
  };
  
  // MARK: - Init
  // ------------
  
  init(
    from partialKeyframe: PartialKeyframe,
    fallbackKeyframe: Self = .default
  ){
    var concreteKeyframe: Self = .default;
    concreteKeyframe.apply(
      sourcePartialKeyframe: partialKeyframe,
      fallbackKeyframe: fallbackKeyframe
    );
    
    self = concreteKeyframe;
  };
  
  // MARK: - Functions
  // -----------------
  
  func apply(toPartialKeyframe partialKeyframe: inout PartialKeyframe){
    Self.partialToConcreteKeyframePropertyMap.forEach {
      let (partialKeyframePath, concreteKeyframePath) = $0;
      
      let newValue = self[keyPath: concreteKeyframePath.partialKeyPath];
      try? partialKeyframePath.setValue(
        target: &partialKeyframe,
        withValue: newValue
      );
    };
  };
  
  mutating func apply(
    sourcePartialKeyframe partialKeyframe: PartialKeyframe,
    fallbackKeyframe: Self = .default
  ) {
    Self.partialToConcreteKeyframePropertyMap.forEach {
      let (partialKeyframePath, concreteKeyframePath) = $0;
      
      let newValue = partialKeyframe[keyPath: partialKeyframePath.partialKeyPath];
      try? concreteKeyframePath.setValue(
        target: &self,
        withValue: newValue
      );
    };
  };
};
