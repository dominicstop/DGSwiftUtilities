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
  
  public var isZero: Bool {
    self.degrees == 0;
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
    isClockwise: Bool = true
  ) -> Self {
    let angleLeading = self.normalized.degrees;
    let angleTrailing = otherAngle.normalized.degrees;
    
    let delta = angleLeading - angleTrailing;
    
    let needsAdj = isClockwise
      ? delta < 0
      : delta > 0;
    
    // amount to shift ccw direction
    let adj: T = {
      if needsAdj {
        return 0;
      };
      
      return abs(delta) / 2;
    }();
    
    let angleMid: T = {
      if adj == 0 {
        return (angleLeading + angleTrailing) / 2;
      };
      
      // adjust by shifting counter clockwise
      let angleLeadingShifted: Self = .degrees(angleLeading + adj);
      let angleTrailingShifted: Self = .degrees(angleTrailing + adj);
      
      // normalized to 0...360
      let angleLeading = angleLeadingShifted.normalized.degrees;
      let angleTrailing = angleTrailingShifted.normalized.degrees;
      
      let angleMidShifted = (angleLeading + angleTrailing) / 2;
      
      // undo shifting
      return angleMidShifted - adj;
    }();
    
    return .degrees(angleMid)
  };
  
  public func getPointAlongCircle(
    withRadius radius: CGFloat,
    usingCenter center: CGPoint,
    shouldFlip: Bool = true
  ) -> CGPoint {
    
    // convert degrees to radians
    let angleRadians = CGFloat(self.radians);
    
    let xRatio = shouldFlip
      ? sin(angleRadians)
      : cos(angleRadians);
      
    let yRatio = shouldFlip
      ? cos(angleRadians)
      : sin(angleRadians);
    
    let x = radius * xRatio;
    let y = radius * yRatio;
    
    return CGPoint(x: x, y: y);
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
    switch (a, b){
      case (.degrees, .radians):
        return (.degrees(a.radians), b);
        
      case (.radians, .degrees):
        return (a, .radians(a.radians));
        
      case (.radians, .radians):
        return (a, b);
        
      case (.degrees, .degrees):
        return (.radians(a.radians), .radians(b.radians));
    };
  };
};

// MARK: - Angle+CustomOperators
// -----------------------------

public extension Angle {

  static func +(lhs: Self, rhs: Self) -> Self {
    switch (lhs, rhs){
      case (.radians, .radians):
        return .radians(lhs.rawValue + rhs.rawValue);
        
      case (.degrees, .degrees):
        return .degrees(lhs.rawValue + rhs.rawValue);
        
      case (.degrees, .radians):
        return .degrees(lhs.rawValue + rhs.degrees);
        
      case (.radians, .degrees):
        return .radians(lhs.rawValue + rhs.radians);
    };
  };
  
  static func -(lhs: Self, rhs: Self) -> Self {
    switch (lhs, rhs){
      case (.radians, .radians):
        return .radians(lhs.rawValue - rhs.rawValue);
        
      case (.degrees, .degrees):
        return .degrees(lhs.rawValue - rhs.rawValue);
        
      case (.degrees, .radians):
        return .degrees(lhs.rawValue - rhs.degrees);
        
      case (.radians, .degrees):
        return .radians(lhs.rawValue - rhs.radians);
    };
  };
};
