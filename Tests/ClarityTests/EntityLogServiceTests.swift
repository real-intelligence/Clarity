//
//  EntityLogServiceTests.swift
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

class EntityLogServiceTests: XCTestCase {
   
    
    // MARK: -  🦮 Helpers - File access SUT
    static let entityLogServiceArray = ClarityActivator.entityLogServiceArray

    static fileprivate func entityLogServiceForEntityCode(_ entityCode: String) -> EntityLogService? {
        for entityLogService in EntityLogServiceTests.entityLogServiceArray{
            if entityLogService.kA == entityCode {
                return entityLogService
            }
        }
        return nil
    }
    
    let fileSut = EntityLogServiceTests.entityLogServiceForEntityCode("ABCE")
    
    // File access SUT:
    // IMPORTANT! These are 'in the field' file access tests
    // The tests will fail if the EntityLogService JSON files in framework ClarityJSON folder changes details
    // Therefore some tests use a mock while some tests check the JSONAccess system delivers the real EntityLogService files values
    // Unlike Settings there is not a need for both but mock tests included for the convenience of changes in future versions
    
    // MARK: - 🧪 Tests -  File access SUT: all entity codes return correct value assignments

    //Json access test
    func test_JSONAccessEntityLogServiceArrayNotNil() throws {
        XCTAssertNotNil(EntityLogServiceTests.entityLogServiceArray)
    }
    
    func test_ELSArrayFirstItemkB21AkC_ReturnsIntValue15() {
        XCTAssertEqual(EntityLogServiceTests.entityLogServiceForEntityCode("ABCD")?.kB21A[0].kC , 15)
    }
    func test_ELSArraySecondItemkB21AkC_ReturnsIntValue21() {
        XCTAssertEqual(EntityLogServiceTests.entityLogServiceForEntityCode("ABCE")?.kB21A[0].kC , 21)
    }
    func test_ELSArraySecondItemkB21Ak_ReturnsIntValue21() {
        XCTAssertEqual(EntityLogServiceTests.entityLogServiceForEntityCode("BBCC")?.kB21A[0].kC , 1)
    }
    func test_ELSArraySecondImkB21Ak_ReturnsIntValue21() {
        XCTAssertEqual(EntityLogServiceTests.entityLogServiceForEntityCode("ZZYY")?.kB21A[0].kC , 121)
    }
    
    // MARK: - 🧪 Tests -  File access SUT: "ABCE" entity code returns correct value for all assignments
    func test_FileABCEEntityLogServiceEntityCodeReturnsABCE() {
        XCTAssertEqual(fileSut?.kA  , "ABCE")
    }
    
    
    func test_FileABCEEntityLogServiceEntityFunctionsArraykB21AParametersReturnCorrectly() {
        // NOTE: Clarity code never accesses kB21A by index directly – only by iteration in the EntityLog service mapper initialiser
        //Therefore the out of range crash that could happen here would never occur in actuality
        XCTAssertEqual(fileSut?.kB21A[0].kC  , 21) //Function number
        XCTAssertEqual(fileSut?.kB21A[1].kC  , 25)
        
        XCTAssertEqual(fileSut?.kB21A[0].kJ  , .initialiser) //Function Type
        XCTAssertEqual(fileSut?.kB21A[1].kJ  , .initialiser)
        
        XCTAssertEqual(fileSut?.kB21A[0].kI  , false) //Function number always custom
        XCTAssertEqual(fileSut?.kB21A[1].kI  , false)
        
        XCTAssertNotNil(fileSut?.kB21A[0].kD31A) //Function decisions
        XCTAssertNotNil(fileSut?.kB21A[1].kD31A)
    }
    
