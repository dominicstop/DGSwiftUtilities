//
//  CALayer+Helpers.swift
//  Experiments-Misc
//
//  Created by Dominic Go on 11/12/24.
//

import UIKit


public extension CALayer {

  static let commonAnimationKeys: [String] = [
    "bounds.size",
    #keyPath(CALayer.position),
    #keyPath(CALayer.transform),
    #keyPath(CALayer.backgroundColor),
    #keyPath(CALayer.opacity),
    #keyPath(CALayer.borderColor),
    #keyPath(CALayer.borderWidth),
  ];
  
  func recursivelyFindParentAnimation<T: CAAnimation>(
    forKeys keys: [String],
    shouldSkipCurrentLayer: Bool = false,
    forType type: T.Type? = T.self
  ) -> T? {
  
    var currentLayer: CALayer? = shouldSkipCurrentLayer
      ? self.superlayer
      : self;
    
    while currentLayer != nil {
      for key in keys {
        if let animation = currentLayer!.animation(forKey: key),
           let animation = animation as? T
        {
          return animation;
        };
      
        let action: CAAction? =
             currentLayer!.delegate?.action?(for: self, forKey: key)
          ?? currentLayer!.action(forKey: key);
          
        if let animation = action as? T {
          return animation;
        };
      };
      
      currentLayer = currentLayer!.superlayer;
    };
    
    return nil;
  };
  
  func recursivelyFindParentAnimation<T: CAAnimation>(
    forKey key: String,
    shouldSkipCurrentLayer: Bool = false,
    forType type: T.Type? = T.self
  ) -> CAAnimation? {
  
    self.recursivelyFindParentAnimation(
      forKeys: [key],
      shouldSkipCurrentLayer: shouldSkipCurrentLayer,
      forType: type
    );
  };
};
