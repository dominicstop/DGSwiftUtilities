//
//  RouteManager.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 11/29/23.
//

import UIKit

var RouteManagerShared = RouteManager.sharedInstance;

class RouteManager {
  static let sharedInstance = RouteManager();
  
  weak var window: UIWindow?;
  
  var shouldUseNavigationController = true;
  var navController: UINavigationController?;
  
  var routes: [Route] = .Element.allCases;
  
  var routeCounter = Route.rootRouteIndex;
  
  var rootRoute: Route = Route.routeList;
  
  var currentRouteIndex: Int {
    self.routeCounter % self.routes.count;
  };
  
  var currentRoute: Route {
    self.routes[self.currentRouteIndex];
  };
  
  func applyCurrentRoute(){
    self.setRoute(self.currentRoute);
  };
  
  func setRoute(_ route: Route){
    guard let window = self.window else { return };
    
    let isUsingNavController =
      window.rootViewController is UINavigationController;
    
    let navVC: UINavigationController? = {
      guard self.shouldUseNavigationController else {
        return nil;
      };
      
      if let navController = self.navController {
        return navController;
      };
      
      var routes = [self.rootRoute];
      
      let isCurrentRouteRootRoute = self.rootRoute == self.currentRoute;
      if !isCurrentRouteRootRoute {
        routes.append(self.currentRoute);
      };
      
      let routeViewControllers = routes.map {
        $0.viewController;
      };
      
      let navVC = UINavigationController();
      navVC.setViewControllers(routeViewControllers, animated: false);
      
      self.navController = navVC;
      return navVC;
    }();
    
    if !isUsingNavController {
      window.rootViewController = navVC;
    };
    
    let nextVC = route.viewController;
    
    if self.shouldUseNavigationController,
       isUsingNavController {
      
      navVC?.pushViewController(nextVC, animated: true);
    
    } else if !self.shouldUseNavigationController {
      window.rootViewController = nextVC;
    };
  };
};


