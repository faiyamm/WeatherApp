//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Fai on 20/02/26.
//

import Foundation

struct GeocodingResponse: Codable {
    let results: [GeocodingResult]?
}

struct GeocodingResult: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
}

struct ForecastResponse: Codable {
    let current_weather: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature: Double
    let windspeed: Double
    let weathercode: Int
    let time: String
    let relativehumidity: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature, windspeed, weathercode, time
        case relativehumidity = "relativehumidity_2m"
    }

    var conditionIcon: String {
        switch weathercode {
        case 0: return "sun.max.fill"
        case 1...3: return "cloud.sun.fill"
        case 45, 48: return "fog.fill"
        case 51...67: return "cloud.rain.fill"
        case 71...77: return "snowflake"
        case 80...82: return "cloud.heavyrain.fill"
        case 95...99: return "cloud.bolt.fill"
        default: return "cloud.fill"
        }
    }
}
