//
//  Constants.swift
//  RealEstateFinder
//
//  Created by Daniel Park on 2025-08-03.
//

import Foundation

enum AppKeys {
    static var rapidAPIKey: String {
        guard let url = Bundle.main.url(forResource: "Keys", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let key = plist["RAPIDAPI_KEY"] as? String else {
            return ""
        }
        return key
    }
}
