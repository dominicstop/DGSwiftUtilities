//
//  UIKit+ZeroRepresentable.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/17/25.
//

import UIKit

extension UIColor: ZeroRepresentable {
  
  public static var zero: Self {
    .init(red: 0, green: 0, blue: 0, alpha: 0);
  };
};

extension UIEdgeInsets: ZeroRepresentable {
  
  public static var zero: Self {
    .init(top: 0, left: 0, bottom: 0, right: 0);
  };
};

extension UIOffset: ZeroRepresentable {
  
  public static var zero: Self {
    .init(horizontal: 0, vertical: 0);
  };
};
