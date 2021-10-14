//
//  DuplicatePrintNumberIdentifiable.swift
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
 A protocol for detecting duplicate print numbers used by a client application JSON files.
 
 The protocol declares a single static variable for a dictionary of duplicate print numbers keyed by EntityLog EntityCode. Any instance conforming to the protocol will need to compile this dictionary for the `duplicatePrintNumbersKeyedByEntityCode` parameter of the  `detectDuplicatePrintNumbersWithinEntityLogs(duplicatePrintNumbersKeyedByEntityCode:suppressAlert:) -> Bool` method.
 
 The protocol can detect or verify the detection of two 'types' of duplicate: print numbers duplicated within individual EntityLogs and those duplicated across multiple EntityLogs.
 
 Default versions of its methods are implemented in a protocol extension.
 
 The default methods print alerts to the console specific to each type of duplicate.
 
 - Note:
    The protocol has not been made generic for reasons of legibility of intent. However it could easily be fully decoupled from Clarity should the need arise – generic placeholders would be needed for EntityLog, EntityLog.Message and EntityLog.Code.
 
    Alternatively the dictionary of EntityCodes keyed by duplicate print number could be compiled by MessageCollator and passed as an argument to `detectDuplicatePrintNumbersAcrossEntityLogs(_ :suppressAlert:)->(Bool,[Int:[String]]) ` with a rewritten method signature. This would also require exposure of the default protocol 'duplicate type 2' print alert methods.
 */
protocol DuplicatePrintNumberIdentifiable: UsedPrintNumberIdentifiable {
    /**
     A static variable for storing a dictionary of duplicate print numbers keyed by EntityLog EntityCode.
     
     Any instance conforming to the protocol will need to compile this dictionary for the `duplicatePrintNumbersKeyedByEntityCode` parameter of the  `detectDuplicatePrintNumbersWithinEntityLogs(duplicatePrintNumbersKeyedByEntityCode:suppressAlert:) -> Bool` method.
     */
    static var  duplicatePrintNumbersKeyedByEntityCode: [ String: [Int]] { get set }
}

extension DuplicatePrintNumberIdentifiable {
    
    //Type 1 (No need to compile and return duplicatePrintNumbersKeyedByEntityCode it already exists as a property)
    /**
     A method that takes a dictionary of duplicate print numbers keyed by EntityCode and returns a Bool to verify whether any duplicate print numbers are contained in the dictionary. If any duplicates are found the method prints an alert to the console.
     
     This method is used to print alerts relating to the 'type 1' duplicate: print numbers duplicated within individual EntityLogs.
     
     If the incoming argument to the `duplicatePrintNumbersKeyedByEntityCode` is empty the method returns false otherwise it calls `printAlertForDuplicateType1(_:)` passing the parameter value as argument and returns true.
     
     - Parameters:
         - duplicatePrintNumbersKeyedByEntityCode: A dictionary of duplicate print numbers keyed by EntityCode.
         - suppressAlert: A Bool for suppressing the printing of an alert when duplicate print numbers have been detected. This is intended as a  convenience for use during unit testing.
     - Returns: A Bool that signifies whether any duplicate print numbers were contained in the incoming dictionary argument.
     */
    static func detectDuplicatePrintNumbersWithinEntityLogs(_ duplicatePrintNumbersKeyedByEntityCode:[String : [Int]], _ suppressAlert: Bool) -> Bool {
        
        if !duplicatePrintNumbersKeyedByEntityCode.isEmpty {
            if suppressAlert == false{
            printAlertForDuplicateType1(duplicatePrintNumbersKeyedByEntityCode)
            }
            return true
        }
        return false
    }
    //Type 2
    /**
     A method that takes an array of EntityLogs and returns a Bool to signify whether any duplicate print numbers have been detected across the EntityLogs. If any duplicates are found the method prints an alert to the console. The method also compiles and returns a tuple containing a dictionary of EntityCodes keyed by duplicate print number.
     
     The method gets an array of integers representing all the print numbers used in the EntityLogs including duplicates across instances but not including duplicates within instances.
     
     The array copies any uniqued duplicates to another local array `uniqueDuplicatePrintNumbersAcrossFiles`: this array is sorted and then filtered to remove any print numbers with the value `0` from template files.
     
     If the `uniqueDuplicatePrintNumbersAcrossFiles` array is empty the method returns the value `false` with an empty dictionary. Otherwise the method calls ‘type 2 duplicate print alert methods, compiles a dictionary of EntityCodes keyed by duplicate print number and returns the dictionary with the value `true`.
     
     - Note:
        The returned dictionary of EntityCodes keyed by duplicate print number `entityCodesKeyedByDuplicate` is compiled specifically for use by the test target.
     - Parameters:
         - entityLogs: An array of EntityLogs.
         - suppressAlert: A Bool for suppressing the printing of an alert when duplicate print numbers have been detected. This is intended as a  convenience for use during unit testing.
     - Returns: A tuple that contains two elements:
         - isDuplicatesDetected: A Bool that signifies whether any duplicate print numbers are detected existing across the EntityLogs of the `entityLogs` parameter argument.
         - entityCodesKeyedByDuplicate: A dictionary of EntityCodes keyed by duplicate print number. This is used exclusively for unit testing.
     */
    static func detectDuplicatePrintNumbersAcrossEntityLogs(_ entityLogs: [EntityLog], _ suppressAlert: Bool) -> (isDuplicatesDetected: Bool , entityCodesKeyedByDuplicate: [Int:[String]]) {
        // All print numbers across entityLogs including duplicates across files (but not internal duplicates)
        let allPrintNumbersArray  = allEntityLogMessagesKeys(for: entityLogs)
        //6
        var uniqueDuplicatePrintNumbersAcrossFiles = allPrintNumbersArray.uniqueDuplicates()
        //Sort numerically
        _ = uniqueDuplicatePrintNumbersAcrossFiles.sorted()
        //Remove zero  duplicate from template
        uniqueDuplicatePrintNumbersAcrossFiles = uniqueDuplicatePrintNumbersAcrossFiles.filter{$0 != 0}
        //7
        if !uniqueDuplicatePrintNumbersAcrossFiles.isEmpty {
            //Must conditionally wrap all prints separately to have full functionaility of function regardless of suppressAlert
            if suppressAlert == false{
                printAlertForDuplicateType2Header()
            }
            var entityCodeArray = [String]()
            var entityCodesKeyedByPrintNumbersDuplicatedAcrossFiles = [Int:[String]]()
            
            for printNumber in uniqueDuplicatePrintNumbersAcrossFiles {
                    //8
                    for entityLog in entityLogs{
                        if let message = entityLog.messages[printNumber] {
                            entityCodeArray.append(message.entityCode)
                        }
                    }
                    entityCodesKeyedByPrintNumbersDuplicatedAcrossFiles[printNumber] = entityCodeArray
                    if suppressAlert == false{
                        printAlertForDuplicateType2(printNumber, entityCodeArray)
                    }
                    entityCodeArray.removeAll()
            }
            if suppressAlert == false{
                printAdviceFooterForDuplicateType2()
            }
            return (true, entityCodesKeyedByPrintNumbersDuplicatedAcrossFiles)
        }
        return (false, [:])
    }
    
