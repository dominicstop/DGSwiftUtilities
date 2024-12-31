//
//  SceneDelegate.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 10/23/23.
//

import UIKit
import DGSwiftUtilities

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?;
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // Use this method to optionally configure and attach the UIWindow `window`
    // to the provided UIWindowScene `scene`.
    //
    // If using a storyboard, the `window` property will automatically be
    // initialized and attached to the scene.
    //
    // This delegate does not imply the connecting scene or session are new
    // (see `application:configurationForConnectingSceneSession` instead).
    guard let windowScene = (scene as? UIWindowScene) else { return };
    
    let window = UIWindow(windowScene: windowScene);
    self.window = window;
    
    RouteManager.sharedInstance.window = window;
    RouteManager.sharedInstance.applyCurrentRoute();
    
    window.makeKeyAndVisible();
    
    if true {
      UIViewAnimatingPosition.allCases.enumerated().forEach {
        print(
          "UIViewAnimatingPosition - \($0.offset)",
          "\n - caseString:", $0.element.caseString,
          "\n - init: ", try! UIViewAnimatingPosition(fromString: $0.element.caseString).caseString,
          "\n - rawValue: ", try! UIViewAnimatingPosition(fromString: $0.element.caseString).rawValue,
          "\n"
        );
      };
      
      CACornerMask.allCases.enumerated().forEach {
        print(
          "CACornerMask - \($0.offset)",
          "\n - caseString:", $0.element.caseString,
          "\n - init: ", try! CACornerMask(fromString: $0.element.caseString).caseString,
          "\n - rawValue: ", try! CACornerMask(fromString: $0.element.caseString).rawValue,
          "\n"
        );
      };
    };
    
    
    
    
    if false {
      let test01: CGRect.InterpolatableElements = [.height, .width, .x, .y];
    
      print(
        "CGRectInterpolatableElements - test01",
        "\n - associatedAnyKeyPaths", test01.associatedAnyKeyPaths,
        "\n - getAssociatedPartialKeyPaths - CGRect", test01.getAssociatedPartialKeyPaths(forType: CGRect.self),
        "\n - getAssociatedPartialKeyPaths - CGSize", test01.getAssociatedPartialKeyPaths(forType: CGSize.self),
        "\n - getAssociatedPartialKeyPaths - CGPoint", test01.getAssociatedPartialKeyPaths(forType: CGPoint.self),
        "\n"
      );
      
      let test02: CGRect.InterpolatableElements = [.height, .x];
      print(
        "CGRectInterpolatableElements - test02",
        "\n - associatedAnyKeyPaths", test02.associatedAnyKeyPaths,
        "\n - getAssociatedPartialKeyPaths - CGRect", test02.getAssociatedPartialKeyPaths(forType: CGRect.self),
        "\n - getAssociatedPartialKeyPaths - CGSize", test02.getAssociatedPartialKeyPaths(forType: CGSize.self),
        "\n - getAssociatedPartialKeyPaths - CGPoint", test02.getAssociatedPartialKeyPaths(forType: CGPoint.self),
        "\n"
      );
      
      let test03: CGRect.InterpolatableElements = [.width,.y];
      print(
        "CGRectInterpolatableElements - test03",
        "\n - associatedAnyKeyPaths", test03.associatedAnyKeyPaths,
        "\n - getAssociatedPartialKeyPaths - CGRect", test03.getAssociatedPartialKeyPaths(forType: CGRect.self),
        "\n - getAssociatedPartialKeyPaths - CGSize", test03.getAssociatedPartialKeyPaths(forType: CGSize.self),
        "\n - getAssociatedPartialKeyPaths - CGPoint", test03.getAssociatedPartialKeyPaths(forType: CGPoint.self),
        "\n"
      );
    };
    
    if false {
      let test01: CGRect.InterpolatableElements = [.height, .width, .x, .y];
    
      print(
        "CGRectInterpolatableElements - test01",
        "\n - associatedAnyKeyPaths", test01.associatedAnyKeyPaths,
        "\n - getAssociatedAnyKeyPaths - CGRect", test01.getAssociatedAnyKeyPaths(forType: CGRect.self),
        "\n - getAssociatedAnyKeyPaths - CGSize", test01.getAssociatedAnyKeyPaths(forType: CGSize.self),
        "\n - getAssociatedAnyKeyPaths - CGPoint", test01.getAssociatedAnyKeyPaths(forType: CGPoint.self),
        "\n"
      );
      
      let test02: CGRect.InterpolatableElements = [.height, .x];
      print(
        "CGRectInterpolatableElements - test02",
        "\n - associatedAnyKeyPaths", test02.associatedAnyKeyPaths,
        "\n - getAssociatedAnyKeyPaths - CGRect", test02.getAssociatedAnyKeyPaths(forType: CGRect.self),
        "\n - getAssociatedAnyKeyPaths - CGSize", test02.getAssociatedAnyKeyPaths(forType: CGSize.self),
        "\n - getAssociatedAnyKeyPaths - CGPoint", test02.getAssociatedAnyKeyPaths(forType: CGPoint.self),
        "\n"
      );
      
      let test03: CGRect.InterpolatableElements = [.width,.y];
      print(
        "CGRectInterpolatableElements - test03",
        "\n - associatedAnyKeyPaths", test03.associatedAnyKeyPaths,
        "\n - getAssociatedAnyKeyPaths - CGRect", test03.getAssociatedAnyKeyPaths(forType: CGRect.self),
        "\n - getAssociatedAnyKeyPaths - CGSize", test03.getAssociatedAnyKeyPaths(forType: CGSize.self),
        "\n - getAssociatedAnyKeyPaths - CGPoint", test03.getAssociatedAnyKeyPaths(forType: CGPoint.self),
        "\n"
      );
    };
    
    if false {
      let test01: CGRect.InterpolatableElements = [.height, .width, .x, .y];
      let anyKeyPaths = test01.getAssociatedAnyKeyPaths(forType: CGRect.self);
      
      let map1 = CGRect.interpolatablePropertiesMap as Dictionary<AnyKeyPath, Any>;
      print("CGRect.interpolatablePropertiesMap", map1);
      
      let map2 = map1 as! Dictionary<PartialKeyPath<CGRect>, Any>;
      print("map2", map2);
      
      func test1<T>(
        rootType: T.Type,
        item: AnyKeyPath
      ) -> PartialKeyPath<T>? {
        let result = item as? PartialKeyPath<T>;
        
        print(
          "test1",
          "\n - type - rootType:", type(of: rootType),
          "\n - T.self:", T.self,
          "\n - type - T.self:", type(of: T.self),
          "\n - cast to PartialKeyPath:", PartialKeyPath<T>.self,
          "\n - rootType:", rootType,
          "\n - item:", item,
          "\n - result:", result,
          "\n"
        );
        
        return result;
      };
      
      test1(
        rootType: CGRect.self,
        item: CGRect.interpolatablePropertiesMap.keys.first! as AnyKeyPath
      );
      
      
      for anyKeyPath in anyKeyPaths {
        print(
          "anyKeyPath:", anyKeyPath,
          //"\n", CGRect.interpolatablePropertiesMap[anyKeyPath],
          "\n"
        );
      };
    
    };
    
    if false {
      let x: [CGRect.InterpolatableElements: InterpolationEasing] = [
        .height: .easeInCubic,
        .width: .easeInCubic,
      ];
    };
    
    if false {
      let items: [(desc: String, options: ClampingOptions)] = [
        ("empty", []),
        (".none", [.none]),
        (".left", [.left]),
        (".right", [.right]),
        (".left, .right", [.left, .right]),
        (".leftAndRight", [.leftAndRight]),
      ];
      
      for (index, (desc, item)) in items.enumerated() {
        print(
          "ClampingOptions test \(index + 1)",
          "\n - desc:", desc,
          "\n - ClampingOptions:", item,
          "\n - contains - left:", item.contains(.left),
          "\n - contains - right:", item.contains(.right),
          "\n - contains - leftAndRight:", item.contains(.leftAndRight),
          "\n - contains - none:", item.contains(.none),
          "\n"
        );
      }
    };
    
    if false {
      let a: (any RangeInterpolating)? = nil;
      let b = a!;
      let x = b.rangeInput;
    };
    
    // self.testClassRegistry();
  };
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its
    // session is discarded.
    //
    // Release any resources associated with this scene that can be re-created
    // the next time the scene connects.
    //
    // The scene may re-connect later, as its session was not necessarily
    // discarded (see `application:didDiscardSceneSessions` instead).
  };
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active
    // state.
    //
    // Use this method to restart any tasks that were paused (or not yet
    // started) when the scene was inactive.
  };
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive
    // state.
    //
    // This may occur due to temporary interruptions (ex. an incoming phone
    // call).
  };
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  };
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    //
    // Use this method to save data, release shared resources, and store enough
    // scene-specific state information to restore the scene back to its
    // current state.
  };
  
  // MARK: - Tests
  // -------------
  
  func testClassRegistry(){
    #if DEBUG
    for index in 0..<100 {
      ClassRegistry.shared.loadClasses() { sender, allClasses in
        print(
          "SceneDelegate.testClassRegistry",
          "\n - invocationCount:", index + 1,
          "\n - _debugTimesLoaded:", sender._debugTimesLoaded,
          "\n - allClasses count:", allClasses.count,
          "\n"
        );
      };
    };
    #endif
  };
  
  func testClassRegistry2(){
    ClassRegistry.shared.classListRetrievalMode = .copyClassList;
    for index in 0..<100 {
      ClassRegistry.shared.loadClasses() { sender, allClasses in
        print(
          "SceneDelegate.testClassRegistry2",
          "\n - classListRetrievalMode:", sender.classListRetrievalMode,
          "\n - invocationCount:", index + 1,
          "\n - _debugTimesLoaded:", sender._debugTimesLoaded,
          "\n - allClasses count:", allClasses.count,
          "\n"
        );
      };
    };
  };
};
