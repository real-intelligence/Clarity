/*
See LICENSE folder for this sample’s licensing information.
*/
import Foundation
import Clarity


class ClarityService {

    static let clarityActivation: ClarityActivator? = {
      
        return ClarityActivator(withBundle: Bundle(for: ClarityService.self),
                               inPrintMode:true,
                                displayStatus:false)
      }()
}
