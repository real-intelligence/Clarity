//
//  SettingsManagerServiceTests.swift
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

typealias SMST = SettingsManagerServiceTests

class SettingsManagerServiceTests: XCTestCase {
    // MARK: -  🦮 Helpers - File access SUT
     let fileSut = ClarityActivator.settings
    
    struct MockPrinter: ClarityPrintHelper{
    }
    let printer = MockPrinter()
    
    var goForPrint = false
    
    // MARK: - 🧪 Tests -  File access SUT: assigned data returns correct values
    //NB! These are file access tests
    // Will fail if settings JSON file in framework ClarityJSON folder changes details
    
    func test_FileSettingsAllBoolSettingsReturnCorrectValues() {
        XCTAssertEqual(fileSut?.printAllClarityLogs  , false)
        XCTAssertEqual(fileSut?.logIsolatedPrintNumbersOnly  , false)
        XCTAssertEqual(fileSut?.logFunctionNamesOnly  , false)
        XCTAssertEqual(fileSut?.suppressLogFunctionNames  , false)
        XCTAssertEqual(fileSut?.calculateFunctionNumbersRelativeToEntity  , false)
        XCTAssertEqual(fileSut?.calculateNodeNumbersRelativeToFunction  , false)
        XCTAssertEqual(fileSut?.displayNodePrintNumberWhenUsingRelativeNumbering  , false)
        XCTAssertEqual(fileSut?.listAllUsedPrintNumbers  , false)
        XCTAssertEqual(fileSut?.listAllUsedPrintNumbersByEntityCode  , false)
        XCTAssertEqual(fileSut?.listHighestUsedPrintNumber  , false)
        XCTAssertEqual(fileSut?.displayNodeInformationWithoutDescriptions  , false)
    }
    
    func test_FileSettingsSubStructArraysNotNil() {
        XCTAssertNotNil(fileSut?.isolatedPrintNumbers)
        XCTAssertNotNil(fileSut?.isolatedEntities)
    }
    
    func test_FileSettingsIsolatedEntitiesArrayReturnCorrectValues() {
        XCTAssertEqual(fileSut?.isolatedEntities[0].isolate  , false)
        XCTAssertEqual(fileSut?.isolatedEntities[0].entityCode  , "ABCD")
        XCTAssertEqual(fileSut?.isolatedEntities[1].isolate  , false)
        XCTAssertEqual(fileSut?.isolatedEntities[1].entityCode  , "ABCE")
    }
    
    func test_FileSettingsIsolatedPrintNumbersArrayReturnCorrectValues() {
        XCTAssertEqual(fileSut?.isolatedPrintNumbers[0]  , 72)
        XCTAssertEqual(fileSut?.isolatedPrintNumbers[1]  , 1)
    }
    
    
    
    // MARK: - 🦮 Helpers - Fake data SUT
    //These represent separate entities (JSON files) specified in the isolatedEntities
    static var isolatedEntity1 = SettingsManagerService.IsolatedEntity(entityCode: "", isolate: false)
    static var isolatedEntity2 = SettingsManagerService.IsolatedEntity(entityCode: "", isolate: false)
    static var isolatedEntity3 = SettingsManagerService.IsolatedEntity(entityCode: "", isolate: false)
    
   
    static var isolatedFunctionEntity1 = SettingsManagerService.IsolatedFunction(entityCode: "", isolate: false, isolatedFunctionNumbers: [])
    static var isolatedFunctionEntity2 = SettingsManagerService.IsolatedFunction(entityCode: "", isolate: false, isolatedFunctionNumbers: [])
    
