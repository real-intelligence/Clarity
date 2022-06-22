/*
See LICENSE folder for this sample’s licensing information.
*/
import Foundation
import Clarity


class MyFrameworkEntryPoint {

    // Single entry point initialiser for your framework
    public init() {
        // Essential framework set up ...

        
        ClarityActivator(withBundle: Bundle(for: MyFrameworkEntryPoint.self),
                         inPrintMode: true,
                         displayStatus: false)
        
    }
}
