//
//  MessageCollatorTests.swift
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

class MessageCollatorTests: XCTestCase {

    
    // MARK: -  🦮 Helpers - File access SUT
    let printMessages = MessageCollator.sharedMessages
    let duplicatePrintNumberDictionary = MessageCollator.duplicatePrintNumbersKeyedByEntityCode
    
    let entityLogs = EntityLogServiceTests.entityLogServiceArray.map { EntityLog(from: $0)}
    
    // File access SUT:
    // IMPORTANT!  These are 'in the field' file access tests
    // The tests will fail if the EntityLogService JSON files in framework ClarityJSON folder changes details
    // Therefore a few tests use a mock while most tests check the JSONAccess system delivers the real EntityLogService > EntityLog values
    // Unlike Settings there is not a need for both but mock tests included for the convenience of changes in future versions
    
    // MARK: - 🧪 Tests -  File access SUT: Duplicates print numbers detected

    func test_DuplicatePrintNumberDictionaryNotNil() {
        XCTAssertNotNil(duplicatePrintNumberDictionary)
    }
    
    //Known Type 1 duplicates (calculated by EntityLog)
    func test_DuplicatePrintNumberWithinEntityCodesDictionaryContainEntityCodeABCD(){
        let printNumbersArrayForABCD  = duplicatePrintNumberDictionary["ABCD"]!
        XCTAssertEqual(Set(printNumbersArrayForABCD).sorted(), [10, 11,35])
    }
    func test_DuplicatePrintNumberDictionaryContainEntityCodeABCE(){
        let printNumbersArrayForABCE  = duplicatePrintNumberDictionary["ABCE"]!
        XCTAssertEqual(Set(printNumbersArrayForABCE).sorted(), [398])
    }
    
    func test_DuplicatePrintNumbersFoundWithinEntityCodesEqualsTrue (){
        XCTAssertTrue(MessageCollator.detectDuplicatePrintNumbersWithinEntityLogs(duplicatePrintNumberDictionary, true))
    }
    
    
    //Known Type 2 duplicates (calculated by MessageCollator)
    func test_DuplicatePrintNumbersFoundAcrossFilesEqualsTrue (){
        XCTAssertTrue(MessageCollator.detectDuplicatePrintNumbersAcrossEntityLogs(entityLogs, true).isDuplicatesDetected)
    }
    
    func test_ArrayOfEntityCodesContainingDuplicatePrintNumbersAcrossFilesNotNil (){
        XCTAssertNotNil(MessageCollator.detectDuplicatePrintNumbersAcrossEntityLogs(entityLogs, true).entityCodesKeyedByDuplicate)
    }
    
    func test_ArrayOfEntityCodesContainingDuplicatePrintNumbersAcrossFilesForPrintNumber298ReturnsCorrectValues (){
        let arrayOfEntityCodes = MessageCollator.detectDuplicatePrintNumbersAcrossEntityLogs(entityLogs, true).entityCodesKeyedByDuplicate[298]!
    
        XCTAssertEqual(Set(arrayOfEntityCodes).sorted(), ["ABCD","ABCE","ZZYY"])
    }
    
    func test_ArrayOfEntityCodesContainingDuplicatePrintNumbersAcrossFilesForPrintNumber35ReturnsCorrectValues (){
        let arrayOfEntityCodes = MessageCollator.detectDuplicatePrintNumbersAcrossEntityLogs(entityLogs, true).entityCodesKeyedByDuplicate[35]!
    
        XCTAssertEqual(Set(arrayOfEntityCodes).sorted(), ["ABCD","BBCC"])
    }
    
    func test_ArrayOfEntityCodesContainingDuplicatePrintNumbersAcrossFilesForPrintNumber15ReturnsNil (){
        XCTAssertNil(MessageCollator.detectDuplicatePrintNumbersAcrossEntityLogs(entityLogs, true).entityCodesKeyedByDuplicate[15])
    }
    
    
    //List print numbers tests
    func test_HighestPrintNumberIsEqualTo11135 (){
        XCTAssertEqual(MessageCollator.printHighestUsedPrintNumber(for: entityLogs), 99999)
    }
    
