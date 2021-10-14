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


class PrintOverloadVisualConsoleCheck: XCTestCase {
    
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
    
    
    // For use as a final visual check of results of the release version print() method as they appear in the console
    
    func test_PrintNewAPIFunctioName() {
        
        print(5, functionName:#function)
    }
    
    func test_PrintFunctioNameWithoutArgument() {
        
        print(73)
    }
    
    func test_Print301() {
        
        print(301, values:"a")
    }
    
  
    func test_VisualError() {
        
        Swift.print("ABCD        15    E-2     ☎️  - Error for Decision event description is:")
        Swift.print("ABCD         1    E-2        206  ☎️  - Error for Decision event description is:")
    }

    func test_Plain2() {
        print(2)
    }
    
    func test_PrintNUmberNotInEntityLogs() {
        print(100000)
    }
    
    func test_Plain() {
        
        let error: Error = MyError.customError
//        print(2, values:error)
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
//        print(2, values:error, settings: SMST.fakeSettings)
        
        print(299, values:error)
        print(299)
        print(299, values:error, settings: SMST.fakeSettings)
        
    }
    
    func test_PrintReporterWithoutSpecification() {
        print(2, values: "a")
    }
    
    func test_206() {
        //206 is NodeType case valueReporter (11)
        //Testing call without a value
        print(206)  //prints as a report (printing event_description only)
      
        
        
        
    }
    

    func test_PrintNodeDecisiontypesAlignCorrectlyInConsole() {
        let someDic = ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]
        let someArray = [11,2,3,4,5,6,7]
        let someSingle = "a"
        print(5)
        print(5, values:someDic)
        print(5, values:someArray)
        print(5, values:someSingle)
        print(1)
        print(1, functionName: #function)
        print(1, values:someDic)
        print(195)
        print(195, functionName: #function)
        print(195, values:someDic)
        print(191, functionName:#function)
        print(191)
        //Function argument will override node type number (205 listed as 1 - decision type false)
        //It doesnt matter what node node number used – it will display as a function if it uses the overload for function and supplying the function macro for its argument
        print(205, functionName:#function)
        //Displays properly as a node when function parameter not supplied
        print(205)
        
        //Node listed as a function in the json
        print(206, functionName:#function) //prints function number and name as expected
        print(206)  //prints function number but leaves function name unprinted
       
        //Values argument also override node type number
        //But will include Decision event description in its report
        //Does not print consequence
        //Relative node number becomes Relative report number (sequence it is listed under that function including nodes0
       
        print(301, values:678)
        print(401, functionName:#function)
        print(401)
        print(401, values:someDic)
        print(402, functionName:#function)
        print(402)
        print(402, values:someDic)
        print(10)
        print(135)
        print(1135)
        print(11135)
        print(195)
        print(2)
        print(398)
    }
    
    // MARK: - 🦮 Helpers - Fake settings data for File access SUT
    // SettingsManagerService is not the SUT in these tests - the SUT is the returned tuple from print logic
 
    
    
    
    
    
    func test_PrintNodeRelative() {
        //For  quick visual check of any print number
        
        let someDic = ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]
//        let someArray = [11,2,3,4,5,6,7]
//        let someSingle = "a"
        
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
       
        
        
        print(398,functionName:#function)
        print(11,settings: SMST.fakeSettings)
        print(398,settings: SMST.fakeSettings)
        print(9998,settings: SMST.fakeSettings)
        print(99998,settings: SMST.fakeSettings)
        print(11,values:someDic, settings: SMST.fakeSettings)

    }
    
    func test_PrintNodeNonRelative() {
        let someDic = ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]
        //For  quick visual check of any print number
//        print(398,#function)
//        print(11,settings: SMST.fakeSettings)
//        print(398)
//        print(9998)
        print(99998)
    print(11,values:someDic, settings: SMST.fakeSettings)
    }
    
    func test_Length() {
        let symbol = "🔴"
         
        XCTAssertEqual(symbol.count, 1)
    }
    
    
    func test_PrintBasicNodes() {
        //For  quick visual check of any print number
        print(1)
        print(2)
        print(3)
        print(4)
        print(5)
        print(6)
        print(7)
        print(8)
        print(9)
        print(10)
        
    }
    
    func test_PrintNodeDisplayCorrectlyInConsole() {
        //For  quick visual check of any print number
        print(206,  values: "1")
    }
    
    func test_ValuesAlign() {
        let someDic = ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]
        let someArray = [11,2,3,4,5,6,7]
        print(5, values:someDic)
        print(5, values:someArray)
        print(5, values: "1")
        print(401)
    }
    func test_DictionaryTypes() {
        let someDic = [1:1, 2:2, 3:3, 4:4, 5:5, 6:6, 7:7, 8:8, 9:9]
       
        print(5, values:someDic)
    }
    
    func test_SetType() {
        var mySet = Set<Int>()
         mySet = [11,2,3,4,5,6,7]
        print(5, values:mySet)
    }

    
    
    
    func test_PrintNumber301ShowsValue() {
        print(301, values:678)
    }

 
    func test_Array() {
         
        let strings: [String?] = ["lisk", "misk", "nisk", "pisk"]
        
//        let indexesToNil = [1,2]
//        let indexAndString: [String?] = strings.enumerated().map { (index, element) in
//            var element = element
//            if indexesToNil.contains(index){
//                element = nil
//            }
//            return "\(index): \(String(describing: element))"
//        }
//        print(indexAndString)
        let newStrings  = setNilForIndexes([1,2,6], forArray: strings)
        Swift.print(newStrings)
        Swift.print(strings)
        
        let newStrings2:[String?]  = strings.setNilForIndexes([1,2,6])
        Swift.print("newStrings2", newStrings2)
        Swift.print(strings)
        
    }
    func setNilForIndexes<T>(_ indexesToNil:[Int], forArray:[T?]) -> [T?]{
         
        let alteredArray: [T?] = forArray.enumerated().map { (index, element) in
            var element = element
            if indexesToNil.contains(index){
                element = nil
            }
            return element
        }
        return alteredArray
    }
    
    func test_Extensions() {
        //Why does this provoke N-4 on 15!!!
       let fg =  3.increment
        Swift.print(fg)
    }
    
    
    
}

extension Array{
    
    func setNilForIndexes<T>(_ indexesToNil:[Int]) -> [T?]{
         
         
        let alteredArray: [T?] = self.enumerated().map { (index, element) in
            var element: T? = element as? T
            if indexesToNil.contains(index){
                element = nil
            }
            return element
        }
        return alteredArray
    }
    
    
}

extension Int{
    
    var increment: Int {
            return self + 1
       }
    
    
}


