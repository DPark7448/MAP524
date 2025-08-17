//
//  City.swift
//  WeatherApp
//
//  Created by Daniel Park on 2025-07-23.
//

import Foundation

struct City: Codable, Equatable {
    let name: String
    let countryCode: String
    let stateCode: String
    let latitude: String
    let longitude: String

    static func ==(lhs: City, rhs: City) -> Bool {
        return lhs.name == rhs.name
            && lhs.countryCode == rhs.countryCode
            && lhs.stateCode == rhs.stateCode
            && lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
    }
}
