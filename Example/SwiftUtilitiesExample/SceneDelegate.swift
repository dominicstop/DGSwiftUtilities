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
      let test01: CGRectInterpolatableElements = [.height, .width, .x, .y];
    
      print(
        "CGRectInterpolatableElements - test01",
        "\n - associatedAnyKeyPaths", test01.associatedAnyKeyPaths,
        "\n - getAssociatedPartialKeyPaths - CGRect", test01.getAssociatedPartialKeyPaths(forType: CGRect.self),
        "\n - getAssociatedPartialKeyPaths - CGSize", test01.getAssociatedPartialKeyPaths(forType: CGSize.self),
        "\n - getAssociatedPartialKeyPaths - CGPoint", test01.getAssociatedPartialKeyPaths(forType: CGPoint.self),
        "\n"
      );
      
      let test02: CGRectInterpolatableElements = [.height, .x];
      print(
        "CGRectInterpolatableElements - test02",
        "\n - associatedAnyKeyPaths", test02.associatedAnyKeyPaths,
        "\n - getAssociatedPartialKeyPaths - CGRect", test02.getAssociatedPartialKeyPaths(forType: CGRect.self),
        "\n - getAssociatedPartialKeyPaths - CGSize", test02.getAssociatedPartialKeyPaths(forType: CGSize.self),
        "\n - getAssociatedPartialKeyPaths - CGPoint", test02.getAssociatedPartialKeyPaths(forType: CGPoint.self),
        "\n"
      );
      
      let test03: CGRectInterpolatableElements = [.width,.y];
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
      let test01: CGRectInterpolatableElements = [.height, .width, .x, .y];
    
      print(
        "CGRectInterpolatableElements - test01",
        "\n - associatedAnyKeyPaths", test01.associatedAnyKeyPaths,
        "\n - getAssociatedAnyKeyPaths - CGRect", test01.getAssociatedAnyKeyPaths(forType: CGRect.self),
        "\n - getAssociatedAnyKeyPaths - CGSize", test01.getAssociatedAnyKeyPaths(forType: CGSize.self),
        "\n - getAssociatedAnyKeyPaths - CGPoint", test01.getAssociatedAnyKeyPaths(forType: CGPoint.self),
        "\n"
      );
      
      let test02: CGRectInterpolatableElements = [.height, .x];
      print(
        "CGRectInterpolatableElements - test02",
        "\n - associatedAnyKeyPaths", test02.associatedAnyKeyPaths,
        "\n - getAssociatedAnyKeyPaths - CGRect", test02.getAssociatedAnyKeyPaths(forType: CGRect.self),
        "\n - getAssociatedAnyKeyPaths - CGSize", test02.getAssociatedAnyKeyPaths(forType: CGSize.self),
        "\n - getAssociatedAnyKeyPaths - CGPoint", test02.getAssociatedAnyKeyPaths(forType: CGPoint.self),
        "\n"
      );
      
      let test03: CGRectInterpolatableElements = [.width,.y];
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
      let test01: CGRectInterpolatableElements = [.height, .width, .x, .y];
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
    
    if true {
      let x: [CGRectInterpolatableElements: InterpolationEasing] = [
        .height: .easeInCubic,
        .width: .easeInCubic,
      ];
    };
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
};

// temp/test impl.
//
public struct CGRectInterpolatableElements: OptionSet, CompositeInterpolatableElements {
  public let rawValue: Int;
  
  public static let width  = Self(rawValue: 1 << 0);
  public static let height = Self(rawValue: 1 << 1);
  public static let x      = Self(rawValue: 1 << 2);
  public static let y      = Self(rawValue: 1 << 3);
  
  public static let size  : Self = [.width, .height];
  public static let origin: Self = [.x, .y];
  
  public var associatedAnyKeyPaths: [AnyKeyPath] {
    var keyPaths: [AnyKeyPath] = [];
    
    keyPaths.unwrapThenAppend(
        self.contains(.size  ) ? \CGRect.size
      : self.contains(.width ) ? \CGSize.width
      : self.contains(.height) ? \CGSize.height
      : nil
    );
    
    keyPaths.unwrapThenAppend(
        self.contains(.origin) ? \CGRect.origin
      : self.contains(.x     ) ? \CGPoint.x
      : self.contains(.y     ) ? \CGPoint.y
      : nil
    );
    
    return keyPaths;
  };
  
  public init(rawValue: Int) {
    self.rawValue = rawValue;
  };
};



