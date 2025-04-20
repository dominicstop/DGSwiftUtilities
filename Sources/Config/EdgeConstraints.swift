//
//  EdgeConstraints.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/21/25.
//

import UIKit


public struct EdgeConstraints: Equatable {
  
  public var left: NSLayoutConstraint?;
  public var right: NSLayoutConstraint?;
  public var top: NSLayoutConstraint?;
  public var bottom: NSLayoutConstraint;
  
  init(
    left: NSLayoutConstraint? = nil,
    right: NSLayoutConstraint? = nil,
    top: NSLayoutConstraint? = nil,
    bottom: NSLayoutConstraint
  ) {
    self.left = left
    self.right = right
    self.top = top
    self.bottom = bottom
  };
};
