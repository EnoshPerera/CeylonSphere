import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, UIDocumentInteractionControllerDelegate {
  var documentInteractionController: UIDocumentInteractionController?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Provide Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyCVfTD2d0MpsavYWK85sQgjF5GSw8QZSRA")
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
//  api key -   AIzaSyAvS00_oarJDXlu9m0HajBH7qxGZA6RLy8
  // Function to present AR Quick Look
  func presentARQuickLook(filePath: String, from viewController: UIViewController) {
    let url = URL(fileURLWithPath: filePath)

    DispatchQueue.main.async {
      self.documentInteractionController = UIDocumentInteractionController(url: url)
      self.documentInteractionController?.delegate = self
      self.documentInteractionController?.presentPreview(animated: true)
    }
  }

  // Delegate method to return the view controller for previewing
  func documentInteractionControllerViewControllerForPreview(
    _ controller: UIDocumentInteractionController
  ) -> UIViewController {
    return window?.rootViewController ?? UIViewController()
  }
}
