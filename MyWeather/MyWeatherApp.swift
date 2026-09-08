//
//  MyWeatherApp.swift
//  MyWeather
//
//  Created by Joseph Szafarowicz on 9/3/26.
//

import SwiftUI

@main
struct MyWeatherApp: App {
    var body: some Scene {
        WindowGroup {
            #if LIVE_WEATHER
            LocationsView()
            #else
            ForecastView(
                locationName: MockData.locationName,
                temperature: MockData.temperature,
                conditionSymbolName: MockData.conditionSymbolName,
                previewDays: MockData.forecastDays,
                isDemo: true
            )
            #endif
        }
    }
}
