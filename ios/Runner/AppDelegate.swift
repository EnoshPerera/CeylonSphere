import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, UIDocumentInteractionControllerDelegate {
  var documentInteractionController: UIDocumentInteractionController?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

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
