import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Add this block to create a smooth transition from the launch screen to the main view
    if let window = self.window {
        let launchScreenVC = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        let launchView = launchScreenVC?.view
        launchView?.frame = window.frame
        window.addSubview(launchView!)
        
        // Fade out the launch screen view
        UIView.animate(withDuration: 0.5, animations: {
            launchView?.alpha = 0
        }) { _ in
            launchView?.removeFromSuperview()
        }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
