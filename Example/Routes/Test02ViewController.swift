//
//  Test01ViewController.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 11/29/23.
//

import UIKit
import DGSwiftUtilities


class Test02ViewController: UIViewController {

  static func testForComputeMidAngle(){
    let angles: [(
      leadingAngle: Angle<CGFloat>,
      trailingAngle: Angle<CGFloat>
    )] = [
      (.degrees(0), .degrees(90)),
      (.degrees(90), .degrees(180)),
      (.degrees(180), .degrees(270)),
      (.degrees(270), .degrees(360)),
      
      (.degrees(90), .degrees(270)), // 0
      (.degrees(360 + 90), .degrees(360 + 270)), // 0
      (.degrees(45), .degrees(360 - 45)),
      (.degrees(360 + 45), .degrees(360 + 360 - 45)),
      
      (.degrees(0), .degrees(45)),
      (.degrees(45), .degrees(90)),
      (.degrees(90), .degrees(135)),
      (.degrees(135), .degrees(180)),
      (.degrees(180), .degrees(225)),
      (.degrees(225), .degrees(270)),
      (.degrees(270), .degrees(315)),
      (.degrees(315), .degrees(360)),
      
      (.degrees(360 + 0), .degrees(360 + 45)),
      (.degrees(360 + 45), .degrees(360 + 90)),
      (.degrees(360 + 90), .degrees(360 + 135)),
      (.degrees(360 + 135), .degrees(360 + 180)),
      (.degrees(360 + 180), .degrees(360 + 225)),
      (.degrees(360 + 225), .degrees(360 + 270)),
      (.degrees(360 + 270), .degrees(360 + 315)),
      (.degrees(360 + 315), .degrees(360 + 360)),
    ];
    
    for (index, (leadingAngle, trailingAngle)) in angles.enumerated() {
      let midAngle = leadingAngle.computeMidAngle(
        otherAngle: trailingAngle,
        isClockwise: false
      );
      
      print(
        "\(#function) - angle: \(index) of \(angles.count - 1)",
        "\n - leadingAngle:", leadingAngle.degrees,
        "\n - midAngle:", midAngle.degrees,
        "\n - trailingAngle:", trailingAngle.degrees,
        "\n"
      );
    };
  };
  
  static func testTriangle(){
    let triangle: Triangle = .init(
      topPoint: .init(x: 50, y: 0),
      leadingPoint: .init(x: 0, y: 100),
      trailingPoint: .init(x: 100, y: 100)
    );
    
    print(
      "original triangle",
      "\n - leadingPoint", triangle.leadingPoint,
      "\n - topPoint", triangle.topPoint,
      "\n - trailingPoint", triangle.trailingPoint,
      "\n"
    );
    
    let triangleSmaller = triangle.resizedTriangleRelativeToTopPoint(toNewHeight: 50);
    
    print(
      "triangleSmaller",
      "\n - leadingPoint", triangleSmaller.leadingPoint,
      "\n - topPoint", triangleSmaller.topPoint,
      "\n - trailingPoint", triangleSmaller.trailingPoint,
      "\n"
    );
  };

  override func loadView() {
    let view = UIView();
    view.backgroundColor = .white;
    
    self.view = view;
    // Self.testForComputeMidAngle();
    // Self.testTriangle();
  };
  
  override func viewDidLoad() {
    let initialFrame: CGRect = .init(
      origin: .init(x: 45, y: 45),
      size: .init(width: 75 * 3, height: 75 * 3)
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
    
    let polygon: PolygonPreset = .regularPolygon(numberOfSides: 4);
    
    let star: PolygonPreset = .regularStarPolygon(
      numberOfSpikes: 6,
      spikeRadius: 30
    );
    
    let superelipse: CAShapeLayer = {
      let path: UIBezierPath = .superellipse(
        in: .init(
          origin: .init(x: 10, y: 10),
          size: .init(
            width: initialFrame.size.width / 2,
            height: initialFrame.size.height / 2
          )
        ),
        cornerRadius: 75
      );
      
      let shape = CAShapeLayer();
      shape.path = path.cgPath;
      
      return shape;
    }();
    
    let shapeLayer = polygon.createShape(
      forFrame: .init(
        origin: .zero,
        size: initialFrame.size
      ),
      pointAdjustments: .init(
        shouldScaleToFitTargetRect: true,
        shouldPreserveAspectRatioWhenScaling: false,
        postTransform: .init(
          scaleX: 1 + (1 / 20),
          scaleY: 1 + (1 / 20)
        )
      ),
      pointConnectionStrategy: .continuousCurvedCorners(
        curvinessAmount: 0.25,
        curveHeightOffset: 0
      )
    );
    
    // shapeLayer = superelipse;
    
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
};
