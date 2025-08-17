//
//  AppDelegate.swift
//  RealEstateFinder
//
//  Created by Daniel Park on 2025-08-03.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RealEstateFinder")
        container.loadPersistentStores { _, error in
            if let error = error { fatalError("Core Data load error: \(error)") }
        }
        return container
    }()

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do { try context.save() } catch { print("Core Data save error: \(error)") }
        }
    }
}
