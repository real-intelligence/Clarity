//
//  EntityLogTests.swift
//  ClarityTests
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

import XCTest
@testable import Clarity

class EntityLogTests: XCTestCase {
    
    
    // MARK: - 🦮 Helpers - Fake data SUT
    static let message5 = EntityLog.Message(entityCode: "KUSF", functionNumber: 568, functionNumberInEntity: 5, functionNumberAlwaysCustom: false, functionType: .actionMethod, nodeType: .guardFail, nodeNumberWithinFunction: 5, eventDescription: "description of event5", effectDescription: "description of consequence5")
    static let message6 = EntityLog.Message(entityCode: "KUSF", functionNumber: 568, functionNumberInEntity: 5, functionNumberAlwaysCustom: false, functionType: .customFunc, nodeType: .caseTrueNegativeOutcome, nodeNumberWithinFunction: 5, eventDescription: "description of event", effectDescription: "description of consequence")
    static let message7 = EntityLog.Message(entityCode: "KUSF", functionNumber: 568, functionNumberInEntity: 5, functionNumberAlwaysCustom: false, functionType: .systemOverride, nodeType: .caseTrueNegativeOutcome, nodeNumberWithinFunction: 5, eventDescription: "description of event", effectDescription: "description of consequence")
    
    let mockSUT = EntityLog(messages: [5 : message5, 6 : message6, 7 : message7], printNumbers: [5,6,7], entityCode: "KUSF")
    
    
    // MARK: - 🧪 Tests - Fake data SUT: Correct data assignment
    //EntityLog top level items
    func test_EntityLogEntityCodeisequaltoKUSF() {
        XCTAssertEqual(mockSUT.entityCode , "KUSF")
    }
    func test_EntityLogPrintNumbersArrayReturnsCorrectValues() {
        XCTAssertEqual(mockSUT.printNumbers , [5,6,7])
    }
    //EntityLog Message dictionary items
    func test_EntityLogMessagesDictionaryReturnsCorrectValues() {
        XCTAssertEqual(mockSUT.messages[5]?.entityCode , "KUSF")
        XCTAssertEqual(mockSUT.messages[5]?.functionNumber , 568)
        XCTAssertEqual(mockSUT.messages[5]?.functionNumberInEntity , 5)
        XCTAssertEqual(mockSUT.messages[5]?.functionNumberAlwaysCustom , false)
        XCTAssertEqual(mockSUT.messages[5]?.functionType , .actionMethod)
        XCTAssertEqual(mockSUT.messages[5]?.nodeType , .guardFail)
        XCTAssertEqual(mockSUT.messages[5]?.eventDescription , "description of event5")
        XCTAssertEqual(mockSUT.messages[5]?.effectDescription ,  "description of consequence5")
    }
   
    
    
    
    
    // MARK: -  🦮 Helpers - File access SUT
    //An array of EntityLog objects initialised from each EntityLogService object in  entityLogServiceArray
     let entityLogs = EntityLogServiceTests.entityLogServiceArray.map { EntityLog(from: $0)}
    
    //These helper methods required because entityLogs is an array compiled from JSON random file access - adding files in sequence does NOT guarantee same order
    //so cannot ever know what file will be retrieved by index eg. using let log = entityLogs[0]

    fileprivate func functionNumberFromPrintNumber(_ printNumber: Int) -> Int {
        var functionNumber = 0
        for log in entityLogs{
            let messagesDictionary = log.messages
            if messagesDictionary.keys.contains(printNumber) {
                let message = messagesDictionary[printNumber]
                functionNumber = message?.functionNumber ?? 0
            }
        }
        return functionNumber
    }
    fileprivate func functionTypeFromPrintNumber(_ printNumber: Int) -> String {
        var functionType = ""
        for log in entityLogs{
            let messagesDictionary = log.messages
            if messagesDictionary.keys.contains(printNumber) {
                let message = messagesDictionary[printNumber]
                functionType = message?.functionType.rawValue ?? ""
            }
        }
        return functionType
    }
    fileprivate func functionNumberInEntityFromPrintNumber(_ printNumber: Int) -> Int {
        var functionNumberInEntity = 0
        for log in entityLogs{
            let messagesDictionary = log.messages
            if messagesDictionary.keys.contains(printNumber) {
                let message = messagesDictionary[printNumber]
                functionNumberInEntity = message?.functionNumberInEntity ?? 0
            }
        }
        return functionNumberInEntity
    }
    
    
    fileprivate func printNumber(_ duplicatePrintNumberBeingTested:Int, isDuplicateIn entityCodeToTest:String ) -> Bool{
        //For each entity log
        //Get all print numbers
        //Check for duplicates
        //Where found get the EntityCode
        //Check EntityCode against incoming argument
        //Check duplicate PN against incoming argument

        var entityLogPrintNumbers: [Int] // All the PN for an entityLog
        var duplicatePrintNumbersInEntityLog = [Int]() // The duplicate PN in an entityLog
        var entityCodeContainingDuplicates = ""
       
        
        for entityLog in entityLogs{
            entityLogPrintNumbers = entityLog.printNumbers
            duplicatePrintNumbersInEntityLog = entityLogPrintNumbers.uniqueDuplicates()
            
            for duplicatePrintNumber in duplicatePrintNumbersInEntityLog {
                //Get the entityCode for the entitylog containing duplicates
                entityCodeContainingDuplicates = entityLog.messages[duplicatePrintNumber]!.entityCode
                //Is the entityCode same as being tested?
                if entityCodeContainingDuplicates ==  entityCodeToTest{
                    //Does duplicates contain  number being tested
                    if duplicatePrintNumbersInEntityLog.contains(duplicatePrintNumberBeingTested){
                        return true
                    }
                }
            }
        }
        return false
    }

