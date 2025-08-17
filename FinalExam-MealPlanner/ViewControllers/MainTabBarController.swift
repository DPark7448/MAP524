//
//  MainTabBarController.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import UIKit

final class MainTabBarController: UITabBarController {
  let currentUser: User
  init(currentUser: User) { self.currentUser = currentUser; super.init(nibName: nil, bundle: nil) }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  override func viewDidLoad() {
    super.viewDidLoad()
    let fav = UINavigationController(rootViewController: FavoritesViewController(currentUser: currentUser))
    fav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 0)

    let plan = UINavigationController(rootViewController: MealPlanViewController(currentUser: currentUser))
    plan.tabBarItem = UITabBarItem(title: "Meal Plan", image: UIImage(systemName: "calendar"), tag: 1)

    viewControllers = [fav, plan]
  }
}
