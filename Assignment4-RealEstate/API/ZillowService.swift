//
//  ZillowService.swift
//  RealEstateFinder
//
//  Created by Daniel Park on 2025-08-03.
//

import Foundation

struct ZillowProperty: Codable, Hashable {
    let zpid: String?
    let id: String?
    let address: String?
    let price: Double?
    let bedrooms: Int?
    let bathrooms: Double?
    let imgSrc: String?
}

final class ZillowService {
    static let shared = ZillowService()

    private let apiKey = "c964da7d1dmsh56ba7c5cc163da4p16fc97jsn6567d1af3613"
    private let host   = "zillow-com1.p.rapidapi.com"

    func searchProperties(parameters: [String: String],
                          completion: @escaping (Result<[ZillowProperty], Error>) -> Void) {

        var components = URLComponents(string: "https://\(host)/propertyExtendedSearch")!
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else { completion(.success([])); return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(host, forHTTPHeaderField: "x-rapidapi-host")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { completion(.success([])); return }

            do {
                if let arr = try? JSONDecoder().decode([ZillowProperty].self, from: data) {
                    completion(.success(arr))
                } else {
                    let any = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    let props = (any?["properties"] ?? any?["props"]) as? [[String: Any]] ?? []
                    let decoded = try JSONDecoder().decode([ZillowProperty].self,
                                                           from: try JSONSerialization.data(withJSONObject: props))
                    completion(.success(decoded))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
