// Networking/WeatherService.swift

import Foundation

class WeatherService {
    static func fetchWeather(lat: Double, lon: Double, completion: @escaping (ForecastResponse?) -> Void) {
        let apiKey = "39bd45bd52e9c4c4b94f8cc82df23315"  // Replace with your actual key
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            print("Invalid url")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded)
                }
            } catch {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON: \(jsonString)")
                }
                print("Decode error:", error)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }

        }.resume()
    }
}
