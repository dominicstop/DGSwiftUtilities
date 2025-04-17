//
//  CoreGraphics+ZeroRepresentable.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/17/25.
//

import UIKit
import CoreGraphics


extension CGFloat: ZeroRepresentable {
  // no-op
};

extension CGRect: ZeroRepresentable {
  // no-op
};

extension CGSize: ZeroRepresentable {
  // no-op
};

extension CGPoint: ZeroRepresentable {
  // no-op
};

extension CGVector: ZeroRepresentable {
  // no-op
};

@available(iOS 13.0, *)
extension CGColor: ZeroRepresentable {
  
  public static var zero: Self {
    return .init(red: 0, green: 0, blue: 0, alpha: 0);
  };
};
