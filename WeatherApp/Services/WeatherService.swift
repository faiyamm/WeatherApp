//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Fai on 20/02/26.
//

import Foundation

final class WeatherService {
    
    func fetchCurrentWeather(forCity city: String) async throws -> (cityName: String, weather: CurrentWeather) {
        let geocodingResult = try await fetchCoordinates(forCity: city)
        let currentWeather = try await fetchWeather(latitude: geocodingResult.latitude, longitude: geocodingResult.longitude)
        return (geocodingResult.name, currentWeather)
    }
    
    private func fetchCoordinates(forCity city: String) async throws -> GeocodingResult {
        var urlComponents = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "name", value: city),
            URLQueryItem(name: "count", value: "1"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]
        
        guard let url = urlComponents?.url else { throw NetworkError.invalidUrl }
        let data = try await performGetRequest(url: url)
        let response = try JSONDecoder().decode(GeocodingResponse.self, from: data)
        
        if let firstResult = response.results?.first {
            return firstResult
        }
        throw NetworkError.noResults
    }
    
    private func fetchWeather(latitude: Double, longitude: Double) async throws -> CurrentWeather {
        var urlComponents = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current_weather", value: "true"),
            URLQueryItem(name: "hourly", value: "relativehumidity_2m"),
            URLQueryItem(name: "timezone", value: "auto")
        ]
        
        guard let url = urlComponents?.url else { throw NetworkError.invalidUrl }
        let data = try await performGetRequest(url: url)
        return try JSONDecoder().decode(ForecastResponse.self, from: data).current_weather
    }
    
    private func performGetRequest(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badStatusCode(statusCode: httpResponse.statusCode)
        }
        return data
    }
}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case badStatusCode(statusCode: Int)
    case noResults
}
