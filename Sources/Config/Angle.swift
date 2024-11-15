//
//  Angle.swift
//  
//
//  Created by Dominic Go on 8/7/23.
//

import Foundation


public enum Angle<T: BinaryFloatingPoint>: Equatable, Comparable {
  
  case radians(T);
  case degrees(T);
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var radians: T {
    guard !self.rawValue.isZero else {
      return 0;
    };
  
    switch self {
      case let .degrees(value):
        return value * (T.pi / 180);
        
      case let .radians(value):
        return value;
    };
  };
  
  public var degrees: T {
    guard !self.rawValue.isZero else {
      return 0;
    };
    
    switch self {
      case let .degrees(value):
        return value;
        
      case let .radians(value):
        return value * (180 / T.pi);
    };
  };
  
  public var rawValue: T {
    get {
      switch self {
        case .zero:
          return 0;
          
        case let .radians(value):
          return value;
          
        case let .degrees(value):
          return value;
      };
    }
    set {
      switch self {
        case .zero:
          self = .zero;
          
        case let .radians(value):
          self = .radians(value);
          
        case let .degrees(value):
          self = .degrees(value);
      };
    }
  };
  
  public var normalized: Self {
    let normalizedDegrees =
      self.degrees.truncatingRemainder(dividingBy: 360);
          
    let adj: T = {
      // written this way to prevent comparison via equatable
      if normalizedDegrees.isLess(than: 0) {
        return 360;
      };
      
      if T(360).isLess(than: normalizedDegrees) {
        return -360;
      };
      
      return 0;
    }();
        
    let normalizedDegreesAdj = normalizedDegrees + adj;
    return .degrees(normalizedDegreesAdj);
  };
  
  // MARK: - Functions
  // -----------------
  
  public func wrap(otherValue: T) -> Self {
    switch self {
      case .radians:
        return .radians(otherValue);
        
      case .degrees:
        return .degrees(otherValue);
    };
  };
  
  public func computeMidAngle(
    otherAngle: Self,
    shouldNormalize: Bool = true
  ) -> Self {
    let angles = Self.normalizeToDegrees(self, otherAngle);
    
    // normalize angles to the range [-π, π]
    let angleLeading = shouldNormalize
      ? angles.a.normalized
      : angles.a;
      
    let angleTrailing = shouldNormalize
      ? angles.b.normalized
      : angles.b;

    // calculate the raw midpoint
    let midAngleRaw = (angleLeading.rawValue + angleTrailing.rawValue) / 2;
    let midAngle: Self = .degrees(midAngleRaw);
    
    let midAngleAdj = shouldNormalize ? midAngle.normalized : midAngle;
    return midAngleAdj;
  };
};

// MARK: - Angle+StaticAlias
// -------------------------

public extension Angle {

  static var zero: Self {
    .degrees(0);
  };
};

// MARK: - Angle+EnumCaseStringRepresentable
// -----------------------------------------

extension Angle: EnumCaseStringRepresentable {

  public var caseString: String {
    switch self {
      case .radians:
        return "radians";
        
      case .degrees:
        return "degrees";
    };
  };
};

// MARK: - Angle+StaticHelpers
// ---------------------------

public extension Angle {

  static func normalizeToDegrees(_ a: Self, _ b: Self) -> (a: Self, b: Self){
    switch (a, b){
      case (.degrees, .radians):
        return (a, .degrees(b.degrees));
        
      case (.radians, .degrees):
        return (.degrees(a.degrees), b);
        
      case (.radians, .radians):
        return (.degrees(a.degrees), .degrees(b.degrees));
        
      case (.degrees, .degrees):
        return (a, b);
    };
  };
  
  static func normalizeToRadians(_ a: Self, _ b: Self) -> (a: Self, b: Self){
    let (normalizedA, normalizedB) = Self.normalizeToDegrees(a, b);
    
    return (
      .radians(normalizedA.radians),
      .radians(normalizedB.radians)
    );
  };
};