    //Make fakeSettings static and add a teardown to allow other files to use it
    static var fakeSettings = SettingsManagerService(suppressAllClarityLogs: false,
                                              printAllClarityLogs: false,
                                     logFunctionNamesOnly: false,
                                     logIsolatedPrintNumbersOnly: false,
                                     isolatedPrintNumbers: [],
                                     suppressLogFunctionNames: false,
                                     isolatedEntities: [isolatedEntity1,isolatedEntity2,isolatedEntity3],
                                     isolatedFunctions: [isolatedFunctionEntity1,isolatedFunctionEntity2],
                                     calculateFunctionNumbersRelativeToEntity: false,
                                     calculateNodeNumbersRelativeToFunction: false,
                                     displayNodePrintNumberWhenUsingRelativeNumbering: false,
                                     displayNodeInformationWithoutDescriptions: false,
                                     listAllUsedPrintNumbers: false,
                                     listAllUsedPrintNumbersByEntityCode: false,
                                     listHighestUsedPrintNumber: false,
                                     alertOrphanedPrintNumbersDetected: false)
                                 
    
    override func tearDown(){
        
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = false
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = false
        SMST.fakeSettings.displayNodeInformationWithoutDescriptions = false
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = false
        SMST.fakeSettings.isolatedEntities = [SMST.isolatedEntity1,SMST.isolatedEntity2,SMST.isolatedEntity3]
        SMST.fakeSettings.isolatedFunctions = [SMST.isolatedFunctionEntity1,SMST.isolatedFunctionEntity2]
        SMST.fakeSettings.isolatedPrintNumbers = []
        SMST.fakeSettings.listAllUsedPrintNumbers = false
        SMST.fakeSettings.listAllUsedPrintNumbersByEntityCode = false
        SMST.fakeSettings.listHighestUsedPrintNumber = false
        SMST.fakeSettings.logFunctionNamesOnly = false
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = false
        SMST.fakeSettings.printAllClarityLogs = false
        SMST.fakeSettings.suppressAllClarityLogs = false
        SMST.fakeSettings.suppressLogFunctionNames = false
    }

    // MARK: - 🧪 Tests - Fake data SUT:  Print Scenario correct returns
 
    // Non Valid Scenario 1
    func test_NonValidScenario1_PrintListedPrintNumbersFromEmptyArray() {
        
        SMST.fakeSettings.isolatedPrintNumbers = []
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = true
        //ABCD
        //  testing decision node print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
    }
    // Non Valid Scenario 2
    func test_NonValidScenario2_FunctionNamesOnlyANDNoFunctionNames() {
        
        SMST.fakeSettings.logFunctionNamesOnly = true
        SMST.fakeSettings.suppressLogFunctionNames = true
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
    }
    
    
    //Note! having to hard code in argument to nodeType: because it is a mock – the real thing supplies correct value from JSON tested elsewhere
    // NOGO  Scenario 1
    func test_Scenario1_IsolatingPrintNumbers_ReturnsCorrectValueForPrintNumber() {

        SMST.fakeSettings.isolatedPrintNumbers = [72,1,95,97]
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = true
  
        // Print 1 == NodeType 2 ElseIfFalseCondition
        //Print number is in the array and is isloating should print
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        // Print 2 == NodeType 1 ifTrueCondition
        //Print number Not in the array and is isloating should NOT print
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 2, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        print(SMST.fakeSettings.isolatedPrintNumbers)
        print(SMST.fakeSettings.logIsolatedPrintNumbersOnly)
    }
    

    
    
    
    
    
     // NOGO  Scenarios 1 & 2
    func test_Scenario1AND2_IsolatingPrintNumbersWithLogFunctionNamesOnly_ReturnsCorrectBoolForMessageType() {
        
        SMST.fakeSettings.logFunctionNamesOnly = true
        SMST.fakeSettings.isolatedPrintNumbers = [72,1,95,97] //MessageTypes 72 ==0,  1==2, 95==2, 97==0
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = true
       
        // Print 72  and 97 are function name types should be true. 1 and 95 should be false – NB! Evaluation based on message type
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 95, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 97, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        
        // Print 301 is function name type but outside of isolated array – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 301, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)

        // Print 3 is ifTrueConditionNegativeOutcome fulfils NEITHER condition – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 3, NodeType.ifTrueConditionNegativeOutcome, &goForPrint)
        XCTAssertEqual(goForPrint, false)
    }
    
