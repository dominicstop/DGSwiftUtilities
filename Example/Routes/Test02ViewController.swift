//
//  Test01ViewController.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 11/29/23.
//

import UIKit
import DGSwiftUtilities


struct PolygonConfig {

  var pointsAlongCircle: [Angle<CGFloat>];
  var bounds: CGRect;
  var rotation: CGFloat = 0;
  var shouldAdjustToFitInsideBounds: Bool;

  
  init(
    pointsAlongCircle: [Angle<CGFloat>],
    bounds: CGRect,
    rotation: CGFloat,
    shouldAdjustToFitInsideBounds: Bool
  ) {
    self.pointsAlongCircle = pointsAlongCircle;
    self.bounds = bounds;
    self.rotation = rotation;
    self.shouldAdjustToFitInsideBounds = shouldAdjustToFitInsideBounds;
  };
  
  
  // triangleEqual
  // triangleRight
  // triangleIsoceles
  // triangleCustom
  // square
  //

};


class Test02ViewController: UIViewController {

  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;
    
    self.view = view;
  };
  
  override func viewDidLoad() {
    let initialFrame: CGRect = .init(
      origin: .init(x: 30, y: 30),
      size: .init(width: 75, height: 75)
    );
    
    let boxWrapperView = {
      let view = UIView();
      view.backgroundColor = .gray;
      view.frame = initialFrame;
      
      return view;
    }();
  
    let boxView: ViewKeyframeable = {
      let view = ViewKeyframeable();
      view.backgroundColor = .red;
      view.cornerRadiusConfig = .none;
      
      return view;
    }();
    
    boxWrapperView.addSubview(boxView);
    boxView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint.activate([
      boxView.leadingAnchor.constraint(
        equalTo: boxWrapperView.leadingAnchor
      ),
      boxView.trailingAnchor.constraint(
        equalTo: boxWrapperView.trailingAnchor
      ),
      boxView.topAnchor.constraint(
        equalTo: boxWrapperView.topAnchor
      ),
      boxView.bottomAnchor.constraint(
        equalTo: boxWrapperView.bottomAnchor
      ),
    ]);
    
    self.view.addSubview(boxWrapperView);
    
    let nextFrame: CGRect = .init(
      origin: .init(x: 100, y: 100),
      size: .init(width: 250, height: 250)
    );
    
    boxView.prevFrame = initialFrame;
    boxWrapperView.layoutIfNeeded();
    boxView.layoutIfNeeded();
    
    
    let shapeLayer = ShapePoints.regularPolygon(
      numberOfSides: 3
    ).createShape(
      forFrame: .init(
        origin: .zero,
        size: initialFrame.size
      )
    );
    
    boxView.layer.addSublayer(shapeLayer);
    return;
    
    print("Animation start\n");
    
    UIView.animate(withDuration: 3, delay: 1) {
      boxView.backgroundColor = .yellow;
      boxWrapperView.frame = nextFrame;
      
      // boxWrapperView.layoutIfNeeded();

      
    } completion: { _ in
      print("Animation end\n");
      
      self.view.setNeedsLayout();
      boxView.setNeedsLayout();
      boxWrapperView.setNeedsLayout();
      
      self.view.layoutIfNeeded();
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    
    };
  };
}
