//
//  MessageCollator.swift
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
 A struct that collates all client application EntityLog Message instances into a shared static dictionary property keyed by print number.
 
 The struct injects an array of EntityLogService instances decoded from EntityLogService JSON files copied to the client application into its single private initialiser. These are then mapped into EntityLog instances.
 
 The EntityLog instances are a flattened version of the EntityLogService type and contain the nested struct Message: the initialiser compiles all Message instances into a dictionary keyed by print number and assigns it to the shared singleton `sharedMessages`.
 
 The print logic then keys into this dictionary by print number for each print statement in the client application to access and print the referenced information to the console.
 
 The initialiser conforms to the `DuplicatePrintNumberIdentifiable` protocol and uses its default methods to detect any duplicate print numbers across and within EntityLog instances. It provides the protocol required `duplicatePrintNumbersKeyedByEntityCode` static property to store them. If any duplicates are discovered the protocol methods will print an alert to the console (this can be temporarily overridden in ClarityDeveloperAlerts but must be restored on release).
 
 The initialiser also conforms to the  `UsedPrintNumberIdentifiable` protocol and uses its default methods to compile lists of the print numbers being used as arguments to Clarity print statements in a client application. The protocol prints specified lists to the console according to user preferences stored in Settings.json.
 */
struct MessageCollator : DuplicatePrintNumberIdentifiable, UsedPrintNumberIdentifiable {
     
    /**
     A static Int that stores the maximum character count of the entity codes used across all the client application EntityLog JSON files.
     
     It is used by `ClarityPrintHelper` to allow a client application to use entity codes with different character counts while maintaining vertical alignment for elements in all printed lines.
     */
    static var maxEntityCodeCharacterCount = 0
    /**
     A private dictionary of all EntityLog Message instances derived from all EntityLogService JSON files held in the ClarityJSON folder of the client application.
     
     The property is assigned to the MessageCollator shared static dictionary property `sharedMessages` during initialisation to create an exposed shared singleton.
     */
    private let messages: [Int: EntityLog.Message]
    
    /**
     A shared static dictionary of the EntityLog Message instances derived from all EntityLogService JSON files held in the ClarityJSON folder of the client application as decoded and compiled by ClarityActivator.
          
     The EntityLogService instances are hard coded into the MessageCollator private initialiser `services` parameter and `sharedMessages` is assigned from the MessageCollator private `messages` dictionary property during initialisation. As such `sharedMessages` is guaranteed to only exist as a single unchangeable instance during the life cycle of a client application.
     */
    static let sharedMessages = MessageCollator(fromServices:ClarityActivator.entityLogServiceArray).messages
    
    /**
     A static dictionary of arrays of duplicate print numbers keyed by EntityLog EntityCode as required by the DuplicatePrintNumberIdentifiable protocol.
     
     The dictionary is compiled by each EntityLog initialiser as they are created by the MessageCollator initialiser.
     
     Any duplicate print numbers detected and stored in this dictionary represent duplicates within each EntityLog only.
     
     MessageCollator uses the dictionary to print a duplicate print number alert to the console if duplicates are detected.
     
     - Important
      The duplicate print numbers represent duplicates found in the EntityLogService JSON files and not multiple calls of Clarity print statements using the same Int as argument in the client application.
     */
    static var  duplicatePrintNumbersKeyedByEntityCode = [String: [Int]]()
    /**
        A custom initialiser that takes an array of EntityLogService instances, maps them into EntityLog instances and then merges each contained EntityLog Message instance into a dictionary keyed by print number.
        
        The dictionary of EntityLog Messages is assigned to the shared singleton `sharedMessages` during the initialisation process for use by the print logic in `ClarityPrintHelper`.
     
        The initialiser conducts verification checks on the EntityLogs to detect whether they contain duplicate print numbers within individual instances or between them all. An alert is printed to the console if any duplicates are detected before any other message.
     
        The initialiser also compiles lists of print numbers used by client application JSON files. These are printed to the console on first launch if any of the 'list print number' preferences are `true` in Settings.json.

        - Note
        Both the duplicate alert and print number list presentation are only required on the first launch of a client app and therefore must be presented during initialisation.
        - Important
         Duplicate alerts represent duplicate print numbers found in the EntityLogService JSON files and not multiple calls of Clarity print statements using the same Int as argument in the client application.
     
         It is unlikely, inadvisable but not necessarily an error to reference the same message from multiple points in the code. It is however an error to attempt to reference multiple messages in the JSON files using the same print number from multiple points in the code.
     
        - Parameters:
            - services: An array of EntityLogService instances.
     */
    private  init(fromServices services: [EntityLogService]) {

        var allEntityLogMessagesKeyedByPrintNumber = [Int: EntityLog.Message]()
        let entityLogs = services.map { EntityLog(from: $0)}
        
        var maxEntityCodeCount = 0
        for entityLog in entityLogs{
            let count = entityLog.entityCode.symbolSpaceCount()
            if count > maxEntityCodeCount {
                maxEntityCodeCount = count
            }
            MessageCollator.maxEntityCodeCharacterCount = maxEntityCodeCount
            allEntityLogMessagesKeyedByPrintNumber.merge(entityLog.messages) {(current,_) in current}
        }
        messages = allEntityLogMessagesKeyedByPrintNumber
        
        let duplicatePNWithinEntityCodes = MessageCollator.detectDuplicatePrintNumbersWithinEntityLogs(MessageCollator.duplicatePrintNumbersKeyedByEntityCode, ClarityDeveloperAlerts.isClarityDeveloperSuppressDuplicateWarnings)
        let duplicatePNAcrossEntityCodes = MessageCollator.detectDuplicatePrintNumbersAcrossEntityLogs(entityLogs, ClarityDeveloperAlerts.isClarityDeveloperSuppressDuplicateWarnings).isDuplicatesDetected
        
        if (duplicatePNWithinEntityCodes ||  duplicatePNAcrossEntityCodes) && !ClarityDeveloperAlerts.isClarityDeveloperSuppressDuplicateWarnings{
            MessageCollator.printAdviceFooterForAllDuplicates()
        }
        
        MessageCollator.printAllUsedPrintNumbersByEntityCode(for: entityLogs)
        MessageCollator.printAllUsedPrintNumbers(for: entityLogs)
        MessageCollator.printHighestUsedPrintNumber(for: entityLogs)
    }
}





