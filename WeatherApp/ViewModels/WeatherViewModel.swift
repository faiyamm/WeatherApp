//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Fai on 20/02/26.
//

import Foundation
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var cityName: String = ""
    @Published var weather: CurrentWeather?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    private let weatherNetworkService = WeatherService()
    
    func searchWeather() async {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            self.errorMessage = "Please enter a city name."
            return
        }
        
        self.errorMessage = ""
        self.isLoading = true
        
        do {
            let result = try await weatherNetworkService.fetchCurrentWeather(forCity: trimmedText)
            self.cityName = result.cityName
            self.weather = result.weather
            self.isLoading = false
        } catch {
            self.errorMessage = "Could not find weather data for \(trimmedText)."
            self.isLoading = false
        }
    }
}
