//
//  CoreDataManager.swift
//  RealEstateFinder
//
//  Created by Daniel Park on 2025-08-08.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    var context: NSManagedObjectContext { (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext }
    func save() { (UIApplication.shared.delegate as! AppDelegate).saveContext() }
}
