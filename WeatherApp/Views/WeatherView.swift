//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Fai on 20/02/26.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var weatherViewModel = WeatherViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    HStack {
                        TextField("Search City...", text: $weatherViewModel.searchText)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .autocorrectionDisabled()
                        
                        Button {
                            Task { await weatherViewModel.searchWeather() }
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .padding(12)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal)

                    if weatherViewModel.isLoading {
                        ProgressView().scaleEffect(1.5)
                    } else if let weather = weatherViewModel.weather {
                        VStack(spacing: 15) {
                            Text(weatherViewModel.cityName)
                                .font(.system(size: 32, weight: .bold))
                            
                            Image(systemName: weather.conditionIcon)
                                .font(.system(size: 80))
                                .symbolRenderingMode(.multicolor)
                            
                            Text("\(Int(weather.temperature))°C")
                                .font(.system(size: 60, weight: .thin))
                            
                            Divider()
                            
                            HStack(spacing: 40) {
                                WeatherStat(label: "Wind", value: "\(weather.windspeed)km/h", icon: "wind")
                                WeatherStat(label: "Humidity", value: "N/A", icon: "drop.fill")
                            }
                        }
                        .padding(30)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(.white.opacity(0.2), lineWidth: 1))
                        .padding()
                    }

                    if !weatherViewModel.errorMessage.isEmpty {
                        Text(weatherViewModel.errorMessage)
                            .foregroundStyle(.red)
                            .padding()
                    }
                    Spacer()
                }
            }
            .navigationTitle("WeatherWise")
        }
    }
}

struct WeatherStat: View {
    let label: String
    let value: String
    let icon: String
    var body: some View {
        VStack {
            Image(systemName: icon)
            Text(value).bold()
            Text(label).font(.caption).opacity(0.7)
        }
    }
}
