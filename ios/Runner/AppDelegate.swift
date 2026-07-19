import Flutter
import UIKit
import GoogleMaps
import GoogleSignIn
import FirebaseCore
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase FIRST, before any other services.
    if let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
       let options = FirebaseOptions(contentsOfFile: plistPath) {
      FirebaseApp.configure(options: options)
    } else {
      NSLog("GoogleService-Info.plist not found in app bundle. Continuing without explicit Firebase options.")
      if FirebaseApp.app() == nil {
        FirebaseApp.configure()
      }
    }
    
    // TODO: Replace YOUR_API_KEY with your actual Google Maps API key
    GMSServices.provideAPIKey("AIzaSyDt1MrDbkfhBEIkopSElGtH6COwbLRSW0o")
    
    // Register Flutter plugins AFTER Firebase is initialized
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if GIDSignIn.sharedInstance.handle(url) {
      return true
    }
    return super.application(app, open: url, options: options)
  }
}
