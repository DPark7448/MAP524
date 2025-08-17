//
//  Models.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import Foundation

struct APIEnvelope<T: Decodable>: Decodable { let message: String?; let data: T?; let error: String? }

struct SearchData: Decodable { let count: Int?; let items: [Recipe] }

struct Recipe: Decodable {
  let id: Int
  let name: String
  let url: String?
  let times: RecipeTimes?
  let thumbnail_url: String?
  let tags: [String]?
}

struct RecipeTimes: Decodable { let total_time: TimeValue? }
struct TimeValue: Decodable { let minutes: Int? }