    // MARK: - Alert display methods
    /**
     A method that takes a dictionary of duplicate print numbers keyed by EntityCode and prints an alert listing the duplicate print numbers contained in each EntityLog.
     
     The alert is for the duplicate 'type 1' – duplicate print numbers detected within each EntityLog.
     
     The method sorts and displays the list of print numbers numerically and alphabetically by EntityCode.
     
     - Parameters:
         - duplicatePrintNumberDictionary: A dictionary of duplicate print numbers keyed by EntityCode.
     */

    static fileprivate func printAlertForDuplicateType1(_ duplicatePrintNumberDictionary: [String : [Int]]) {
        var multiple = false
        var printNumber : String
        var possession : String
        //Sort dictionary by EntityCode key alphabetical ascending
        let duplicatePrintNumberDictionary = duplicatePrintNumberDictionary.sorted(by: { $0.key < $1.key })
        
        Swift.print("\n⚠️⚠️⚠️ Clarity framework DUPLICATE PRINT NUMBER ALERT - Type 1 ⚠️⚠️⚠️")
        for (key, value) in duplicatePrintNumberDictionary{
            multiple = value.count > 1
            if multiple {
                printNumber = "print numbers"
                possession = "have"
            }else{
                printNumber = "print number"
                possession = "has"
            }
            
            //Sort PN array numeric ascending by converting to set and sorting
            let valueSet = Set(value).sorted()
            
            Swift.print("\n\(printNumber) \(valueSet) \(possession) been used more than once \nin the JSON file containing the following entity_code")
            Swift.print("                                                     : ",key)
        }
        Swift.print("\nIn this situation only only data for the last instance \nof a duplicated print number listed in its JSON file \nis currently being used to log messages\n")
    }
    
    /**
     A method that prints a common header for alerts of all occurrences of the duplicate 'type 2' – duplicate print numbers detected across multiple EntityLogs.
     */
    static fileprivate func printAlertForDuplicateType2Header(){
            Swift.print("⚠️⚠️⚠️ Clarity framework DUPLICATE PRINT NUMBER ALERT - Type 2 ⚠️⚠️⚠️")
    }
    /**
     A method that takes a single duplicate print number `printNumber` and an array of EntityCodes. The method prints an alert listing each EntityCode that contains the duplicate `printNumber`.
     
     The alert is for the duplicate 'type 2' – duplicate print numbers detected across multiple EntityLogs.
     
     - Note:
        The method will be called once for each print number that is duplicated across multiple EntityCodes.
     
     - Parameters:
         - printNumber: An Int representing a duplicate print number.
         - entityCodeArray: An array of Strings representing EntityCodes that contain `printNumber`.
     */
    static fileprivate func printAlertForDuplicateType2(_ printNumber: Int, _ entityCodeArray: [String]) {
            let entityCodeArray = Set(entityCodeArray).sorted()
            
            Swift.print("\nprint_number \(printNumber) has been used more than once across \nJSON files containing the following entity_code values")
            for entityCode in entityCodeArray{
                Swift.print("                                                     : ",entityCode)
            }
            Swift.print("\n")
    }
    /**
     A method that prints a common footer for alerts of all occurrences of the duplicate 'type 2' – duplicate print numbers detected across multiple EntityLogs.
     */
    static fileprivate func printAdviceFooterForDuplicateType2(){
        Swift.print("Where there are duplicate print numbers only data for the \ninstance of a duplicated print number in the JSON file \nlast (indeterminately) accessed by the system is currently \nbeing used to log messages\n")
       
    }
    /**
     A method that prints a common footer for both types of duplicate print number alert.
     */
    static func printAdviceFooterForAllDuplicates() {
        Swift.print("Please use unique print_numbers for each instance of \nprint_number used in the application for each log message \nto be printed and to be printed deterministically\n")
        Swift.print("Set listAllUsedPrintNumbers or listAllUsedPrintNumbersByEntityCode \nto true in Settings.json to see all print numbers used \nSet listHighestUsedPrintNumber to see the highest print number used.\n")
    }
}
