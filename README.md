# MyWeather

A SwiftUI weather example app featuring Apple WeatherKit integration and a ready-to-run demo mode.

## Run the demo

Open `MyWeather.xcodeproj` in Xcode, select the MyWeather scheme and an iOS simulator, and run.

Demo mode displays sample weather without location permission, an Apple Developer membership, or WeatherKit setup.

Requires Xcode with the iOS 26 SDK or later. The app targets iOS 26.0; tests require iOS 26.2 or later.

## Enable live weather

Live weather requires your own Apple Developer Program membership.

1. Copy `Configuration/Local.xcconfig.example` to `Configuration/Local.xcconfig`.
2. Enter your Team ID and a unique bundle identifier in that file.
3. Register the App ID in your Apple Developer account and enable WeatherKit under both **Capabilities** and **App Services**.
4. Sign in to your account in Xcode, build and run with automatic signing, and allow location access.

The local configuration enables live weather automatically when you rebuild. Requests use your own account’s WeatherKit allocation.

See [Apple’s WeatherKit setup instructions](https://developer.apple.com/help/account/services/weatherkit).

## Return to demo mode

Remove `Configuration/Local.xcconfig` and rebuild.

To keep signing a demo on a physical device, retain your Team ID and bundle identifier but remove these settings from the local file:

```xcconfig
SWIFT_ACTIVE_COMPILATION_CONDITIONS = $(inherited) LIVE_WEATHER
MYWEATHER_ENTITLEMENTS = MyWeather/MyWeather.entitlements
```

## Local configuration

Keep personal signing settings in `Configuration/Local.xcconfig`, which is ignored by Git. Never commit private keys, signing certificate exports, or authentication tokens.

Team IDs and bundle identifiers are not secrets. Git ignore rules do not protect files that are already tracked.

<img width="402" height="874" alt="Simulator Screenshot - iPhone 17 Pro - 2026-09-09 at 11 33 35" src="https://github.com/user-attachments/assets/092a31df-0c64-4177-a9fd-b0f346279c7c" />
<img width="402" height="874" alt="Simulator Screenshot - iPhone 17 Pro - 2026-09-09 at 11 22 48" src="https://github.com/user-attachments/assets/f786520f-9090-4acd-9782-7f7f61a185f3" />

