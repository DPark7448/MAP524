//
//  SceneDelegate.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    let nav = UINavigationController(rootViewController: AuthViewController())
    window.rootViewController = nav
    self.window = window
    window.makeKeyAndVisible()
  }
}