    fileprivate func nodeNumberForPrintNumber(_ printNumber: Int) -> Int{
        //Search entityLogs for printNumber
        var nodeNumberWithinFunction = Int()
        for log in entityLogs{
            //Get entityLog messages dictionary
            let messagesDictionary = log.messages
            //Does it contain the pn?
            if messagesDictionary.keys.contains(printNumber) {
                //Get the message
                let message = messagesDictionary[printNumber]
                //Set the nodeNumberWithinFunction  or default set to 0
                nodeNumberWithinFunction = message?.nodeNumberWithinFunction ?? 0
            }
        }
        return nodeNumberWithinFunction
    }


    // MARK: - 🧪 Tests -  File access SUT: print number returns correct function number attributes

    func test_EntityLogFirstObjectKey72FunctionNumberisequalto15() {
        let printNumber = 72
        let functionNumber = functionNumberFromPrintNumber(printNumber)
        XCTAssertEqual(functionNumber , 15)
    }
    
    func test_EntityLogFirstObjectKey72FunctionTypeRawValueisequaltoStringf() {
        let printNumber = 72
        let functionType = functionTypeFromPrintNumber(printNumber)
        XCTAssertEqual(functionType , "f")
    }
    
    // Second Log
    func test_EntityLogSecondObjectDictionaryKey95FunctionNumberisequalto21() {
        let printNumber = 95
        let functionNumber = functionNumberFromPrintNumber(printNumber)
        XCTAssertEqual(functionNumber , 21)
    }
    func test_EntityLogSecondObjectDictionaryKey95FunctionTypeRawValueisequaltoStringi() {
         let printNumber = 95
         let functionType = functionTypeFromPrintNumber(printNumber)
         XCTAssertEqual(functionType , "i")
    }
    func test_EntityLogSecondObjectDictionaryKey98functionNumberInLogisequalto2() {
        let printNumber = 98
        let functionNumberInEntity = functionNumberInEntityFromPrintNumber(printNumber)
        XCTAssertEqual(functionNumberInEntity , 2)
    }
    
    
    // MARK: - 🧪 Tests -  File access SUT: detect print number duplicates within EntityLogs
    func test_EntityLogsArrayNotNil() {
        XCTAssertNotNil(entityLogs)
    }
    
    
    func test_PrintNumber10IsDuplicatedInEntityLog_ABCD() {
        XCTAssertTrue(printNumber(10, isDuplicateIn: "ABCD"))
    }
    
    func test_PrintNumber11IsDuplicatedInEntityLog_ABCD() {
        XCTAssertTrue(printNumber(11, isDuplicateIn: "ABCD"))
    }
    
    func test_PrintNumber0IsDuplicatedInEntityLog_AAAA() {
        //The template file
        XCTAssertTrue(printNumber(0, isDuplicateIn: "AAAA"))
    }

  
    func test_ArrayExtensionUniqueDuplicatesReturnsCorrectDuplicates() {
        
        let numbers = [1,2,3,4,5,6,6,6,7,8,8]
        let duplicates = numbers.uniqueDuplicates()
        // Create an ordered set to order the sequence of duplicates to ensure tests same every time
        let duplicateSet = Set(duplicates).sorted()
        
        XCTAssertEqual(duplicateSet[0] , 6)
        XCTAssertEqual(duplicateSet[1] , 8)
    }
    

    // MARK: - 🧪 Tests -  File access SUT: print number node number within its function returns correct values
    func test_printNumber1IsNodeNumber1WithinItsFunction() {
        XCTAssertEqual(nodeNumberForPrintNumber(1) , 1)
    }
    
    func test_printNumber11135IsNodeNumber20WithinItsFunction() {
        XCTAssertEqual(nodeNumberForPrintNumber(11135) , 20)
    }
    
    func test_printNumber197IsNodeNumber2WithinItsFunction() {
        XCTAssertEqual(nodeNumberForPrintNumber(197) , 2)
    }
    
}



