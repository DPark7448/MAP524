//
//  AppDelegate.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

    if UIApplication.shared.connectedScenes.isEmpty {
      let win = UIWindow(frame: UIScreen.main.bounds)
      let nav = UINavigationController(rootViewController: AuthViewController())
      win.rootViewController = nav
      win.makeKeyAndVisible()
      self.window = win
    }
    return true
  }

  func application(_ application: UIApplication,
                   configurationForConnecting connectingSceneSession: UISceneSession,
                   options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    let config = UISceneConfiguration(name: "Default Configuration",
                                      sessionRole: connectingSceneSession.role)
    config.delegateClass = SceneDelegate.self
    return config
  }
}
