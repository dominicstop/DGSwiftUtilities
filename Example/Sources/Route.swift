//
//  Route.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 11/29/23.
//

import UIKit
import DGSwiftUtilities


enum Route: String, CaseIterable {
  case routeList;
  case test01;
  case test02;
  case interpolationTest01;
  case imageConfigTest01;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  var rawViewController: UIViewController {
    switch self {
      case .routeList:
        return RouteListViewController();
      
      case .test01:
        return Test01ViewController();
        
      case .test02:
        return Test02ViewController();
        
      case .interpolationTest01:
        return InterpolationTest01ViewController();
        
      case .imageConfigTest01:
        return ImageConfigTest01ViewController();
    };
  };
  
  var viewController: UIViewController {
    let controller = self.rawViewController;
    controller.title = self.rawValue;
    return controller;
  };
  
  var subtitle: String {
    switch self {
      case .routeList:
        return "Route List";
        
      case .test01, .test02:
        return "Test";
        
      case .interpolationTest01:
        return "Tests for Interpolator";
        
      case .imageConfigTest01:
        return "Tests for ImageConfig";
    };
  };
  
  var description: [AttributedStringConfig] {
    switch self {
      case .routeList:
        return [
          .init(text: "Shows a list of all the available routes."),
          .newLines(2),
          .init(
            text: "Route Names: ",
            fontConfig: .init(
              size: nil,
              isBold: true
            )
          ),
          .init(
            text: Self.allRoutes.enumerated().reduce(into: ""){
              $0 += " \($1.element.rawValue)";
              
              let isLast = $1.offset == Self.allCases.count;
              $0 += isLast ? "" : ",";
            },
            fontConfig: .init(
              size: nil,
              isItalic: true
            )
          ),
          .newLines(2),
          .init(
            text: "Total Routes: ",
            fontConfig: .init(
              size: nil,
              isBold: true
            )
          ),
          .init(text: "\(Self.allCases.count) items"),
        ];
        
      case .test01:
        return [
          .init(text: "`Test01`"),
          .init(text: " - Present sheet modal`"),
        ];
        
      case .test02:
        return [
          .init(text: "`Test02`"),
          .init(text: " - TBA`"),
        ];
        
      case .interpolationTest01:
        return [];
        
      case .imageConfigTest01:
        return [
          .init(text: "Misc. test create image logic for `ImageConfig` types."),
          .init(text: "\n"),
          .init(text: "Tests for image loading logic via `ImageConfigLoader`")
        ];
    };
  };
};

extension Route {
  static var allRoutes: [Self] {
    let toBeRemoved: [Self] = [];
    
    return Self.allCases.filter {
      !toBeRemoved.contains($0)
    };
  };

  static let rootRoute: Self = .routeList;
  
  static var rootRouteIndex: Int {
    let match = Self.allCases.enumerated().first {
      $0.element == Self.rootRoute;
    };
    
    return match?.offset ?? 0;
  };
};
