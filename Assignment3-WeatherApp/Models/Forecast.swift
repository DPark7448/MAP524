import Foundation

struct ForecastResponse: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let dt_txt: String
    let main: ForecastMain
    let weather: [ForecastWeather]
}

struct ForecastMain: Codable {
    let temp: Double
}

struct ForecastWeather: Codable {
    let icon: String
}