    func test_ListAllPrintNumbersReturnsCorrectValues (){
        let expectedPrintNumbersSet = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 35, 36, 55, 72, 73, 95, 97, 98, 135, 191, 195, 197, 198, 199, 205, 206, 298, 299, 301, 398, 401, 402, 500, 1135, 9998, 11135, 99988, 99989, 99990, 99991, 99992, 99993, 99994, 99995, 99996, 99997, 99998, 99999]
        
        XCTAssertEqual(MessageCollator.printAllUsedPrintNumbers(for: entityLogs), expectedPrintNumbersSet)
    }
    func test_ListAllPrintNumbersForEntityCodeZZYYReturnsCorrectValues (){
        let expectedPrintNumbersSet = [195, 197, 198, 298, 299]
        
        let printNumbers =  MessageCollator.printAllUsedPrintNumbersByEntityCode(for: entityLogs)["ZZYY"]
        
        XCTAssertEqual(printNumbers, expectedPrintNumbersSet)
    }
    
    
    // MARK: -  🧪 Tests - File access SUT: shared messages contain correct data
    //Prove MessageCollator  accessing and compiling EntityLog Messages from multiple files
    func test_PrinteMessagesNotNil() {
        XCTAssertNotNil(printMessages)
    }
    
    func test_PrinterMessagesIndex72NotNil() {
        let message72 = printMessages[72]
        XCTAssertNotNil(message72)
    }
    
    func test_functionNumberForMessage72isequalto15() {
        let message72 = printMessages[72]
        let functionNumberForMessage72 = message72?.functionNumber
        XCTAssertEqual(functionNumberForMessage72 , 15)
    }
    
    func test_functionNumberInLogForMessage72isequalto1() {
        let message72 = printMessages[72]
        let functionNumberInEntityForMessage72 = message72?.functionNumberInEntity
        XCTAssertEqual(functionNumberInEntityForMessage72 , 1)
    }
    
    func test_functionNumberInEntityForMessage98isequalto2() {
        let message98 = printMessages[98]
        let functionNumberInEntityForMessage98 = message98?.functionNumberInEntity
        XCTAssertEqual(functionNumberInEntityForMessage98 , 2)
    }
    
    // MARK: -  🧪 Tests - Max entity code
    func test_MaxEntityCodeCharacterCountReturnsExpectedCount (){
        // maxEntityCodeCharacterCount is calculated from files
        let count =  MessageCollator.maxEntityCodeCharacterCount
        XCTAssertEqual(count , 4)
    }
    
    
    // MARK: - 🦮 Helpers - Mock SUT
    //Mock tests likely not of much use with this struct
    struct StubMessageCollator: DuplicatePrintNumberIdentifiable, UsedPrintNumberIdentifiable{
        
        static var duplicatePrintNumbersKeyedByEntityCode: [String : [Int]] = ["KUSF": [5,6,7],"LDUV": [5,6,10,11], "ZYXW": [8]]
        static var maxEntityCodeCharacterCount = 0
        
        //This is compiled by the EntityLog initialiser therefore pack manually here for the mock
        
        let messages: [Int: EntityLog.Message]
        
        init(from entityLogs: [EntityLog]) {
            var allEntityLogMessagesKeyedByPrintNumber = [Int: EntityLog.Message]()
            var allEntityLogMessagesKeys = [Int]()
            
            for entityLog in entityLogs{
                //4
                let array = Array(entityLog.messages.keys)
                allEntityLogMessagesKeys.append(contentsOf: array)
                
                allEntityLogMessagesKeyedByPrintNumber.merge(entityLog.messages) {(current,_) in current}
            }
            messages = allEntityLogMessagesKeyedByPrintNumber
        }
    }
    
    //Entity 1
    static let message5 = EntityLog.Message(entityCode: "KUSF", functionNumber: 568, functionNumberInEntity: 5, functionNumberAlwaysCustom: false, functionType: .actionMethod, nodeType: .guardFail, nodeNumberWithinFunction: 1, eventDescription: "description of event5", effectDescription: "description of consequence5")
    static let message6 = EntityLog.Message(entityCode: "KUSF", functionNumber: 568, functionNumberInEntity: 5, functionNumberAlwaysCustom: false, functionType: .customFunc, nodeType: .caseTrueNegativeOutcome, nodeNumberWithinFunction: 2, eventDescription: "description of event", effectDescription: "description of consequence")
    static let message7 = EntityLog.Message(entityCode: "KUSF", functionNumber: 568, functionNumberInEntity: 5, functionNumberAlwaysCustom: false, functionType: .systemOverride, nodeType: .caseTrueNegativeOutcome, nodeNumberWithinFunction: 3, eventDescription: "description of event", effectDescription: "description of consequence")
    
    //Entity 2
    static let message8 = EntityLog.Message(entityCode: "LDUV", functionNumber: 153, functionNumberInEntity: 2, functionNumberAlwaysCustom: false, functionType: .actionMethod, nodeType: .guardFail, nodeNumberWithinFunction: 1, eventDescription: "description of event5", effectDescription: "description of consequence5")
    static let message9 = EntityLog.Message(entityCode: "LDUV", functionNumber: 153, functionNumberInEntity: 2, functionNumberAlwaysCustom: false, functionType: .customFunc, nodeType: .caseTrueNegativeOutcome, nodeNumberWithinFunction: 2, eventDescription: "description of event", effectDescription: "description of consequence")
    static let message10 = EntityLog.Message(entityCode: "LDUV", functionNumber: 153, functionNumberInEntity: 2, functionNumberAlwaysCustom: false, functionType: .systemOverride, nodeType: .caseTrueNegativeOutcome, nodeNumberWithinFunction: 3, eventDescription: "description of event", effectDescription: "description of consequence")
    static let message11 = EntityLog.Message(entityCode: "LDUV", functionNumber: 153, functionNumberInEntity: 2, functionNumberAlwaysCustom: false, functionType: .systemOverride, nodeType: .caseTrueNegativeOutcome, nodeNumberWithinFunction: 4, eventDescription: "description of event", effectDescription: "description of consequence")
    
    //Two print number duplicates across the mock EntityLogs
    //There can never be a print number duplicate within a Message instance EntityLogs set the messages value to the print number key  – if it has multiple print numbers it will set it multiple times
    static let entityLog1 = EntityLog(messages: [5 : message5, 6 : message6, 7 : message7], printNumbers: [5,6,7], entityCode: "KUSF")
    static let entityLog2 = EntityLog(messages: [5 : message8, 6 : message9, 10 : message10, 11 : message11], printNumbers: [5,6,10,11], entityCode: "LDUV")
    
    static let fakeEntityLogs = [entityLog1,entityLog2]
    static let sut = StubMessageCollator(from: fakeEntityLogs)
    
    // MARK: - 🧪 Tests - Mock SUT:  Duplicates detected
    func test_MessageCollatorReturnsMultipleEntityLogsContainingDuplicatePrintNumbers () {
        let duplicateEntityCodes = StubMessageCollator.duplicatePrintNumbersKeyedByEntityCode.keys
        XCTAssertTrue(duplicateEntityCodes.contains("KUSF"))
        XCTAssertFalse(duplicateEntityCodes.contains("ABCD"))
        
    }
    
    func test_DuplicatePrintNumbersFoundWithinEntityCodesInMockEqualsFalse (){
        XCTAssertTrue(StubMessageCollator.detectDuplicatePrintNumbersWithinEntityLogs(StubMessageCollator.duplicatePrintNumbersKeyedByEntityCode, true))
    }
    
    func test_DuplicatePrintNumbersFoundAcrossFakeFilesEqualsTrue (){
        XCTAssertTrue(StubMessageCollator.detectDuplicatePrintNumbersAcrossEntityLogs(MessageCollatorTests.fakeEntityLogs, true).isDuplicatesDetected)
    }

}

