//
//  WeakRef.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 3/11/23.
//

import UIKit


public class WeakRef<T> {
  public weak var rawRef: AnyObject?;
  
  public var ref: T? {
    self.rawRef as? T;
  };
  
  public init(with ref: T) {
    self.rawRef = ref as AnyObject;
  };
  
  public init?(with ref: T?) {
    guard let unwrappedRef = ref else { return nil };
    self.rawRef = unwrappedRef as AnyObject;
  };
};