    func test_FunctionTypeEnum_RawValuesReturnCorrectly() {

        var functionType = FunctionType.initialiser
        XCTAssertEqual(functionType.rawValue  , "i")
        functionType = FunctionType.customFunc
        XCTAssertEqual(functionType.rawValue  , "f")
        functionType = FunctionType.systemOverride
        XCTAssertEqual(functionType.rawValue  , "o")
        functionType = FunctionType.actionMethod
        XCTAssertEqual(functionType.rawValue  , "a")
        functionType = FunctionType.delegateMethod
        XCTAssertEqual(functionType.rawValue  , "g")
        functionType = FunctionType.datasourceMethod
        XCTAssertEqual(functionType.rawValue  , "d")
        functionType = FunctionType.computedVar
        XCTAssertEqual(functionType.rawValue  , "v")
        functionType = FunctionType.protocolExtensionMethod
        XCTAssertEqual(functionType.rawValue  , "e")
    }
    
    func test_EntityLogServiceCodingKeysEnum_RawValuesReturnCorrectly() {

        var codingKeyCase = EntityLogService.CodingKeys.kA
        XCTAssertEqual(codingKeyCase.rawValue  , "entity_code")
        codingKeyCase  =  EntityLogService.CodingKeys.kB21A
        XCTAssertEqual(codingKeyCase.rawValue  , "entity_functions")
    }
    
    
    func test_KB21CodingKeysEnum_RawValuesReturnCorrectly() {

        var codingKeyCase = EntityLogService.KB21.CodingKeys.kC
        XCTAssertEqual(codingKeyCase.rawValue  , "function_number")
        codingKeyCase  = EntityLogService.KB21.CodingKeys.kI
        XCTAssertEqual(codingKeyCase.rawValue  , "function_number_always_custom")
        codingKeyCase  = EntityLogService.KB21.CodingKeys.kJ
        XCTAssertEqual(codingKeyCase.rawValue  , "function_type")
        codingKeyCase  = EntityLogService.KB21.CodingKeys.kD31A
        XCTAssertEqual(codingKeyCase.rawValue  , "function_nodes")
    }
    
    func test_KB21_KD31CodingKeysEnum_RawValuesReturnCorrectly() {

        var codingKeyCase = EntityLogService.KB21.KD31.CodingKeys.kE
        XCTAssertEqual(codingKeyCase.rawValue  , "print_number")
        codingKeyCase = EntityLogService.KB21.KD31.CodingKeys.kF
        XCTAssertEqual(codingKeyCase.rawValue  , "node_type")
        codingKeyCase  = EntityLogService.KB21.KD31.CodingKeys.kG
        XCTAssertEqual(codingKeyCase.rawValue  , "event_description")
        codingKeyCase  = EntityLogService.KB21.KD31.CodingKeys.kH
        XCTAssertEqual(codingKeyCase.rawValue  , "effect_description")
    }
    
    
    func test_FileABCEEntityLogServiceEntityFunctionskB21AFunctionDecisionsArraykD31AParametersReturnCorrectly() {
        XCTAssertEqual(fileSut?.kB21A[0].kD31A[0].kE,95) //Print number
        XCTAssertEqual(fileSut?.kB21A[0].kD31A[1].kE,97)
        
        XCTAssertEqual(fileSut?.kB21A[0].kD31A[0].kF,.elseCondition) //NodeType
        XCTAssertEqual(fileSut?.kB21A[0].kD31A[1].kF,.functionName)
       
        XCTAssertEqual(fileSut?.kB21A[0].kD31A[0].kG,"Decision event description") //Decision event
        XCTAssertEqual(fileSut?.kB21A[0].kD31A[1].kG,"Decision event description")
        
        XCTAssertEqual(fileSut?.kB21A[0].kD31A[0].kH,"Consequence description") //Decision Consequence
        XCTAssertEqual(fileSut?.kB21A[0].kD31A[1].kH,"Consequence description")
    }

    
    
