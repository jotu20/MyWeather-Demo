//
//  ForecastView.swift
//  MyWeather
//
//  Created by Joseph Szafarowicz on 9/3/26.
//

import SwiftUI
import CoreLocation
import MapKit
import WeatherKit

struct ForecastView: View {
    @StateObject var weatherManager = WeatherKitManager()
    @State private var cityName: String?
    var location: CLLocation? = nil

    var locationName: String = "City unavailable"
    var temperature: String = "--°"
    var conditionSymbolName: String = "cloud.fill"
    var temperatureUnit: TemperatureUnit = .fahrenheit
    var previewDays: [ForecastDay] = []
    var isDemo = false

    private var forecastDays: [ForecastDay] {
        if let forecast = weatherManager.dayWeather {
            return forecast.forecast.prefix(5).map {
                ForecastDay(
                    date: $0.date,
                    highTemperature: $0.highTemperature,
                    symbolName: $0.symbolName,
                    precipitationChance: $0.precipitationChance
                )
            }
        }
        return Array(previewDays.prefix(5))
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(isDemo ? "Demo · Sample Weather" : "Current Location")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(cityName ?? locationName)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                HStack(spacing: 10) {
                    Image(systemName: weatherManager.currentWeather?.symbolName ?? conditionSymbolName)
                        .symbolRenderingMode(.multicolor)
                        .font(.largeTitle)
                        .accessibilityHidden(true)
                    Text(weatherManager.currentWeather.map { getTemperature($0.temperature, unit: temperatureUnit) } ?? temperature)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            if weatherManager.isLoading {
                ProgressView("Loading weather…")
            }
            if let error = weatherManager.errorMessage {
                Text(error).foregroundStyle(.secondary)
                Button("Retry") {
                    Task { await loadWeather() }
                }
            }
            
            ForEach(forecastDays, id: \.date) { weather in
                DayForecastView(
                    day: weather.date.formatted(
                        Date.FormatStyle(timeZone: weatherManager.timeZone)
                            .weekday(.abbreviated)
                    ),
                    temperature: getTemperature(
                        weather.highTemperature,
                        unit: temperatureUnit
                    ),
                    conditionSymbolName: weather.symbolName,
                    precipitation: getPercentage(weather.precipitationChance)
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task(id: location) { await loadWeather() }
        .task(id: location) { await loadCityName() }
    }

    private func loadCityName() async {
        cityName = nil
        guard let location,
              let request = MKReverseGeocodingRequest(location: location) else { return }
        do {
            let mapItems = try await request.mapItems
            try Task.checkCancellation()
            cityName = mapItems.first?.addressRepresentations?.cityName
        } catch {
            // Keep the fallback title if the city cannot be resolved.
        }
    }

    private func loadWeather() async {
        guard let location else { return }
        await weatherManager.getWeatherData(location: location)
    }
}

#Preview {
    ForecastView(
        locationName: MockData.locationName,
        temperature: MockData.temperature,
        conditionSymbolName: MockData.conditionSymbolName,
        previewDays: MockData.forecastDays
    )
}
