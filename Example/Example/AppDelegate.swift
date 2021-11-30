//
//  AppDelegate.swift
//  Example
//
//  Created by magna on 26/11/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var navigationController: UINavigationController = UINavigationController()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let nc = UINavigationController(rootViewController: ViewController())
    self.window?.rootViewController = nc
    window?.makeKeyAndVisible()
    
    return true
  }
}

