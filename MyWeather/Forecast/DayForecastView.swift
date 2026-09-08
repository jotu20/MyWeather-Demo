//
//  DayForecastView.swift
//  MyWeather
//
//  Created by Joseph Szafarowicz on 9/8/26.
//

import Foundation
import SwiftUI

/// The values needed for a daily row, shared by live forecasts and previews.
struct ForecastDay {
    let date: Date
    let highTemperature: Measurement<UnitTemperature>
    let symbolName: String
    let precipitationChance: Double
}

struct DayForecastView: View {
    @ScaledMetric(relativeTo: .headline) private var dayWidth = 50
    @ScaledMetric(relativeTo: .title3) private var iconWidth = 30

    var day: String = "Day"
    var temperature: String = "--°"
    var conditionSymbolName: String = "cloud.fill"
    var precipitation: String = "--%"

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()

            HStack(spacing: 12) {
                Text(day)
                    .font(.headline)
                    .frame(width: dayWidth, alignment: .leading)
                
                HStack(spacing: 10) {
                    Image(systemName: conditionSymbolName)
                        .symbolRenderingMode(.multicolor)
                        .font(.title3)
                        .frame(width: iconWidth, alignment: .leading)
                    Text(temperature)
                        .fontWeight(.medium)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                HStack(spacing: 10) {
                    Image(systemName: "drop.fill")
                        .frame(width: iconWidth, alignment: .trailing)
                    Text(precipitation)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .frame(maxHeight: 75)
    }
}
