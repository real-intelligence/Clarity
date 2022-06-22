/*
See LICENSE folder for this sample’s licensing information.
*/
import Foundation
import Clarity


class MyFrameworkType {

    // An  initialiser for a multi entry point type of your framework
    public init() {
        // Essential framework set up ...
        
        guard let _ = ClarityService.clarityActivation else{
            print("Clarity activation failed")
            return
        }
        // Note that Clarity print statements will function from this point in the initialiser if required.
        
    }
}
