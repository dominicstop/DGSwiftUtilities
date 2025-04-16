//
//  BaseFrameLayoutPartialKeyframe.swift
//  DGSwiftUtilities
//
//  Created by Dominic Go on 4/16/25.
//

import UIKit


public protocol BaseFrameLayoutPartialKeyframe:
  BasePartialKeyframe where ConcreteKeyframe: BaseFrameLayoutConcreteKeyframe
{
  var frame: CGRect? { get set };
  var contentPadding: UIEdgeInsets? { get set };
};
