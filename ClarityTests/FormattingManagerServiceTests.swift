//
//  FormattingManagerServiceTests.swift
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

class FormattingManagerServiceTests: XCTestCase {

    
    // MARK:   🦮 Helpers  File access SUT
    let fileSut = ClarityActivator.formatting
    
    func test_FormattingManagerServiceCodingKeysEnum_RawValuesReturnCorrectly() {

        var codingKeyCase = FormattingManagerService.CodingKeys.kAOb
        XCTAssertEqual(codingKeyCase.rawValue  , "outcome_symbols")
        codingKeyCase = FormattingManagerService.CodingKeys.kBOb
        XCTAssertEqual(codingKeyCase.rawValue  , "controlflow_node_type_symbols")
        codingKeyCase  = FormattingManagerService.CodingKeys.kCOb
        XCTAssertEqual(codingKeyCase.rawValue  , "function_type_symbols")
        codingKeyCase  = FormattingManagerService.CodingKeys.kDOb
        XCTAssertEqual(codingKeyCase.rawValue  , "spacers")
    }
    
    
    func test_OutcomeSymbolsCodingKeysEnum_RawValuesReturnCorrectly() {

        var codingKeyCase = FormattingManagerService.OutcomeSymbols.CodingKeys.kA
        XCTAssertEqual(codingKeyCase.rawValue  , "if_true_condition")
        codingKeyCase = FormattingManagerService.OutcomeSymbols.CodingKeys.kB
        XCTAssertEqual(codingKeyCase.rawValue  , "else_condition")
        codingKeyCase  = FormattingManagerService.OutcomeSymbols.CodingKeys.kC
        XCTAssertEqual(codingKeyCase.rawValue  , "if_true_condition_negative_outcome")
        codingKeyCase  = FormattingManagerService.OutcomeSymbols.CodingKeys.kD
        XCTAssertEqual(codingKeyCase.rawValue  , "else_condition_positive_outcome")
        codingKeyCase = FormattingManagerService.OutcomeSymbols.CodingKeys.kE
        XCTAssertEqual(codingKeyCase.rawValue  , "case_true_positive_outcome")
        codingKeyCase = FormattingManagerService.OutcomeSymbols.CodingKeys.kF
        XCTAssertEqual(codingKeyCase.rawValue  , "case_true_negative_outcome")
        codingKeyCase  = FormattingManagerService.OutcomeSymbols.CodingKeys.kG
        XCTAssertEqual(codingKeyCase.rawValue  , "guard_pass")
        codingKeyCase  = FormattingManagerService.OutcomeSymbols.CodingKeys.kH
        XCTAssertEqual(codingKeyCase.rawValue  , "guard_fail")
        codingKeyCase = FormattingManagerService.OutcomeSymbols.CodingKeys.kI
        XCTAssertEqual(codingKeyCase.rawValue  , "do_try_pass")
        codingKeyCase = FormattingManagerService.OutcomeSymbols.CodingKeys.kJ
        XCTAssertEqual(codingKeyCase.rawValue  , "catch_try_fail")
        codingKeyCase  = FormattingManagerService.OutcomeSymbols.CodingKeys.kK
        XCTAssertEqual(codingKeyCase.rawValue  , "value_reporter")
        codingKeyCase  = FormattingManagerService.OutcomeSymbols.CodingKeys.kL
        XCTAssertEqual(codingKeyCase.rawValue  , "error_reporter")
    }
    
