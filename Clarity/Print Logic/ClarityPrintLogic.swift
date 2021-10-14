//
//  ClarityPrintLogic.swift
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

/**
 A struct that contains a method that formats and prints a message to the console corresponding to a single print number from correlated data collated by `MessageCollator`.
 
 The struct conforms to the ClarityPrintHelper protocol. The protocol groups default implementations of print logic helper methods in an extension.
 */
struct ClarityPrintLogic: ClarityPrintHelper {
     
    /**
     A method that formats and prints a message to the console corresponding to data stored as JSON for a given print number. This method acts as the single internal call point for the public Clarity print overloads.
     
     There are four main task phases to the method:
     1. Run 'Guard return without further action' conditions:
        - Guard that the SettingsManagerService instance from the used Bundle is not nil.
        - Guard assign a settings instance either from the `settings` parameter argument or from the used Bundle.
        - Guard that the FormattingManagerService instance from the used Bundle is not nil.
        - Guard assign an instance of the message to print for the print number instance from the shared dictionary of all Message instances keyed by print number from MessageCollator. If there is no message for the key or no key print an alert before returning.
     2. Resolve whether to print the message based on user preferences in `settings`. If the result is `false` return without further action.
     3. Compile the print number message string(s) based on the data provided.
     4. Print the message and any additional values provided.
     
     - Parameters:
        - printNumber: A unique number used as a key to access a specific associated message from a dictionary containing all message data.
        - settings: An optional parameter for a mock `SettingsManagerService` instance. The mock SettingsManagerService instance can have its properties set programmatically to a variety of values. This enables more convenient and dynamic evaluation of a wider range of unit tests in a test target than is possible when using the JSON access mechanism.
        - functionName: An optional String  the function name derived from a `#function` macro argument provided to the relevant public Clarity print overloads. If this parameter is included Clarity formats and prints the log as a function call node for the function that contains `printNumber`.
        - values: An optional parameter for the inclusion of variable values to be printed as part of the message. If this parameter is included Clarity formats and prints the log as a value report node. The parameter can be a single value of any type,  a `Collection` of any type or an instance conforming to the `Error` protocol.
     
     - Note:
     The print overloads would never provide arguments to both `functionName` and `values` in a single call.
     
     `PrintType` will be set for an `.event` when an effect string is required despite `.Effect` being a valid `PrintType`. This anomoly is caused because it is the only occurrence when two different `PrintType`s require evaluation for the same print call. This is solved by the `inout` return of a flag from the string compilation helper method.
     */
  internal   func printLogic(_ printNumber: Int, _ settings:SettingsManagerService?, _ functionName: String? = nil, _ values: Any? = nil) {
        
        // MARK: -  💂‍♀️ 1. Guard return conditions
        
        guard ClarityActivator.settings != nil else{
            return
        }
       
        //. .. but if there is a settings argument use it instead of the bundle version
        guard let usedSettings = (settings != nil) ? settings : ClarityActivator.settings else{
            if ClarityDeveloperAlerts.isClarityDeveloperInternalPrinting{
                //Should never reach here but guard let used as a convenience to set usedSettings to incoming argument
                Swift.print("CLPL   ⚠️ settings argument NIL And Settings.json missing  -  NO PRINT" )
            }
            return
        }
        
        guard let formatting = ClarityActivator.formatting else{
            return
        }
        
        let printMessages = MessageCollator.sharedMessages
        guard let messageToPrint = printMessages[printNumber] else {
            if usedSettings.alertOrphanedPrintNumbersDetected{
                printAlertForDetectedOrphanPrintNumber(printNumber)
            }
            return
        }
        
        // MARK: -  🍽 2. Resolve goForPrint
        //Only procede with string compile calculations if true
        
        var goForPrint = false
        let nodeType = resolveNodeTypeGroup(messageToPrint, functionName, values)
        let entityCode = messageToPrint.entityCode
        let functionNumber = messageToPrint.functionNumber
        
        goForPrintFromSettings(usedSettings, entityCode, printNumber, functionNumber:functionNumber, nodeType, &goForPrint)
        
        if goForPrint{
            // MARK: - 🪢 3. Compile print string(s)
            //Compile composite array of components for all sequential slots according to parameters
            let composite =  self.compileSequentialComposite(printNumber, messageToPrint, nodeType, usedSettings, formatting, functionName, values)
            // Spacer required for alignment of secondary lines printed simultaneously with the message
            let readoutSpacer = readoutSpacer(fromComposite: composite, usedSettings)
            
            var printValueType: PrintValueType = .none
            var compiledStringForPrint = ""
            var compiledStringForEffectPrint = ""
            var printEffectString = false
            //Compile string(s) to print
            compileStringsFromComposite(composite, nodeType, usedSettings, values, &printValueType, &compiledStringForPrint,   &printEffectString, &compiledStringForEffectPrint)
            
            // MARK: - 🖨 4. Print string(s) and values
            Swift.print(compiledStringForPrint)
            
            if printEffectString {
                Swift.print(readoutSpacer+compiledStringForEffectPrint)
            }
            
            //Print values
            switch printValueType {
            case .dictionaryValue(dictionary: let dictionary):
                printCollectionValues(dictionary, withReadOutSpacer: readoutSpacer)
            case .arrayValue(array: let array):
                printCollectionValues(array, withReadOutSpacer: readoutSpacer)
            case .setValue(set: let set):
                printCollectionValues(set, withReadOutSpacer: readoutSpacer)
            case .singleValue(single: let single):
                printValue(single, withReadOutSpacer: readoutSpacer)
            default:
                // No values to print
                break
            }
        }else{
            // Settings resolve to false – no printing of log for the print number
            if ClarityDeveloperAlerts.isClarityDeveloperInternalPrinting{
                Swift.print("CLPL 1 NO GO FOR PRINT for print number ", printNumber)
            }
        }
    }
}