    // NOGO  Scenario 2
    func test_Scenario2_LogFunctionNamesOnly_ReturnsCorrectBoolForMessageType() {
        
        SMST.fakeSettings.logFunctionNamesOnly = true
       
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)

        printer.goForPrintFromSettings(SMST.fakeSettings, "", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)
    }
    
    
    // NOGO  Scenario 3
    func test_Scenario3_LogFunctionNamesOnly_ReturnsCorrectBoolForMessageType() {
        
        SMST.fakeSettings.suppressLogFunctionNames = true
       
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)

        printer.goForPrintFromSettings(SMST.fakeSettings, "", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
    }
    
    // NOGO  Scenarios 1 & 3
    func test_Scenario1AND3_IsolatingPrintNumbersWithSuppressFunctionName_ReturnsCorrectBoolForMessageType() {
        
        SMST.fakeSettings.suppressLogFunctionNames = true
        SMST.fakeSettings.isolatedPrintNumbers = [72,1,95,97] //MessageTypes 72 ==0,  1==2, 95==2, 97==0
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = true
       
        // Print 72  and 97 are function name types should be false. 1 and 95 should be true – NB! Evaluation based on message type
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 95, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 97, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        // Print 301 is function name type but outside of isolated array – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 301, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)

        // Print 3 is ifTrueConditionNegativeOutcome fulfils NEITHER condition – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 3, NodeType.ifTrueConditionNegativeOutcome, &goForPrint)
        XCTAssertEqual(goForPrint, false)
    }
    
    
    
    
    // NOGO  Scenario 4
    func test_Scenario4_IsolatingEntity_ReturnsCorrectBoolForPrintNumber() {
        SMST.fakeSettings.isolatedEntities[0].entityCode = "ABCD"
        SMST.fakeSettings.isolatedEntities[0].isolate = true
        SMST.fakeSettings.isolatedEntities[1].entityCode = "ABCE"
        SMST.fakeSettings.isolatedEntities[1].isolate = true
        SMST.fakeSettings.isolatedEntities[2].entityCode = "ZZYY"
        SMST.fakeSettings.isolatedEntities[2].isolate = false
       
        //ABCD
        //  testing decision node print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCD", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCD", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)

        //ABCE
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCE", 95, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCE", 97, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)

        //ZZYY
        printer.goForPrintFromSettings(SMST.fakeSettings, "ZZYY", 195, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ZZYY", 197, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        SMST.fakeSettings.isolatedEntities[0].isolate = false
        SMST.fakeSettings.isolatedEntities[1].isolate = false
        SMST.fakeSettings.isolatedEntities[2].isolate = true
        
        //ABCD
        //  testing decision node print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCD", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCD", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)

        //ABCE
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCE", 95, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCE", 97, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)

        //ZZYY
        printer.goForPrintFromSettings(SMST.fakeSettings, "ZZYY", 195, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ZZYY", 197, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)
    }
    
    // NOGO  Scenario 5
    func test_Scenario5_IsolatedFunctions_ReturnCorrectBoolForPrintNumbers() {
        SMST.fakeSettings.isolatedFunctions[0].entityCode = "BBCC"
        SMST.fakeSettings.isolatedFunctions[0].isolate = true
        SMST.fakeSettings.isolatedFunctions[0].isolatedFunctionNumbers = [1, 27]
        SMST.fakeSettings.isolatedFunctions[1].entityCode = "ABCE"
        SMST.fakeSettings.isolatedFunctions[1].isolate = false
        SMST.fakeSettings.isolatedFunctions[1].isolatedFunctionNumbers = [27]
     
        
        
        // With neutral settings all would be true
        // Function number needs to be hard passed for the test
        //The function number that contains the print number is calculated by the printLogic() function and passed to goForPrintFromSettings
        
        printer.goForPrintFromSettings(SMST.fakeSettings, "BBCC", 205,functionNumber:27, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        printer.goForPrintFromSettings(SMST.fakeSettings, "BBCC", 199,functionNumber:26, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        printer.goForPrintFromSettings(SMST.fakeSettings, "BBCC", 401,functionNumber:1127, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCE", 97,functionNumber:27, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
    }
    
    
    // GO  Scenarios False with Master  LogAllPrintNumber becomes true
    func test_ScenariosFalse_MasterLogAllPrintNumbers_ReturnsGoForPrintTrue() {
        
        SMST.fakeSettings.printAllClarityLogs = true
        
        SMST.fakeSettings.logFunctionNamesOnly = true
        SMST.fakeSettings.isolatedPrintNumbers = [72,1,95,97] //MessageTypes 72 ==0,  1==2, 95==2, 97==0
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = true
       
        // Print 72  and 97 are function name types should be true. 1 and 95 should be false – NB! Evaluation based on message type
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 95, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        
        // Print 301 is function name type but outside of isolated array – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 301, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)

        // Print 3 is ifTrueConditionNegativeOutcome fulfils NEITHER condition – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 3, NodeType.ifTrueConditionNegativeOutcome, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        
        SMST.fakeSettings.isolatedEntities[0].entityCode = "ABCD"
        SMST.fakeSettings.isolatedEntities[0].isolate = true
        SMST.fakeSettings.isolatedEntities[1].entityCode = "ABCE"
        SMST.fakeSettings.isolatedEntities[1].isolate = true
        SMST.fakeSettings.isolatedEntities[2].entityCode = "ZZYY"
        SMST.fakeSettings.isolatedEntities[2].isolate = false
        
        //ZZYY
        printer.goForPrintFromSettings(SMST.fakeSettings, "ZZYY", 195, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ZZYY", 197, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        
        SMST.fakeSettings.isolatedEntities[0].isolate = false
        SMST.fakeSettings.isolatedEntities[1].isolate = false
        SMST.fakeSettings.isolatedEntities[2].isolate = true
        
        //ABCD
        //  testing decision node print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCD", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCD", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)

        //ABCE
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCE", 95, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCE", 97, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        
        
        SMST.fakeSettings.suppressLogFunctionNames = true
        SMST.fakeSettings.isolatedPrintNumbers = [72,1,95,97] //MessageTypes 72 ==0,  1==2, 95==2, 97==0
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = true
        
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 97, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        
        // Print 301 is function name type but outside of isolated array – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 301, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)

        // Print 3 is ifTrueConditionNegativeOutcome fulfils NEITHER condition – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 3, NodeType.ifTrueConditionNegativeOutcome, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        
        
        SMST.fakeSettings.suppressLogFunctionNames = true
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        
        SMST.fakeSettings.logFunctionNamesOnly = true
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        
        SMST.fakeSettings.logFunctionNamesOnly = true
        SMST.fakeSettings.isolatedPrintNumbers = [72,1,95,97] //MessageTypes 72 ==0,  1==2, 95==2, 97==0
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = true
       
        // Print 72  and 97 are function name types should be true. 1 and 95 should be false – NB! Evaluation based on message type
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 95, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        
        // Print 301 is function name type but outside of isolated array – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 301, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        // Print 3 is ifTrueConditionNegativeOutcome fulfils NEITHER condition – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 3, NodeType.ifTrueConditionNegativeOutcome, &goForPrint)
        XCTAssertEqual(goForPrint, true)
        
        SMST.fakeSettings.isolatedPrintNumbers = [72,1,95,97]
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = true
  
        // Print 2 == NodeType 1 ifTrueCondition
        //Print number Not in the array and is isloating should NOT print
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 2, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, true)
    }
    
    // GO  Scenarios True with Master  SuppressAllPrintNumber becomes false (testing double flip)
    func test_ScenariosTrue_MasterSuppressAllPrintNumbers_ReturnsGoForPrintFalse() {
        SMST.fakeSettings.suppressAllClarityLogs = true
        
        SMST.fakeSettings.printAllClarityLogs = true
        
        SMST.fakeSettings.logFunctionNamesOnly = true
        SMST.fakeSettings.isolatedPrintNumbers = [72,1,95,97] //MessageTypes 72 ==0,  1==2, 95==2, 97==0
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = true
       
        // Print 72  and 97 are function name types should be true. 1 and 95 should be false – NB! Evaluation based on message type
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 95, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        // Print 301 is function name type but outside of isolated array – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 301, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)

        // Print 3 is ifTrueConditionNegativeOutcome fulfils NEITHER condition – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 3, NodeType.ifTrueConditionNegativeOutcome, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        SMST.fakeSettings.isolatedEntities[0].entityCode = "ABCD"
        SMST.fakeSettings.isolatedEntities[0].isolate = true
        SMST.fakeSettings.isolatedEntities[1].entityCode = "ABCE"
        SMST.fakeSettings.isolatedEntities[1].isolate = true
        SMST.fakeSettings.isolatedEntities[2].entityCode = "ZZYY"
        SMST.fakeSettings.isolatedEntities[2].isolate = false
        
        //ZZYY
        printer.goForPrintFromSettings(SMST.fakeSettings, "ZZYY", 195, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ZZYY", 197, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        SMST.fakeSettings.isolatedEntities[0].isolate = false
        SMST.fakeSettings.isolatedEntities[1].isolate = false
        SMST.fakeSettings.isolatedEntities[2].isolate = true
        
        //ABCD
        //  testing decision node print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCD", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCD", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)

        //ABCE
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCE", 95, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        //  testing function print numbers
        printer.goForPrintFromSettings(SMST.fakeSettings, "ABCE", 97, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        
        SMST.fakeSettings.suppressLogFunctionNames = true
        SMST.fakeSettings.isolatedPrintNumbers = [72,1,95,97] //MessageTypes 72 ==0,  1==2, 95==2, 97==0
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = true
        
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 97, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        // Print 301 is function name type but outside of isolated array – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 301, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)

        // Print 3 is ifTrueConditionNegativeOutcome fulfils NEITHER condition – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 3, NodeType.ifTrueConditionNegativeOutcome, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        
        SMST.fakeSettings.suppressLogFunctionNames = true
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 72, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        SMST.fakeSettings.logFunctionNamesOnly = true
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        SMST.fakeSettings.logFunctionNamesOnly = true
        SMST.fakeSettings.isolatedPrintNumbers = [72,1,95,97] //MessageTypes 72 ==0,  1==2, 95==2, 97==0
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = true
       
        // Print 72  and 97 are function name types should be true. 1 and 95 should be false – NB! Evaluation based on message type
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 1, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 95, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        // Print 301 is function name type but outside of isolated array – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 301, NodeType.functionName, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        // Print 3 is ifTrueConditionNegativeOutcome fulfils NEITHER condition – should be false.
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 3, NodeType.ifTrueConditionNegativeOutcome, &goForPrint)
        XCTAssertEqual(goForPrint, false)
        
        SMST.fakeSettings.isolatedPrintNumbers = [72,1,95,97]
        SMST.fakeSettings.logIsolatedPrintNumbersOnly = true
  
        // Print 2 == NodeType 1 ifTrueCondition
        //Print number Not in the array and is isloating should NOT print
        printer.goForPrintFromSettings(SMST.fakeSettings, "", 2, NodeType.elseCondition, &goForPrint)
        XCTAssertEqual(goForPrint, false)
    }


    // MARK: - 🧪 Tests - Fake data SUT:  Display option correct returns

    func test_IsolatedPrintNumbersArrayFirstObject_Returns72() {
        XCTAssertEqual(fileSut?.isolatedPrintNumbers.first, 72)
    }
    func test_IsolatedEntitiesArrayFirstObjectKeyEntityCode_ReturnsName() {
        XCTAssertEqual(fileSut?.isolatedEntities[0].entityCode , "ABCD")
    }





    
}

