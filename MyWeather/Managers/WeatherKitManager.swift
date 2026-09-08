//
//  WeatherKitManager.swift
//  MyWeather
//
//  Created by Joseph Szafarowicz on 9/8/26.
//

import Foundation
import CoreLocation
import WeatherKit
import Combine

@MainActor
final class WeatherKitManager: ObservableObject {

    #if LIVE_WEATHER
    private let weatherService = WeatherService()
    #endif
    @Published private(set) var isLoaded = false
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var currentWeather: CurrentWeather?
    @Published private(set) var minuteWeather: Forecast<MinuteWeather>?
    @Published private(set) var hourWeather: [HourWeather]?
    @Published private(set) var dayWeather: Forecast<DayWeather>?
    @Published private(set) var weatherAlerts: [WeatherAlert]?
    @Published private(set) var attribution: WeatherAttribution?
    @Published private(set) var timeZone: TimeZone = .current
    private var latestRequestID: UUID?

    /// Supply the selected location's time zone when it differs from the device's.
    func getWeatherData(timeZone: TimeZone = .current, location: CLLocation) async {
        #if LIVE_WEATHER
        let requestID = UUID()
        latestRequestID = requestID
        isLoaded = false
        isLoading = true
        errorMessage = nil
        // Clear the previous location's data before starting a new request.
        currentWeather = nil
        minuteWeather = nil
        hourWeather = nil
        dayWeather = nil
        weatherAlerts = nil
        
        defer {
            if latestRequestID == requestID { isLoading = false }
        }

        do {
            let weather = try await weatherService.weather(for: location)
            try Task.checkCancellation()
            guard latestRequestID == requestID else { return }

            var calendar = Calendar.current
            calendar.timeZone = timeZone
            let currentHour = calendar.dateInterval(of: .hour, for: Date())?.start ?? Date()
            currentWeather = weather.currentWeather
            minuteWeather = weather.minuteForecast
            dayWeather = weather.dailyForecast
            weatherAlerts = weather.weatherAlerts
            self.timeZone = timeZone
            hourWeather = weather.hourlyForecast.forecast

            isLoaded = true
            // Attribution has its own failure state; it must not discard fetched weather.
            do {
                let attribution = try await weatherService.attribution
                try Task.checkCancellation()
                guard latestRequestID == requestID else { return }
                self.attribution = attribution
            } catch {
                guard latestRequestID == requestID, !Task.isCancelled else { return }
                errorMessage = "Weather loaded, but attribution could not be loaded: \(error.localizedDescription)"
            }
        } catch {
            guard latestRequestID == requestID, !Task.isCancelled else { return }
            errorMessage = "Unable to load weather: \(error.localizedDescription)"
        }
        #else
        // Demo builds cannot issue WeatherKit requests, even if called directly.
        return
        #endif
    }
}
