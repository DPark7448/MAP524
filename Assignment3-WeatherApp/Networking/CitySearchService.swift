//
//  CitySearchService.swift
//  WeatherApp
//
//  Created by Daniel Park on 2025-07-23.
//

import Foundation

class CitySearchService {
    struct APIResponse: Codable {
        let data: [City]
    }

    static func searchCity(input: String, completion: @escaping ([City]) -> Void) {
        let urlString = "https://city-search2.p.rapidapi.com/city/autocomplete?input=\(input)"
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("03260d8480mshfb5c7911e28e14bp1a4e43jsn792bfe17dfab", forHTTPHeaderField: "x-rapidapi-key")
        request.setValue("city-search2.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }

            if let response = try? JSONDecoder().decode(APIResponse.self, from: data) {
                DispatchQueue.main.async {
                    completion(response.data)
                }
            } else {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }
}