    // MARK: - 🦮 Helpers - Fake data SUT
    static let mockFunctionDecisions1 = EntityLogService.KB21.KD31(kE: 0, kF: .caseTrueNegativeOutcome, kG: "Decision event description", kH: "Do something")
    static let mockFunctionDecisions2 = EntityLogService.KB21.KD31(kE: 1, kF: .caseTruePositiveOutcome, kG: "2nd Decision event description", kH: "2nd Do something")
    
    static let mockFunctionDecisions3 = EntityLogService.KB21.KD31(kE: 2, kF: .functionName, kG: "3rd Decision event description", kH: "3rd Do something")
    static let mockFunctionDecisions4 = EntityLogService.KB21.KD31(kE: 3, kF: .elseCondition, kG: "4th Decision event description", kH: "4th Do something")
    
    static let mockFunctionDecisionsArray1 = [mockFunctionDecisions1,mockFunctionDecisions2]
    static let mockFunctionDecisionsArray2 = [mockFunctionDecisions3,mockFunctionDecisions4]
    
    static let mockEntityFunctions1KB210 = EntityLogService.KB21(kC: 1, kI: false, kJ: .customFunc, kD31A:mockFunctionDecisionsArray1)
    static let mockEntityFunctions2KB211 = EntityLogService.KB21(kC: 32, kI: true, kJ: .initialiser, kD31A:mockFunctionDecisionsArray2)
    
    static let mockEntityFunctionsArray = [mockEntityFunctions1KB210,mockEntityFunctions2KB211]
    
    let mockEntityLogService = EntityLogService(kA: "WGIS", kB21A: mockEntityFunctionsArray)
    
    // MARK: - 🧪 Tests - Fake data SUT: Correct data assignment
    func test_MockEntityLogServiceEntityCodeReturnsWGIS() {
        XCTAssertEqual(mockEntityLogService.kA  , "WGIS")
    }
    
    func test_MockEntityLogServiceEntityFunctionsArrayNotNil() {
        XCTAssertNotNil(mockEntityLogService.kB21A)
    }
    
    func test_MockEntityLogServiceEntityFunctionsArrayParametersReturnCorrectly() {
        XCTAssertEqual(mockEntityLogService.kB21A[0].kC  , 1) //Function number
        XCTAssertEqual(mockEntityLogService.kB21A[1].kC  , 32)
        
        XCTAssertEqual(mockEntityLogService.kB21A[0].kJ  , .customFunc) //Function Type
        XCTAssertEqual(mockEntityLogService.kB21A[1].kJ  , .initialiser)
        
        XCTAssertEqual(mockEntityLogService.kB21A[0].kI  , false) //Function number always custom
        XCTAssertEqual(mockEntityLogService.kB21A[1].kI  , true)
        
        XCTAssertNotNil(mockEntityLogService.kB21A[0].kD31A) //Function decisions
        XCTAssertNotNil(mockEntityLogService.kB21A[1].kD31A)
    }
    
    func test_MockEntityLogServiceEntityFunctionsFunctionDecisionsArrayParametersReturnCorrectly() {
        XCTAssertEqual(mockEntityLogService.kB21A[0].kD31A[0].kE,0) //Print number
        XCTAssertEqual(mockEntityLogService.kB21A[0].kD31A[1].kE,1)
        
        XCTAssertEqual(mockEntityLogService.kB21A[0].kD31A[0].kF,.caseTrueNegativeOutcome) //NodeType
        XCTAssertEqual(mockEntityLogService.kB21A[0].kD31A[1].kF,.caseTruePositiveOutcome)
       
        XCTAssertEqual(mockEntityLogService.kB21A[0].kD31A[0].kG,"Decision event description") //Decision event
        XCTAssertEqual(mockEntityLogService.kB21A[0].kD31A[1].kG,"2nd Decision event description")
        
        XCTAssertEqual(mockEntityLogService.kB21A[0].kD31A[0].kH,"Do something") //Decision Consequence
        XCTAssertEqual(mockEntityLogService.kB21A[0].kD31A[1].kH,"2nd Do something")
    }

}

