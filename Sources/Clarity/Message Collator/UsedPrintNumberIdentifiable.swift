//
//  UsedPrintNumberIdentifiable.swift
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
 A protocol that groups methods involved in the compilation of lists of the print numbers being used as arguments to Clarity print statements in a client application.
 
 Default versions of the methods are implemented in a protocol extension.
 */
protocol UsedPrintNumberIdentifiable {
}


extension UsedPrintNumberIdentifiable{
    
    /**
     A helper method that takes an array of EntityLogs and returns an array containing the keys for each EntityLog Message dictionary instance.
     
     It is used as a convenience to list print numbers used by client application JSON files and to detect duplicate print numbers across EntityLog instances.
        
        The individual keys in the returned array represent the print number used to key each Message referenced in the client application.
     - Note
        The keys compiled from each EntityLog have been previously uniqued by virtue of being stored in the EntityLog `messages` dictionary property. Appending the `keys` arrays for all EntityLogs allows the returned array to contain any duplicates that might exist across files.
     - Parameters:
         - entityLogs: An array of EntityLog instances.
     - Returns: An array of integers representing all the print numbers used by a client application JSON files including duplicates across files but not including duplicates within files.
     */
   static  func allEntityLogMessagesKeys(for entityLogs:[EntityLog]) -> [Int]{

        var allEntityLogMessagesKeys = [Int]()
        
        for entityLog in entityLogs{
            let messageKeys = Array(entityLog.messages.keys)
            allEntityLogMessagesKeys.append(contentsOf: messageKeys)
        }
        return allEntityLogMessagesKeys
    }
    
    /**
        A method that takes an array of EntityLogs and returns a dictionary of all print numbers used by a client application JSON files keyed by EntityLog EntityCode.
     
        The method sorts the keys for each EntityLog Message dictionary instance in ascending order into a uniqued set and then assigns it to a dictionary keyed by EntityCode as an array of integers.
     
        The dictionary is sorted ascending alphabetically by (EntityCode) key into an array of key, value tuples that are printed to the console (according to user preferences).
     
        The array of tuples is then reassembled into a dictionary for the return value.
     
        - Note
        The method only prints an alert if specified to do so in the user settings file. Therefore there is no requirement for a convenience parameter to suppress the alert for unit tests (unlike those contained in the obligatory duplicate print number alert methods).
     
        The method is prefixed with the word 'print' in keeping with all alert methods in the framework code. The related user settings JSON key is prefixed with the word 'list' to distinguish its advisory purpose from other settings that control functionality.
     
        - Parameters:
          - entityLogs: An array of EntityLog instances.
        
        - Returns: A dictionary of print numbers keyed by EntityLog EntityCode.
     */
    @discardableResult
    static func printAllUsedPrintNumbersByEntityCode(for entityLogs:[EntityLog]) -> [String: [Int]]{
        var printNumbersKeyedByEntityCode = [String:[Int]]()
        
        for entityLog in entityLogs{
            var printNumbersInEntityLog = Array(entityLog.messages.keys)
            printNumbersInEntityLog = Set(printNumbersInEntityLog).sorted()
            printNumbersKeyedByEntityCode[entityLog.entityCode] = printNumbersInEntityLog
        }

        let alphabeticalPrintNumbersKeyedByEntityCode = printNumbersKeyedByEntityCode.sorted(by: { $0.key < $1.key })
        
        if let settingsFromFile = ClarityActivator.settings{
            if settingsFromFile.listAllUsedPrintNumbersByEntityCode {
                for (key, value) in alphabeticalPrintNumbersKeyedByEntityCode{
                    Swift.print("Print numbers used in JSON file with entity_code", key,"are:")
                    for printNumber in value {
                        Swift.print("                                                       ", printNumber)
                    }
                }
            }
        }

        var reassembledDictionary: [String: [Int]] = [:]
         for tuple in alphabeticalPrintNumbersKeyedByEntityCode {
             reassembledDictionary[tuple.key] = tuple.value
         }
         
        return reassembledDictionary
    }
    
    /**
     A method that takes an array of EntityLogs and returns an array of all print numbers used by a client application JSON files.
     
     The method sorts the keys for each EntityLog Message dictionary instance in ascending order into a uniqued set and prints them to the console (according to user preferences).
     
     - Note
     The method only prints an alert if specified to do so in the user settings file. Therefore there is no requirement for a convenience parameter to suppress the alert for unit tests (unlike those contained in the obligatory duplicate print number alert methods).
     
     The method is prefixed with the word 'print' in keeping with all alert methods in the framework code. The related user settings JSON key is prefixed with the word 'list' to distinguish its advisory purpose from other settings that control functionality.

     - Parameters:
         - entityLogs: An array of EntityLog instances.
     - Returns: An array of all print numbers used by a client application JSON files sorted in ascending order.
     */
    
    @discardableResult
    static func printAllUsedPrintNumbers(for entityLogs:[EntityLog]) -> [Int]{
        
        let keys  = Self.allEntityLogMessagesKeys(for: entityLogs)
        let allPrintNumbers = Set(keys).sorted()
        if let settingsFromFile = ClarityActivator.settings{
            if settingsFromFile.listAllUsedPrintNumbers {
                Swift.print("All Print numbers used for all EntityCodes are:")
                for printNumber in allPrintNumbers {
                    Swift.print("                                                       ", printNumber)
                }
            }
        }
        return allPrintNumbers
    }
    
    
    /**
     A method that takes an array of EntityLogs and returns an Int representing the highest print number used by a client application JSON files.
     
     The method sorts the keys for each EntityLog Message dictionary instance in ascending order into a uniqued set and gets the maximum value.
     
     It then prints the value to the console (according to user preferences).
     
     - Note
     The method only prints an alert if specified to do so in the user settings file. Therefore there is no requirement for a convenience parameter to suppress the alert for unit tests (unlike those contained in the obligatory duplicate print number alert methods).
     
     The method is prefixed with the word 'print' in keeping with all alert methods in the framework code. The related user settings JSON key is prefixed with the word 'list' to distinguish its advisory purpose from other settings that control functionality.

     - Parameters:
         - entityLogs: An array of EntityLog instances.
     - Returns: An Int representing the highest print number used by a client application JSON files.
     */
    @discardableResult
    static func printHighestUsedPrintNumber(for entityLogs:[EntityLog]) -> Int{
        
        let keys  = Self.allEntityLogMessagesKeys(for: entityLogs)
        let highestPrintNumber = Set(keys).sorted().max() ?? 0
        if let settingsFromFile = ClarityActivator.settings{
            if settingsFromFile.listHighestUsedPrintNumber {
                Swift.print("Highest Print number used in all EntityCodes is:")
                Swift.print("                                                       ", highestPrintNumber)
            }
        }
        return highestPrintNumber
    }
}
