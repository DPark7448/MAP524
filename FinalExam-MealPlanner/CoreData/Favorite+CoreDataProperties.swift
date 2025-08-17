//
//  Favorite+CoreDataProperties.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import CoreData

extension Favorite {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> { NSFetchRequest<Favorite>(entityName: "Favorite") }
  @NSManaged public var mealId: Int64
  @NSManaged public var name: String
  @NSManaged public var imageURL: String?
  @NSManaged public var recipeURL: String?
  @NSManaged public var tagsJSON: String?
  @NSManaged public var owner: User?
}
