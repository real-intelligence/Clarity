//
//  PrintConstantsTests.swift
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

class PrintConstantsTests: XCTestCase {

    func test_PrintConstantsEnum_PropertyValuesReturnCorrectly() {

        var stringConstant = pC.singleSpace
        XCTAssertEqual(stringConstant, "\u{0020}")
        stringConstant = pC.emptyString
        XCTAssertEqual(stringConstant, String())
        stringConstant = pC.failNodeSymbol
        XCTAssertEqual(stringConstant, "!")
        stringConstant = pC.effectLabel
        XCTAssertEqual(stringConstant, "Effect:")
        stringConstant = pC.valueReporterLabel
        XCTAssertEqual(stringConstant, "Value for variable ")
        stringConstant = pC.valuesReporterLabel
        XCTAssertEqual(stringConstant, "Values for variables ")
        stringConstant = pC.errorReporterLabel
        XCTAssertEqual(stringConstant, "Error for ")
        stringConstant = pC.isLabel
        XCTAssertEqual(stringConstant, " is:")
        stringConstant = pC.areLabel
        XCTAssertEqual(stringConstant, " are:")
        stringConstant = pC.linker_EventDescription
        XCTAssertEqual(stringConstant, "  - ")
        stringConstant = pC.linker_NodeNumber
        XCTAssertEqual(stringConstant, "-")
        
        stringConstant = pC.spacer_G1
        XCTAssertEqual(stringConstant, String(repeating:  pC.singleSpace, count: 3))
        stringConstant = pC.spacer_FailNodeSymbol
        XCTAssertEqual(stringConstant, String(repeating:  pC.singleSpace, count: pC.failNodeSymbol.count))
        stringConstant = pC.spacer_PostAbsoluteNodeNumber
        XCTAssertEqual(stringConstant, String(repeating: pC.singleSpace, count: 2))
        
        stringConstant = pC.spacer_F1
        XCTAssertEqual(stringConstant, String(repeating: pC.singleSpace, count: 1))
        stringConstant = pC.spacer_F2
        XCTAssertEqual(stringConstant, String(repeating: pC.singleSpace, count: 4))
        stringConstant = pC.spacer_FType
        XCTAssertEqual(stringConstant, String(repeating: pC.singleSpace, count: 1))
        
        var indexSetConstant = pC.customSpacerIndexes
        XCTAssertEqual(indexSetConstant, [pC.index_C1,
                                          pC.index_C2,
                                          pC.index_C3,
                                          pC.index_C4])
        indexSetConstant = pC.defaultMessageIndexes
        XCTAssertEqual(indexSetConstant, [pC.index_EntityCode,
                                          pC.index_EntityCodeDifferential,
                                          pC.index_RJustifyAdjusterFromFunctionElements,
                                          pC.index_UsedFunctionNumber,
                                          pC.index_G1,
                                          pC.index_FailNodeSymbol,
                                          pC.index_ControlFlowNodeTypeSymbol,
                                          pC.index_Linker_NodeNumber,
                                          pC.index_UsedNodeNumber,
                                          pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces,
                                          pC.index_OutcomeSymbol,
                                          pC.index_Linker_EventDescription,
                                          pC.index_EventDescription])
        indexSetConstant = pC.absoluteNodeIndexes
        XCTAssertEqual(indexSetConstant, [pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces,
                                          pC.index_AbsoluteNodeNumber,
                                          pC.index_PostAbsoluteNodeNumber])
        indexSetConstant = pC.valueReportIndexes
        XCTAssertEqual(indexSetConstant, [pC.index_ReporterValuesLabel,
                                          pC.index_ReporterAuxiliaryLabel])
        indexSetConstant = pC.reporterIndexes
        XCTAssertEqual(indexSetConstant, [pC.index_EntityCode,
                                          pC.index_EntityCodeDifferential,
                                          pC.index_RJustifyAdjusterFromFunctionElements,
                                          pC.index_UsedFunctionNumber,
                                          pC.index_G1,
                                          pC.index_FailNodeSymbolSpacer,
                                          pC.index_ControlFlowNodeTypeSymbol,
                                          pC.index_Linker_NodeNumber,
                                          pC.index_UsedNodeNumber,
                                          pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces,
                                          pC.index_OutcomeSymbol,
                                          pC.index_Linker_EventDescription,
                                          pC.index_EventDescription])
        indexSetConstant = pC.functionNameIndexes
        XCTAssertEqual(indexSetConstant, [pC.index_EntityCode,
                                          pC.index_EntityCodeDifferential,
                                          pC.index_F1,
                                          pC.index_FunctionTypeSymbol,
                                          pC.index_FunctionTypeString,
                                          pC.index_AdjustmentForFunctionNumberPlaces,
                                          pC.index_UsedFunctionNumber,
                                          pC.index_F2,
                                          pC.index_FunctionName])
        indexSetConstant = pC.effectIndexes
        XCTAssertEqual(indexSetConstant, [pC.index_EffectLabel,
                                          pC.index_EffectDescription])
        indexSetConstant = pC.nodeOnlyIndexes
        XCTAssertEqual(indexSetConstant, [pC.index_EntityCode,
                                          pC.index_EntityCodeDifferential,
                                          pC.index_RJustifyAdjusterFromFunctionElements,
                                          pC.index_UsedFunctionNumber,
                                          pC.index_G1,
                                          pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces,
                                          pC.index_AbsoluteNodeNumber])
        indexSetConstant = pC.defaultReadoutSpacers
        XCTAssertEqual(indexSetConstant, [pC.index_EntityCodeDifferential,
                                          pC.index_RJustifyAdjusterFromFunctionElements,
                                          pC.index_G1,
                                          pC.index_FailNodeSymbol])
        indexSetConstant = pC.defaultReadoutComponents
        XCTAssertEqual(indexSetConstant, [pC.index_EntityCode,
                                          pC.index_UsedFunctionNumber,
                                          pC.index_Linker_NodeNumber,
                                          pC.index_UsedNodeNumber,
                                          pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces,
                                          pC.index_Linker_EventDescription])
        indexSetConstant = pC.userSettableSymbolReadoutComponents
        XCTAssertEqual(indexSetConstant, [pC.index_ControlFlowNodeTypeSymbol,
                                          pC.index_OutcomeSymbol])
        
        
        var indexConstant = pC.index_C1
        XCTAssertEqual(indexConstant, 0)
        indexConstant = pC.index_EntityCode
        XCTAssertEqual(indexConstant, 1)
        indexConstant = pC.index_EntityCodeDifferential
        XCTAssertEqual(indexConstant, 2)
        indexConstant = pC.index_RJustifyAdjusterFromFunctionElements
        XCTAssertEqual(indexConstant, 3)
        indexConstant = pC.index_F1
        XCTAssertEqual(indexConstant, 4)
        indexConstant = pC.index_FunctionTypeSymbol
        XCTAssertEqual(indexConstant, 5)
        indexConstant = pC.index_FunctionTypeString
        XCTAssertEqual(indexConstant, 6)
        indexConstant = pC.index_AdjustmentForFunctionNumberPlaces
        XCTAssertEqual(indexConstant, 7)
        indexConstant = pC.index_C2
        XCTAssertEqual(indexConstant, 8)
        indexConstant = pC.index_UsedFunctionNumber
        XCTAssertEqual(indexConstant, 9)
        indexConstant = pC.index_G1
        XCTAssertEqual(indexConstant, 10)
        indexConstant = pC.index_F2
        XCTAssertEqual(indexConstant, 11)
        indexConstant = pC.index_C3
        XCTAssertEqual(indexConstant, 12)
        indexConstant = pC.index_FailNodeSymbol
        XCTAssertEqual(indexConstant, 13)
        indexConstant = pC.index_FailNodeSymbolSpacer
        XCTAssertEqual(indexConstant, 14)
        indexConstant = pC.index_ControlFlowNodeTypeSymbol
        XCTAssertEqual(indexConstant, 15)
        indexConstant = pC.index_Linker_NodeNumber
        XCTAssertEqual(indexConstant, 16)
        indexConstant = pC.index_FunctionName
        XCTAssertEqual(indexConstant, 17)
        indexConstant = pC.index_UsedNodeNumber
        XCTAssertEqual(indexConstant, 18)
        indexConstant = pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces
        XCTAssertEqual(indexConstant, 19)
        indexConstant = pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces
        XCTAssertEqual(indexConstant, 20)
        indexConstant = pC.index_AbsoluteNodeNumber
        XCTAssertEqual(indexConstant, 21)
        indexConstant = pC.index_PostAbsoluteNodeNumber
        XCTAssertEqual(indexConstant, 22)
        indexConstant = pC.index_C4
        XCTAssertEqual(indexConstant, 23)
        indexConstant = pC.index_OutcomeSymbol
        XCTAssertEqual(indexConstant, 24)
        indexConstant = pC.index_Linker_EventDescription
        XCTAssertEqual(indexConstant, 25)
        indexConstant = pC.index_ReporterValuesLabel
        XCTAssertEqual(indexConstant, 26)
        indexConstant = pC.index_EventDescription
        XCTAssertEqual(indexConstant, 27)
        indexConstant = pC.index_ReporterAuxiliaryLabel
        XCTAssertEqual(indexConstant, 28)
        indexConstant = pC.index_EffectLabel
        XCTAssertEqual(indexConstant, 29)
        indexConstant = pC.index_EffectDescription
        XCTAssertEqual(indexConstant, 30)
        
    }
    
    
    
    
    
    

}
