//
//  MyWeatherTests.swift
//  MyWeatherTests
//
//  Created by Joseph Szafarowicz on 9/3/26.
//

import XCTest
@testable import MyWeather

final class MyWeatherTests: XCTestCase {

    func testGetPercentageRoundsValidValuesAndRejectsInvalidValues() {
        XCTAssertEqual(getPercentage(0.456), "46%")
        XCTAssertEqual(getPercentage(0), "0%")
        XCTAssertEqual(getPercentage(1), "100%")

        for value: Double? in [nil, -0.1, 1.1, .nan, .infinity] {
            XCTAssertEqual(getPercentage(value), "--%")
        }
    }

    func testGetTemperatureConvertsRoundsAndFormatsMissingValues() {
        let celsius = Measurement(value: 20.4, unit: UnitTemperature.celsius)
        XCTAssertEqual(getTemperature(celsius, unit: TemperatureUnit.fahrenheit), "69°")

        let fahrenheit = Measurement(value: 68, unit: UnitTemperature.fahrenheit)
        XCTAssertEqual(getTemperature(fahrenheit, unit: TemperatureUnit.celsius, showDegreeSymbol: false), "20")

        let belowZero = Measurement(value: -0.1, unit: UnitTemperature.celsius)
        XCTAssertEqual(getTemperature(belowZero, unit: TemperatureUnit.celsius), "0°")
        XCTAssertEqual(getTemperature(nil, unit: TemperatureUnit.celsius), "--°")
        XCTAssertEqual(getTemperature(nil, unit: TemperatureUnit.celsius, showDegreeSymbol: false), "--")

        let invalid = Measurement(value: Double.nan, unit: UnitTemperature.celsius)
        XCTAssertEqual(getTemperature(invalid, unit: TemperatureUnit.celsius), "--°")
    }

}
