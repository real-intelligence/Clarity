/*
See LICENSE folder for this sample’s licensing information.
*/
import Foundation
import Clarity
   
@main
struct MyProjectApp: App {
    
    init() {
        ClarityActivator(withBundle: Bundle.main,
                         inPrintMode: true,
                         displayStatus: false)
        
        print(1, functionName: #function)
        print(2)
        print(3, values: [ 1,2,3])
    }

    
    var body: some Scene {

        WindowGroup {
            ContentView()
        }
    }
}
