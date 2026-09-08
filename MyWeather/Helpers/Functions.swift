//
//  Functions.swift
//  MyWeather
//
//  Created by Joseph Szafarowicz on 9/8/26.
//

import Foundation

/// Formats a fraction from 0...1 as a rounded percentage, or "--%" if invalid.
func getPercentage(_ value: Double?) -> String {
    guard let value, value.isFinite, (0...1).contains(value) else {
        return "--%"
    }

    let result = (value * 100).rounded()
    return "\(Int(result))%"
}

/// Converts and rounds a temperature, using "--" for missing or invalid values.
func getTemperature(
    _ value: Measurement<UnitTemperature>?,
    unit: TemperatureUnit,
    showDegreeSymbol: Bool = true) -> String {
    let symbol = showDegreeSymbol ? TemperatureSymbols.degreeSymbol.rawValue : ""
    guard let value else { return "--" + symbol }

    let convertedAmount = value.converted(to: unit.measurementUnit).value
    guard convertedAmount.isFinite else { return "--" + symbol }

    let roundedAmount = convertedAmount.rounded()
    // Avoid displaying negative zero for temperatures just below zero.
    let amount = roundedAmount == 0 ? 0 : roundedAmount
    return amount.formatted(.number.precision(.fractionLength(0))) + symbol
}
