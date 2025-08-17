//
//  PlanEntry+CoreDataProperties.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import CoreData

extension PlanEntry {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanEntry> { NSFetchRequest<PlanEntry>(entityName: "PlanEntry") }
  @NSManaged public var date: Date
  @NSManaged public var slot: String
  @NSManaged public var mealId: Int64
  @NSManaged public var name: String
  @NSManaged public var imageURL: String?
  @NSManaged public var recipeURL: String?
  @NSManaged public var owner: User?
}