    func test_ControlFlowNodeSymbolsCodingKeysEnum_RawValuesReturnCorrectly() {

        var codingKeyCase = FormattingManagerService.ControlFlowNodeSymbols.CodingKeys.kA
        XCTAssertEqual(codingKeyCase.rawValue  , "if_else_conditional")
        codingKeyCase = FormattingManagerService.ControlFlowNodeSymbols.CodingKeys.kB
        XCTAssertEqual(codingKeyCase.rawValue  , "switch_case")
        codingKeyCase  = FormattingManagerService.ControlFlowNodeSymbols.CodingKeys.kC
        XCTAssertEqual(codingKeyCase.rawValue  , "guard")
        codingKeyCase  = FormattingManagerService.ControlFlowNodeSymbols.CodingKeys.kD
        XCTAssertEqual(codingKeyCase.rawValue  , "do_catch_try")
        codingKeyCase = FormattingManagerService.ControlFlowNodeSymbols.CodingKeys.kE
        XCTAssertEqual(codingKeyCase.rawValue  , "value_reporter")
        codingKeyCase = FormattingManagerService.ControlFlowNodeSymbols.CodingKeys.kF
        XCTAssertEqual(codingKeyCase.rawValue  , "error_reporter")
    }
    func test_FunctionTypeSymbolsCodingKeysEnum_RawValuesReturnCorrectly() {

        var codingKeyCase = FormattingManagerService.FunctionTypeSymbols.CodingKeys.kA
        XCTAssertEqual(codingKeyCase.rawValue  , "initialiser")
        codingKeyCase = FormattingManagerService.FunctionTypeSymbols.CodingKeys.kB
        XCTAssertEqual(codingKeyCase.rawValue  , "custom_function")
        codingKeyCase  = FormattingManagerService.FunctionTypeSymbols.CodingKeys.kC
        XCTAssertEqual(codingKeyCase.rawValue  , "system_method_override")
        codingKeyCase  = FormattingManagerService.FunctionTypeSymbols.CodingKeys.kD
        XCTAssertEqual(codingKeyCase.rawValue  , "action_method")
        codingKeyCase = FormattingManagerService.FunctionTypeSymbols.CodingKeys.kE
        XCTAssertEqual(codingKeyCase.rawValue  , "delegate_method")
        codingKeyCase = FormattingManagerService.FunctionTypeSymbols.CodingKeys.kF
        XCTAssertEqual(codingKeyCase.rawValue  , "datasource_method")
        codingKeyCase = FormattingManagerService.FunctionTypeSymbols.CodingKeys.kG
        XCTAssertEqual(codingKeyCase.rawValue  , "computed_variable")
        codingKeyCase = FormattingManagerService.FunctionTypeSymbols.CodingKeys.kH
        XCTAssertEqual(codingKeyCase.rawValue  , "protocol_extension_method")
    }
    func test_SpacersCodingKeysEnum_RawValuesReturnCorrectly() {

        var codingKeyCase = FormattingManagerService.Spacers.CodingKeys.kA
        XCTAssertEqual(codingKeyCase.rawValue  , "spacer1")
        codingKeyCase = FormattingManagerService.Spacers.CodingKeys.kB
        XCTAssertEqual(codingKeyCase.rawValue  , "spacer2")
        codingKeyCase  = FormattingManagerService.Spacers.CodingKeys.kC
        XCTAssertEqual(codingKeyCase.rawValue  , "spacer3")
        codingKeyCase  = FormattingManagerService.Spacers.CodingKeys.kD
        XCTAssertEqual(codingKeyCase.rawValue  , "spacer4")
    }
    
    
    
    


    // MARK:  🧪 Tests   File access SUT: Correct formatting returned
    //NB! These are file access tests
    // Will fail if JSON files in framework ClarityJSON folder change details
    func test_FileOutcomeSymbolsReturnCorrectStrings() {
        XCTAssertEqual(fileSut?.kAOb.kA , "✅")
        XCTAssertEqual(fileSut?.kAOb.kB , "🔴")
        XCTAssertEqual(fileSut?.kAOb.kC , "⚠️")
        XCTAssertEqual(fileSut?.kAOb.kD , "✅")
        XCTAssertEqual(fileSut?.kAOb.kE , "✅")
        XCTAssertEqual(fileSut?.kAOb.kF , "⚠️")
        XCTAssertEqual(fileSut?.kAOb.kG , "☑️")
        XCTAssertEqual(fileSut?.kAOb.kH , "⚔️")
        XCTAssertEqual(fileSut?.kAOb.kI , "✅")
        XCTAssertEqual(fileSut?.kAOb.kJ , "🎣")
        XCTAssertEqual(fileSut?.kAOb.kK , "📋")
        XCTAssertEqual(fileSut?.kAOb.kL , "☎️")
    }
    
    func test_FileControlFlowNodeSymbolsReturnCorrectStrings() {
        XCTAssertEqual(fileSut?.kBOb.kA , "N")
        XCTAssertEqual(fileSut?.kBOb.kB , "C")
        XCTAssertEqual(fileSut?.kBOb.kC , "G")
        XCTAssertEqual(fileSut?.kBOb.kD , "T")
        XCTAssertEqual(fileSut?.kBOb.kE , "R")
        XCTAssertEqual(fileSut?.kBOb.kF , "E")
    }
    
    
    func test_FileFunctionTypeSymbolsArrayReturnCorrectStrings() {
        XCTAssertEqual(fileSut?.kCOb.kA , "♻️")
        XCTAssertEqual(fileSut?.kCOb.kB , "🍎")
        XCTAssertEqual(fileSut?.kCOb.kC , "🍏")
        XCTAssertEqual(fileSut?.kCOb.kD , "🎯")
        XCTAssertEqual(fileSut?.kCOb.kE , "🔮")
        XCTAssertEqual(fileSut?.kCOb.kF , "📀")
        XCTAssertEqual(fileSut?.kCOb.kG , "💻")
        XCTAssertEqual(fileSut?.kCOb.kH , "🧩")
    }
    
