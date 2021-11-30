//
//  PrintOverloadVisualConsoleCheck.swift
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

// This test class is for a quick visual check of the result of Clarity print statments in the console.
// It for use when designing how print statments are displayed
// It is also important as a final alignment check being as there are no alignment callbacks from the console
// – this led to the discovery of the issue regarding Apple symbols returning a character count of 1 while taking two character spaces in the console


class PrintOverloadVisualConsoleCheck: XCTestCase {
    
    override func tearDown(){
        
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = false
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = false
        SMST.fakeSettings.displayNodeSequenceWithoutDescriptions = false
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
    

    
    // MARK: - 👀 Visual console check  -  default settings
    func test_VisualTest_AllPrintNodeTypesAlignCorrectlyInConsole_WithDefaultSettings() {
        //All of the nodes tested here are tested for correct formatting in other test classes – this is for a visual alignment check
        //This test also used to demonstrate how different node types behave with unexpected arguments
        
        let someDic = ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]
        let someArray = [11,2,3,4,5,6,7]
        let someSingle = "a"
        
        //NodeType  2 (else condition) – one digit print number
        print(1)
        print(1, functionName: #function)
        print(1, values:someDic)
        //NodeType  6 (case true negative outcome)
        print(5)
        print(5, values:someDic)
        print(5, values:someArray)
        print(5, values:someSingle)
        //NodeType 2 (else condition) – three digit print number  – ZZYY
        print(195)
        //functionName argument will override node type printing as a function name  (Node type 0)
        print(195, functionName: #function)
        //values argument will override node type printing as a value reporter  (Node type 11)
        //It will still use the event description to describe the variable as expected (although this may not be intended)
        print(195, values:someDic)
        //NodeType 2 (else condition) – three digit print number  – BBCC
        print(191, functionName:#function)
        print(191)
        //NodeType 0 (function name)
        print(72, functionName:#function)
        //Function name with argument omitted prints still formats as a function name ( displaying function number) but function name is unprinted
        print(72)
        //NodeType 2 (else condition) – four digit function number  – BBCC
        print(401)
        //NodeType 2 (else condition) – five digit function number  – BBCC
        print(402)
        //NodeType 9 (do try pass)
        print(10)
        //NodeType 1 (if true condition)
        print(135)
        //NodeType 1 (if true condition) – four digit print number
        print(1135)
        //NodeType 1 (if true condition) – five digit print number
        print(11135)
        //NodeType 3 (if true condition negative outcome)
        print(3)
        //NodeType 4 (else condition positive outcome)
        print(4)
        //NodeType 5 (case true positive outcome)
        print(5)
        //NodeType 7 (guard pass)
        print(7)
        //NodeType 8 (guard fail)
        print(8)
        //NodeType 10 (catch try fail)
        print(10)
        //NodeType 11 (value reporter) with argument
        print(206, values:someDic)
        //NodeType 11 (value reporter) without argument prints as a 'reporter'
        //It will print the event description – used for commenting about the node in the console
        print(206)
        
        let error: Error = MyError.customError
        //NodeType 12 (error reporter) with argument
        //It will print the event description – to describe the source of the error (i.e. variable name)
        //It will also print the error – from the Error or LocalizedError if available
        print(299, values:error)
        //NodeType 12 (error reporter) without argument
        //It will print the event description – to describe the source of the error (i.e. variable name) without describing the actual error...
        // (likely never intentional to omit the argument here)
        print(299)
        //NodeType 1 (if true condition) – colourised EntityCode
        print(500)
        //NodeType 2 (else condition) – five digit print number,  five digit function number
        print(99998)
    }
    
    // MARK: - 👀 Visual console check  -  relative settings
    func test_VisualTest_AllPrintNodeTypesAlignCorrectlyInConsole_WithRelativeDisplaySettings() {
        //All of the nodes tested here are tested for correct formatting in other test classes – this is for a visual alignment check
        //This test also used to demonstrate how different node types behave with unexpected arguments
       
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
       
        
        let someDic = ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]
        let someArray = [11,2,3,4,5,6,7]
        let someSingle = "a"
        
        //NodeType  2 (else condition) – one digit print number
        print(1,settings: SMST.fakeSettings)
        print(1, functionName: #function,settings: SMST.fakeSettings)
        print(1, values:someDic,settings: SMST.fakeSettings)
        //NodeType  6 (case true negative outcome)
        print(5,settings: SMST.fakeSettings)
        print(5, values:someDic,settings: SMST.fakeSettings)
        print(5, values:someArray,settings: SMST.fakeSettings)
        print(5, values:someSingle,settings: SMST.fakeSettings)
        //NodeType 2 (else condition) – three digit print number  – ZZYY
        print(195,settings: SMST.fakeSettings)
        //functionName argument will override node type printing as a function name  (Node type 0)
        print(195, functionName: #function,settings: SMST.fakeSettings)
        //values argument will override node type printing as a value reporter  (Node type 11)
        //It will still use the event description to describe the variable as expected (although this may not be intended)
        print(195, values:someDic,settings: SMST.fakeSettings)
        //NodeType 2 (else condition) – three digit print number  – BBCC
        print(191, functionName:#function,settings: SMST.fakeSettings)
        print(191,settings: SMST.fakeSettings)
        //NodeType 0 (function name)
        print(72, functionName:#function,settings: SMST.fakeSettings)
        //Function name with argument omitted prints still formats as a function name ( displaying function number) but function name is unprinted
        print(72,settings: SMST.fakeSettings)
        //NodeType 2 (else condition) – four digit function number  – BBCC
        print(401,settings: SMST.fakeSettings)
        //NodeType 2 (else condition) – five digit function number  – BBCC
        print(402,settings: SMST.fakeSettings)
        //NodeType 9 (do try pass)
        print(10,settings: SMST.fakeSettings)
        //NodeType 1 (if true condition)
        print(135,settings: SMST.fakeSettings)
        //NodeType 1 (if true condition) – four digit print number
        print(1135,settings: SMST.fakeSettings)
        //NodeType 1 (if true condition) – five digit print number
        print(11135,settings: SMST.fakeSettings)
        //NodeType 3 (if true condition negative outcome)
        print(3,settings: SMST.fakeSettings)
        //NodeType 4 (else condition positive outcome)
        print(4,settings: SMST.fakeSettings)
        //NodeType 5 (case true positive outcome)
        print(5,settings: SMST.fakeSettings)
        //NodeType 7 (guard pass)
        print(7,settings: SMST.fakeSettings)
        //NodeType 8 (guard fail)
        print(8,settings: SMST.fakeSettings)
        //NodeType 10 (catch try fail)
        print(10,settings: SMST.fakeSettings)
        //NodeType 11 (value reporter) with argument
        print(206, values:someDic,settings: SMST.fakeSettings)
        //NodeType 11 (value reporter) without argument prints as a 'reporter'
        //It will print the event description – used for commenting about the node in the console
        print(206,settings: SMST.fakeSettings)
        
        let error: Error = MyError.customError
        //NodeType 12 (error reporter) with argument
        //It will print the event description – to describe the source of the error (i.e. variable name)
        //It will also print the error – from the Error or LocalizedError if available
        print(299, values:error,settings: SMST.fakeSettings)
        //NodeType 12 (error reporter) without argument
        //It will print the event description – to describe the source of the error (i.e. variable name) without describing the actual error...
        // (likely never intentional to omit the argument here)
        print(299,settings: SMST.fakeSettings)
        //NodeType 1 (if true condition) – colourised EntityCode
        print(500,settings: SMST.fakeSettings)

        //NodeType 2 (else condition) – five digit print number,  five digit function number
        print(99998,settings: SMST.fakeSettings)
    }
    
    // MARK: - 👀 Visual console check  -  node only settings
    func test_VisualTest_AllExpectedPrintNodeTypesAlignCorrectlyInConsole_WithNodeOnlyDisplaySettings() {
        //All of the nodes tested here are tested for correct formatting in other test classes – this is for a visual alignment check only
        //This test also used to demonstrate how different node types behave with unexpected arguments
       
        SMST.fakeSettings.displayNodeSequenceWithoutDescriptions = true
        SMST.fakeSettings.suppressLogFunctionNames = true
       
        let someDic = ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]
        let someArray = [11,2,3,4,5,6,7]
        let someSingle = "a"
        
        //NodeType  2 (else condition) – one digit print number
        print(1,settings: SMST.fakeSettings)
        print(1, functionName: #function,settings: SMST.fakeSettings)
        print(1, values:someDic,settings: SMST.fakeSettings)
        //NodeType  6 (case true negative outcome)
        print(5,settings: SMST.fakeSettings)
        print(5, values:someDic,settings: SMST.fakeSettings)
        print(5, values:someArray,settings: SMST.fakeSettings)
        print(5, values:someSingle,settings: SMST.fakeSettings)
        //NodeType 2 (else condition) – three digit print number  – ZZYY
        print(195,settings: SMST.fakeSettings)
        //functionName argument will override node type printing as a function name  (Node type 0)
        print(195, functionName: #function,settings: SMST.fakeSettings)
        //values argument will override node type printing as a value reporter  (Node type 11)
        //It will still use the event description to describe the variable as expected (although this may not be intended)
        print(195, values:someDic,settings: SMST.fakeSettings)
        //NodeType 2 (else condition) – three digit print number  – BBCC
        print(191, functionName:#function,settings: SMST.fakeSettings)
        print(191,settings: SMST.fakeSettings)
        //NodeType 0 (function name)
        print(72, functionName:#function,settings: SMST.fakeSettings)
        //Function name with argument omitted prints still formats as a function name ( displaying function number) but function name is unprinted
        print(72,settings: SMST.fakeSettings)
        //NodeType 2 (else condition) – four digit function number  – BBCC
        print(401,settings: SMST.fakeSettings)
        //NodeType 2 (else condition) – five digit function number  – BBCC
        print(402,settings: SMST.fakeSettings)
        //NodeType 9 (do try pass)
        print(10,settings: SMST.fakeSettings)
        //NodeType 1 (if true condition)
        print(135,settings: SMST.fakeSettings)
        //NodeType 1 (if true condition) – four digit print number
        print(1135,settings: SMST.fakeSettings)
        //NodeType 1 (if true condition) – five digit print number
        print(11135,settings: SMST.fakeSettings)
        //NodeType 3 (if true condition negative outcome)
        print(3,settings: SMST.fakeSettings)
        //NodeType 4 (else condition positive outcome)
        print(4,settings: SMST.fakeSettings)
        //NodeType 5 (case true positive outcome)
        print(5,settings: SMST.fakeSettings)
        //NodeType 7 (guard pass)
        print(7,settings: SMST.fakeSettings)
        //NodeType 8 (guard fail)
        print(8,settings: SMST.fakeSettings)
        //NodeType 10 (catch try fail)
        print(10,settings: SMST.fakeSettings)
        //NodeType 11 (value reporter) with argument
        print(206, values:someDic,settings: SMST.fakeSettings)
        //NodeType 11 (value reporter) without argument prints as a 'reporter'
        //It will print the event description – used for commenting about the node in the console
        print(206,settings: SMST.fakeSettings)
        
        let error: Error = MyError.customError
        //NodeType 12 (error reporter) with argument
        //It will print the event description – to describe the source of the error (i.e. variable name)
        //It will also print the error – from the Error or LocalizedError if available
        print(299, values:error,settings: SMST.fakeSettings)
        //NodeType 12 (error reporter) without argument
        //It will print the event description – to describe the source of the error (i.e. variable name) without describing the actual error...
        // (likely never intentional to omit the argument here)
        print(299,settings: SMST.fakeSettings)
        //NodeType 1 (if true condition) – colourised EntityCode
        print(500,settings: SMST.fakeSettings)

        //NodeType 2 (else condition) – five digit print number,  five digit function number
        print(99998,settings: SMST.fakeSettings)
    }
    
    func test_VisualTest_PrintNumber() {
        //Test stub for inspecting the result of specific conditions affecting a print number
    }
    
    func test_VisualTestPrintNumberNotInEntityLogsPrintsNothingInConsole() {
        print(100000)
    }
    
    func test_VisualTestPrintNumberInSplitEntityLogJSONFileRendersNormally() {
        print(7856)
    }
    
    // MARK: - 🧪 Miscellaneous
    func test_AppleSymbolCharacterCountReturnsIntValue1() {
        //Test for specific Apple symbols
        //Add any symbol suspected to return a count other than 1
        let symbol = "🔴"
         
        XCTAssertEqual(symbol.count, 1)
    }
    
    
    func test_QuickTest() {
        // Placeholder for quick enquiry into specific conditions that may arise.
       
    }
}


// MARK: - 🦮 Helpers - Visual console checks
public enum MyError: Error {
    case customError
}
extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError:
            return NSLocalizedString("A user-friendly description of the error.", comment: "My error")
        }
    }
}

