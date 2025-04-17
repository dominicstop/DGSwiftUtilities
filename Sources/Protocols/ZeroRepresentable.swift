//
//  ZeroRepresentable.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/17/25.
//

public protocol ZeroRepresentable {
  
  static var zero: Self { get };
  
  var isZero: Bool { get };
};

// MARK: - ZeroRepresentable+Default
// ---------------------------------

public extension ZeroRepresentable where Self: Equatable {
  
  var isZero: Bool {
    self == .zero;
  }
};