    func test_FileSpacersArrayReturnCorrectStrings() {
        XCTAssertEqual(fileSut?.kDOb.kA , 0)
        XCTAssertEqual(fileSut?.kDOb.kB , 0)
        XCTAssertEqual(fileSut?.kDOb.kC , 0)
        XCTAssertEqual(fileSut?.kDOb.kD , 0)
    }
    
    
    // MARK:  🦮 Helpers  Fake data SUT
    static let outcomeSymbolsArray = FormattingManagerService.OutcomeSymbols(kA: "✅", kB: "🔴", kC: "⚠️", kD: "✅", kE: "✅", kF: "⚠️", kG: "☑️", kH: "⚔️", kI: "✅", kJ: "🎣", kK: "📋", kL: "☎️")
    
    static let controlFlowNodeSymbolsArray = FormattingManagerService.ControlFlowNodeSymbols(kA: "N", kB: "C", kC: "G", kD: "T",  kE: "R", kF: "E")

    static let functionTypeSymbolsArray = FormattingManagerService.FunctionTypeSymbols(kA: "♻️i", kB: "🍎f", kC: "🍏o", kD: "🎯a", kE: "🔮g", kF: "📀d", kG: "💻v", kH: "🧩e")

    static let spacersArray = FormattingManagerService.Spacers(kA: 0, kB: 0, kC: 0, kD: 0)

    
    let mockSut = FormattingManagerService(kAOb: outcomeSymbolsArray, kBOb: controlFlowNodeSymbolsArray, kCOb: functionTypeSymbolsArray, kDOb: spacersArray)
    
    // MARK:  🧪 Tests  Fake data SUT:  Correct formatting returned
    //Duplication but will delineate between errors in FormattingManagerService and errors in the JSON access system
    func test_MockOutcomeSymbolsReturnCorrectStrings() {
        XCTAssertEqual(mockSut.kAOb.kA , "✅")
        XCTAssertEqual(mockSut.kAOb.kB , "🔴")
        XCTAssertEqual(mockSut.kAOb.kC , "⚠️")
        XCTAssertEqual(mockSut.kAOb.kD , "✅")
        XCTAssertEqual(mockSut.kAOb.kE , "✅")
        XCTAssertEqual(mockSut.kAOb.kF , "⚠️")
        XCTAssertEqual(mockSut.kAOb.kG , "☑️")
        XCTAssertEqual(mockSut.kAOb.kH , "⚔️")
        XCTAssertEqual(mockSut.kAOb.kI , "✅")
        XCTAssertEqual(mockSut.kAOb.kJ , "🎣")
        XCTAssertEqual(mockSut.kAOb.kK , "📋")
        XCTAssertEqual(mockSut.kAOb.kL , "☎️")
    }
    
    
    
    
    func test_MockControlFlowNodeSymbolsReturnCorrectStrings() {
        XCTAssertEqual(mockSut.kBOb.kA , "N")
        XCTAssertEqual(mockSut.kBOb.kB , "C")
        XCTAssertEqual(mockSut.kBOb.kC , "G")
        XCTAssertEqual(mockSut.kBOb.kD , "T")
        XCTAssertEqual(mockSut.kBOb.kE , "R")
        XCTAssertEqual(mockSut.kBOb.kF , "E")
    }
    
    func test_MockFunctionTypeSymbolsArrayReturnCorrectStrings() {
        XCTAssertEqual(mockSut.kCOb.kA , "♻️i")
        XCTAssertEqual(mockSut.kCOb.kB , "🍎f")
        XCTAssertEqual(mockSut.kCOb.kC , "🍏o")
        XCTAssertEqual(mockSut.kCOb.kD , "🎯a")
        XCTAssertEqual(mockSut.kCOb.kE , "🔮g")
        XCTAssertEqual(mockSut.kCOb.kF , "📀d")
        XCTAssertEqual(mockSut.kCOb.kG , "💻v")
        XCTAssertEqual(mockSut.kCOb.kH , "🧩e")
    }
    
    func test_MockSpacersArrayReturnCorrectStrings() {
        XCTAssertEqual(mockSut.kDOb.kA , 0)
        XCTAssertEqual(mockSut.kDOb.kB , 0)
        XCTAssertEqual(mockSut.kDOb.kC , 0)
        XCTAssertEqual(mockSut.kDOb.kD , 0)
    }
    
    
}
