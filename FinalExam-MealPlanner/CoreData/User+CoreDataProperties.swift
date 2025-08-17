//
//  User+CoreDataProperties.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import CoreData

extension User {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<User> { NSFetchRequest<User>(entityName: "User") }
  @NSManaged public var username: String
  @NSManaged public var password: String
  @NSManaged public var favorites: Set<Favorite>?
  @NSManaged public var plans: Set<PlanEntry>?
}
