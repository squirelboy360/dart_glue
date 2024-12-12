import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var viewManager: NativeViewManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        viewManager = NativeViewManager()
        
        let rootViewController = UIViewController()
        rootViewController.view = viewManager.rootView
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
