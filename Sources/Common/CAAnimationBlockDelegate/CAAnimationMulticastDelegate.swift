//
//  CAAnimationMulticastDelegate.swift
//  react-native-ios-modal
//
//  Created by Dominic Go on 5/1/23.
//

import UIKit


public class CAAnimationMulticastDelegate: NSObject, CAAnimationDelegate {
  
  public var emitter = MulticastDelegate<CAAnimationDelegate>();
  
  public func animationDidStart(_ anim: CAAnimation) {
    self.emitter.invoke {
      $0.animationDidStart?(anim);
    };
  };
  
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    self.emitter.invoke {
      $0.animationDidStop?(anim, finished: flag);
    };
  };
};
