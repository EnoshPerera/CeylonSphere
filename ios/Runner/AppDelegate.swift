import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBZOOBQ6ME-TXNbD8I2EIF1uOva65zU70s")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

//key
//YAIzaSyCVfTD2d0MpsavYWK85sQgjF5GSw8QZSRA
//AIzaSyBZOOBQ6ME-TXNbD8I2EIF1uOva65zU70s