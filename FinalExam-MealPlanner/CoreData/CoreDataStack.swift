//
//  CoreDataStack.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import CoreData

final class CoreDataStack {
  static let shared = CoreDataStack()
  private init() {}

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MealPlanner")
    container.loadPersistentStores { _, error in
      if let error = error { fatalError("Unresolved Core Data error: \(error)") }
    }
    return container
  }()

  var context: NSManagedObjectContext { persistentContainer.viewContext }

  func saveContext() {
    let ctx = context
    if ctx.hasChanges {
      do { try ctx.save() } catch { print("Save error: \(error)") }
    }
  }
}
