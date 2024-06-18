//
//  ImageConfigSystem.swift
//  ConfigBasedModalExample
//
//  Created by Dominic Go on 6/8/24.
//

import UIKit

@available(iOS 13.0, *)
public struct ImageConfigSystem {
  public enum ColorType {
    case hierarchicalColor(UIColor);
    case paletteColors([UIColor]);
    case tintColor(UIColor);
  };

  public var systemName: String;
  
  public var pointSize: CGFloat?;
  public var weight: UIImage.SymbolWeight?;
  public var scale: UIImage.SymbolScale?;
  
  public var color: ColorType?;
  
  // MARK: - Computed Properties
  // ---------------------------

  public var symbolConfigs: [UIImage.SymbolConfiguration] {
    var configs: [UIImage.SymbolConfiguration] = [];
    
    if let pointSize = self.pointSize {
      configs.append( .init(pointSize: pointSize) );
    };
    
    if let weight = self.weight {
      configs.append( .init(weight: weight) );
    };
    
    if let scale = self.scale {
      configs.append( .init(scale: scale) );
    };
    
    #if swift(>=5.5)
    switch self.color {
      case let .hierarchicalColor(color):
        guard #available(iOS 15.0, *) else { break };
        configs.append(
          .init(hierarchicalColor: color)
        );
        
      case let .paletteColors(colors):
        guard #available(iOS 15.0, *) else { break };
        configs.append(
          .init(paletteColors: colors)
        );
        
      default:
        break;
    };
    #endif
    
    return configs;
  };
  
  public var symbolConfig: UIImage.SymbolConfiguration? {
    var combinedConfig: UIImage.SymbolConfiguration?;
    
    for config in symbolConfigs {
      if let prevCombinedConfig = combinedConfig {
        combinedConfig = prevCombinedConfig.applying(config);
        
      } else {
        combinedConfig = config;
      };
    };
    
    return combinedConfig;
  };
  
  public var baseImage: UIImage? {
    if let symbolConfig = symbolConfig {
      return UIImage(
        systemName: self.systemName,
        withConfiguration: symbolConfig
      );
    };
    
    return UIImage(systemName: self.systemName);
  };
  
  public var image: UIImage? {
    guard let image = self.baseImage else {
      return nil;
    };
    
    switch self.color {
      case let .tintColor(color):
        return image.withTintColor(
          color,
          renderingMode: .alwaysOriginal
        );
        
      default:
        return image;
    };
  };
  
  init(
    systemName: String,
    pointSize: CGFloat? = 16,
    weight: UIImage.SymbolWeight? = .regular,
    scale: UIImage.SymbolScale? = .default,
    color: ColorType? = nil
  ) {
    self.systemName = systemName;
    self.pointSize = pointSize;
    self.weight = weight;
    self.scale = scale;
    self.color = color;
  };
};
