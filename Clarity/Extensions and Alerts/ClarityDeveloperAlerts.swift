//
//  ClarityDeveloperAlerts.swift
//  Clarity
//
// Copyright (c) 2021 Lawrence Heyfron (http://realint.org/)

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//

import Foundation
struct ClarityDeveloperAlerts {
    
    /**
     A static Bool that signifies whether to enable the printing of certain internal Swift print statements to the console.
     
     These calls produce logs that are intended for the consumption by a Clarity framework developer only and should be disabled before the framework is built for release.
     */
    static let isClarityDeveloperInternalPrinting = false
    /**
     A static Bool that signifies whether to enable the printing of internal Swift print statements to the console within the algorithm in `goForPrintFromSettings(_:_:_:functionNumber:_:_:)`.
     
     These calls produce logs that are intended for the consumption by a Clarity framework developer only and should be disabled before the framework is built for release.
     */
    static let isClarityDeveloperInternalPrintingGONOGO = false

    /**
     A static Bool that signifies whether to suppress the printing of duplicate print number public alerts.
     
     This property is intended as a convenience for use during unit testing. Duplicate print numbers are included in the internal JSON files and their detection is tested. The side effect of the tests is the printing of alerts intended for client applications. Enabling this Bool allows a developer to prevent the alerts from being printed so that the console is kept clear for other tests. It should be disabled before the framework is built for release.
     */
    static let isClarityDeveloperSuppressDuplicateWarnings = true
    
    
    /**
     A static method that is called during initialisation that verifies that the internal developer convenience Bool properties are all set to `false`. The method will only be called if Clarity is embedded in a client application and the client application print mode is set to `true`.
     
     If any of the properties are set to true an alert is printed to the console as a reminder to switch them to `false` before the framework is built for release.
     
     The method is predicated on Clarity being tested while embedded in a dummy client application.
     */
    static func verifyReleaseCompatibleSettingsStateForClarityFrameworkDeveloper() {
        let alertHeader = "⛔️CLARITY DEVELOPER WARNING!⛔️: "
        let developerAlertInternalPrinting = "isDeveloperInternalPrinting set to TRUE"
        let developerAlertInternalPrintingGONOGO = "isClarityDeveloperInternalPrintingGONOGO set to TRUE"
        let developerAlertSuppressDuplicateWarnings = "isDeveloperSuppressDuplicateWarnings set to TRUE"

        if ClarityDeveloperAlerts.isClarityDeveloperInternalPrinting || ClarityDeveloperAlerts.isClarityDeveloperInternalPrintingGONOGO || ClarityDeveloperAlerts.isClarityDeveloperSuppressDuplicateWarnings {
            Swift.print(alertHeader)
        }

        if ClarityDeveloperAlerts.isClarityDeveloperInternalPrinting {
            Swift.print(developerAlertInternalPrinting)
        }
        if ClarityDeveloperAlerts.isClarityDeveloperInternalPrintingGONOGO {
            Swift.print(developerAlertInternalPrintingGONOGO)
        }
        if ClarityDeveloperAlerts.isClarityDeveloperSuppressDuplicateWarnings {
            Swift.print(developerAlertSuppressDuplicateWarnings)
        }

    }
    
}







