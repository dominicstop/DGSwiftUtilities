//
//  Foundation+ZeroRepresentable.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/17/25.
//

import Foundation


extension Double: ZeroRepresentable {
  // no-op
};

extension Int: ZeroRepresentable {
  // no-op
};

extension UInt: ZeroRepresentable {
  // no-op
};

extension UInt16: ZeroRepresentable {
  // no-op
};

extension UInt32: ZeroRepresentable {
  // no-op
};

extension UInt64: ZeroRepresentable {
  // no-op
};

extension Float: ZeroRepresentable {
  // no-op
};

@available(iOS 14.0, *)
extension Float16: ZeroRepresentable {
  // no-op
};

@available(iOS 16.0, *)
extension Duration: ZeroRepresentable {
  // no-op
};

extension NSNumber: ZeroRepresentable {
  
  public static var zero: Self {
    .init();
  };
};
