import CoreLocation
import SwiftUI
import UIKit

struct LocationsView: View {
    @StateObject private var locationManager = LocationManager()
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL

    var body: some View {
        Group {
            if let location = locationManager.location {
                ForecastView(location: location)
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.blue)
                        .accessibilityHidden(true)
                    Text("Weather Where You Are")
                        .font(.headline.bold())
                    permissionContent
                }
                .multilineTextAlignment(.center)
                .padding(30)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { locationManager.refresh() }
        }
    }

    @ViewBuilder
    private var permissionContent: some View {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            Text("Use your location to show current conditions and your local forecast. You can allow or deny access with the button below.")
                .foregroundStyle(.secondary)
            Button("Choose Location Access") {
                locationManager.requestPermission()
            }
            .buttonStyle(.borderedProminent)
        case .denied:
            Text("Location access is off. Allow location access in Settings to see your local weather.")
                .foregroundStyle(.secondary)
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    openURL(url)
                }
            }
            .buttonStyle(.borderedProminent)
        case .restricted:
            Text("Location access is restricted on this device. Your local forecast will be available when access is permitted.")
                .foregroundStyle(.secondary)
        case .authorizedAlways, .authorizedWhenInUse:
            if let error = locationManager.errorMessage {
                Text(error).foregroundStyle(.secondary)
                Button("Try Again") { locationManager.refresh() }
                    .buttonStyle(.borderedProminent)
            } else {
                ProgressView("Finding your location…")
            }
        @unknown default:
            Text("Location access is unavailable.")
        }
    }
}

#Preview {
    LocationsView()
}
