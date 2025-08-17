//
//  TastyAPI.swift
//  MealPlanner
//
//  Created by Daniel Park on 2025-08-11.
//

import Foundation

final class TastyAPI {
  static let shared = TastyAPI(); private init() {}

  private let base = URL(string: "https://tasty-api1.p.rapidapi.com")!
  private let headers = [
    "x-rapidapi-key": "c964da7d1dmsh56ba7c5cc163da4p16fc97jsn6567d1af3613",
    "x-rapidapi-host": "tasty-api1.p.rapidapi.com"
  ]

  func searchRecipes(query: String) async throws -> [Recipe] {
    var comps = URLComponents(url: base.appending(path: "/recipe/search"), resolvingAgainstBaseURL: false)!
    comps.queryItems = [
      .init(name: "query", value: query),
      .init(name: "page", value: "1"),
      .init(name: "perPage", value: "20")
    ]
    var req = URLRequest(url: comps.url!)
    req.httpMethod = "GET"
    headers.forEach { req.addValue($0.value, forHTTPHeaderField: $0.key) }

    let (data, resp) = try await URLSession.shared.data(for: req)
    guard (resp as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
    let env = try JSONDecoder().decode(APIEnvelope<SearchData>.self, from: data)
    return env.data?.items ?? []
  }

  func featured() async throws -> [Recipe] {
    var req = URLRequest(url: base.appending(path: "/featured-section"))
    req.httpMethod = "GET"
    headers.forEach { req.addValue($0.value, forHTTPHeaderField: $0.key) }
    let (data, resp) = try await URLSession.shared.data(for: req)
    guard (resp as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
    struct FeaturedPayload: Decodable { let items: [Recipe] }
    let env = try JSONDecoder().decode(APIEnvelope<FeaturedPayload>.self, from: data)
    return env.data?.items ?? []
  }
}

