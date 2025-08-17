//
//  CityStorage.swift
//  WeatherApp
//
//  Created by Daniel Park on 2025-07-23.
//

import Foundation

class CityStorage {
    private static let key = "SavedCities"

    static func load() -> [City] {
        guard
          let data = UserDefaults.standard.data(forKey: key),
          let cities = try? PropertyListDecoder().decode([City].self, from: data)
        else { return [] }
        return cities
    }

    static func save(_ cities: [City]) {
        guard let data = try? PropertyListEncoder().encode(cities) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func add(_ city: City) {
        var all = load()
        all.append(city)
        save(all)
    }
}
