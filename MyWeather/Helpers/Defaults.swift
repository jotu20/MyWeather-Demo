//
//  Defaults.swift
//  MyWeather
//
//  Created by Joseph Szafarowicz on 9/8/26.
//

import Foundation

enum TemperatureUnit: String, CaseIterable, Identifiable {
    case celsius
    case fahrenheit
    
    var id: String { rawValue }
    var measurementUnit: UnitTemperature {
        switch self {
        case .celsius: return .celsius
        case .fahrenheit: return .fahrenheit
        }
    }
    var short: String { measurementUnit.symbol }
    var long: String {
        switch self {
        case .celsius: return "Celsius"
        case .fahrenheit: return "Fahrenheit"
        }
    }
}

enum TemperatureSymbols: String {
    case shorthandHighTemperatureText = "H:"
    case shorthandLowTemperatureText = "L:"
    case longHandHighTemperatureText = "High:"
    case longHandLowTemperatureText = "Low:"
    case degreeSymbol = "°"
}
