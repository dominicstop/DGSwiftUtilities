//
//  ShapeLayerStrokeStyle.swift
//  
//
//  Created by Dominic Go on 11/26/24.
//

import UIKit


public struct ShapeLayerStrokeStyle {
  
  public var lineWidth: CGFloat;
  public var strokeColor: UIColor?;
  
  public var linePattern: LineDashPattern;
  public var lineDashPhase: CGFloat;
  
  public var strokeStart: CGFloat;
  public var strokeEnd: CGFloat;
  
  public init(
    lineWidth: CGFloat,
    strokeColor: UIColor?,
    linePattern: LineDashPattern = .noPattern,
    lineDashPhase: CGFloat = 0,
    strokeStart: CGFloat = 1,
    strokeEnd: CGFloat = 0
  ) {
    self.lineWidth = lineWidth;
    self.strokeColor = strokeColor;
    self.linePattern = linePattern;
    self.lineDashPhase = lineDashPhase;
    self.strokeStart = strokeStart;
    self.strokeEnd = strokeEnd;
  };
  
  public func apply(toShape shapeLayer: CAShapeLayer){
    shapeLayer.lineWidth = self.lineWidth;
    shapeLayer.strokeColor = self.strokeColor?.cgColor;
    
    self.linePattern.apply(toShape: shapeLayer);
    shapeLayer.lineDashPhase = self.lineDashPhase;
    
    shapeLayer.strokeStart = self.strokeStart;
    shapeLayer.strokeEnd = self.strokeEnd;
  };
};

// MARK: - ShapeLayerStrokeStyle+StaticAlias
// -----------------------------------------

public extension ShapeLayerStrokeStyle {
  
  static var `default`: Self {
    .init(
      lineWidth: 0,
      strokeColor: nil,
      linePattern: .noPattern,
      lineDashPhase: 0,
      strokeStart: 1,
      strokeEnd: 0
    );
  };
  
  static var noBorder: Self {
    .init(
      lineWidth: 0,
      strokeColor: nil,
      linePattern: .noPattern
    );
  };
};
