/*
See LICENSE folder for this sample’s licensing information.
*/
import Foundation
import Clarity

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ClarityActivator(withBundle: Bundle.main,
                         inPrintMode: true,
                         displayStatus: false)
        
        return true
    }
    
    // UISceneSession Lifecycle methods ...
}
