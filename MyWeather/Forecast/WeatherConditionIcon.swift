import SwiftUI

/// Shared styling for live weather and sample forecasts.
struct WeatherConditionIcon: View {
    let symbolName: String

    private var accentColor: Color {
        if symbolName.contains("sun") || symbolName.contains("bolt") {
            return .yellow
        }
        if symbolName.contains("moon") {
            return .secondary
        }
        return .cyan
    }

    var body: some View {
        if symbolName.hasPrefix("cloud") {
            // Cloud symbols put the cloud in the primary palette layer.
            Image(systemName: symbolName)
                .symbolVariant(.fill)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.gray, accentColor, .cyan)
        } else {
            Image(systemName: symbolName)
                .symbolVariant(.fill)
                .symbolRenderingMode(.multicolor)
        }
    }
}
