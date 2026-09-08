//
//  MockData.swift
//  MyWeather
//
//  Created by Joseph Szafarowicz on 9/8/26.
//

import Foundation

enum MockData {
    static let locationName = "Cupertino"
    static let temperature = "72°"
    static let conditionSymbolName = "sun.max.fill"

    static var forecastDays: [ForecastDay] {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let samples: [(temperature: Double, symbol: String, precipitation: Double)] = [
            (72, "sun.max.fill", 0),
            (70, "cloud.sun.fill", 0.15),
            (65, "cloud.rain.fill", 0.85),
            (68, "cloud.fill", 0.30),
            (74, "sun.max.fill", 0.05)
        ]

        return samples.enumerated().compactMap { offset, sample in
            guard let date = calendar.date(byAdding: .day, value: offset, to: startDate) else {
                return nil
            }
            return ForecastDay(
                date: date,
                highTemperature: Measurement(value: sample.temperature, unit: .fahrenheit),
                symbolName: sample.symbol,
                precipitationChance: sample.precipitation
            )
        }
    }
}
