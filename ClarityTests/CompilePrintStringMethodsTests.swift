//
//  CompilePrintStringMethodsTests.swift
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

class CompilePrintStringMethodsTests: XCTestCase {
    // MARK: - 🦮 Helpers - Fake settings data for File access SUT


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
    // MARK: - 🦮 Helpers - Mock ClarityPrintLogic
    struct MockPrinter: ClarityPrintHelper{
    }
    let printer = MockPrinter()
    let printMessages = MessageCollator.sharedMessages
    
    
    // Default to ifTrueCondition with all settings neutral (false)
    var expectedComposite: [String]  {
        var composite = [String](repeating: "", count: 31)
        composite[pC.index_C1] = pC.emptyString
        composite[pC.index_EntityCode] = "ABCD"
        composite[pC.index_EntityCodeDifferential] = pC.emptyString
        composite[pC.index_RJustifyAdjusterFromFunctionElements] = String(repeating: pC.singleSpace, count: 8)
        composite[pC.index_F1] = pC.singleSpace
        composite[pC.index_FunctionTypeSymbol] = "🍎"
        composite[pC.index_FunctionTypeString] = "f"
        composite[pC.index_AdjustmentForFunctionNumberPlaces] = String(repeating: pC.singleSpace, count: 4)
        composite[pC.index_C2] = pC.emptyString
        composite[pC.index_UsedFunctionNumber] = "15"
        composite[pC.index_G1] = String(repeating: pC.singleSpace, count: 3)
        composite[pC.index_F2] = String(repeating: pC.singleSpace, count: 4)
        composite[pC.index_C3] = pC.emptyString
        composite[pC.index_FailNodeSymbol] = pC.singleSpace
        composite[pC.index_FailNodeSymbolSpacer] = pC.singleSpace
        composite[pC.index_ControlFlowNodeTypeSymbol] = "N"
        composite[pC.index_Linker_NodeNumber] = "-"
        composite[pC.index_FunctionName] = pC.emptyString
        composite[pC.index_UsedNodeNumber] = "2"
        composite[pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces] =  String(repeating: pC.singleSpace, count: 5)
        composite[pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 5)
        composite[pC.index_AbsoluteNodeNumber] = "2"
        composite[pC.index_PostAbsoluteNodeNumber] = String(repeating: pC.singleSpace, count: 2)
        composite[pC.index_C4] = pC.emptyString
        composite[pC.index_OutcomeSymbol] = "✅"
        composite[pC.index_Linker_EventDescription] = "  - "
        composite[pC.index_ReporterValuesLabel] = "Value for variable "
        composite[pC.index_EventDescription] = "Decision event description"
        composite[pC.index_ReporterAuxiliaryLabel] = " is:"
        composite[pC.index_EffectLabel] = "Effect:"
        composite[pC.index_EffectDescription] = "Do something"
        
        return composite
    }
    
    
    // MARK: - 🧪 Tests -  compileSequentialComposite
    //Fine grain tests of string compilation – for testing for the correct positioning of elements
    //The setup for these tests is necessarily involved and laborious - use the simpler factorised tests in ClarityPrintLogicTests to test for the correct content of elements
    func test_compileSequentialComposite_ForDecisionTrue__ReturnsCorrectStrings() {
        // Parameters:
        let printNumber = 2
        guard let messageToPrint = printMessages[printNumber] else { return  }
        
        guard let formatting = ClarityActivator.formatting else { return }
        let functionName = "" // if set it will change the value of some of the composite elements
        let values: Any? = nil // if set it will change the value of some of the composite elements
        
         
        let nodeType = printer.resolveNodeTypeGroup(messageToPrint, functionName, values)
        // 1. Test composite has correct values
        let composite =  printer.compileSequentialComposite(printNumber, messageToPrint, nodeType, SMST.fakeSettings, formatting, functionName, values)
        
        var expectedComposite = self.expectedComposite
        // Set bespoke values on expectedComposite indexes here
        //eg.
        expectedComposite[pC.index_EntityCode] = "ABCD"
        
        XCTAssertEqual(indexesWithUnequalValues(composite, expectedComposite), [])
        
        //2. Test returned message strings compiled from the composite
        var compiledStringForPrint = ""
        var compiledStringForEffectPrint = ""
        var printEffectString = false
        
        var printValueType: PrintValueType = .none
        let messageType = NodeType.ifTrueCondition
        printer.compileStringsFromComposite(composite, messageType, SMST.fakeSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
        
        let readoutSpacer = printer.readoutSpacer(fromComposite: composite, SMST.fakeSettings)
        XCTAssertEqual(compiledStringForPrint, "ABCD        15    N-2     ✅  - Decision event description")
        XCTAssertEqual(readoutSpacer + compiledStringForEffectPrint, "                                Effect:Do something")
        
    
        
        let compiledEventCount = compiledStringForPrint.count
        let compiledEffectCount = compiledStringForEffectPrint.count
        
        let expectedCompiledEventCount = 57
        let expectedCompiledEffectCount = 19
 
        XCTAssertEqual(expectedCompiledEventCount,compiledEventCount)
        XCTAssertEqual(expectedCompiledEffectCount,compiledEffectCount)
        
 
        //Symbol alignment differential
        let userSettableSymbolComponents: IndexSet = [pC.index_FailNodeSymbolSpacer,pC.index_OutcomeSymbol]
        let compositeForSymbols = userSettableSymbolComponents.filteredIndexSet { $0 < composite.count }.map { composite[$0] }
        let spacerCountForSymbols = compositeForSymbols.map{$0.symbolSpaceCount()}.reduce(0, +)
        let characterCountForSymbols = compositeForSymbols.map{$0.count}.reduce(0, +)
        let symbolDifferentialCount = spacerCountForSymbols - characterCountForSymbols
        
        //For discount of characters from the point of alignment (here "Decision event description")
        let comp27Count = composite[27].count
        //Calculate expected position on the event string (point of alignment) that the effect string should begin on the following line
        //NB! expectedCompiledEventCount count should always be the same for each message group type /settings (31 for non relative print number message strings
        // the adjusting spacers should balance where composite element counts change
        //However the expectedReadoutCount will ordinarily be more than readoutSpacer (to account for  user set symbols to ensure alignment)
        let expectedReadoutCount = (compiledEventCount - (comp27Count)) + symbolDifferentialCount
        //        Swift.print("expectedReadoutCount",expectedReadoutCount)
        //        Swift.print("readoutSpacer.count",readoutSpacer.count)
        
        XCTAssertEqual(expectedReadoutCount,readoutSpacer.count)
        //Visual alignment check
        Swift.print(compiledStringForPrint)
        Swift.print(readoutSpacer+compiledStringForEffectPrint)
        
    }
    
    func test_compileSequentialComposite_ForDecisionFalse_CalculatingRelativePrintNumber_ReturnsCorrectStrings() {
        // Parameters:
        let printNumber = 398
        guard let messageToPrint = printMessages[printNumber] else { return  }
        
        guard let formatting = ClarityActivator.formatting else { return }
        let functionName = "" // if set it will change the value of some of the composite elements
        let values: Any? = nil // if set it will change the value of some of the composite elements
        let nodeType = printer.resolveNodeTypeGroup(messageToPrint, functionName, values)
        // 1. Test composite has correct values
        var composite =  printer.compileSequentialComposite(printNumber, messageToPrint, nodeType, SMST.fakeSettings, formatting, functionName, values)
        
        var expectedComposite = self.expectedComposite
        // Set bespoke values on expectedComposite indexes here
        //eg.
        expectedComposite[pC.index_EntityCode] = "ABCE"
        expectedComposite[pC.index_UsedFunctionNumber] = "89"
        expectedComposite[pC.index_FailNodeSymbol] = "!"
        expectedComposite[pC.index_UsedNodeNumber] = "398"
        expectedComposite[pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 3)
        expectedComposite[pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 3)
        expectedComposite[pC.index_AbsoluteNodeNumber] = "398"
        expectedComposite[pC.index_OutcomeSymbol] = "🔴"
        expectedComposite[pC.index_EffectDescription] = "Consequence description"
        
        XCTAssertEqual(indexesWithUnequalValues(composite, expectedComposite), [])
        
        //2. Test returned message strings compiled from the composite
        var compiledStringForPrint = ""
        var compiledStringForEffectPrint = ""
        var printEffectString = false
        
        var printValueType: PrintValueType = .none
        let messageType = NodeType.elseCondition
        printer.compileStringsFromComposite(composite, messageType, SMST.fakeSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
        
        var readoutSpacer = printer.readoutSpacer(fromComposite: composite, SMST.fakeSettings)
        XCTAssertEqual(compiledStringForPrint, "ABCE        89   !N-398   🔴  - Decision event description")
        XCTAssertEqual(readoutSpacer + compiledStringForEffectPrint, "                                Effect:Consequence description")
        
        //Assertions of detailed breakdown of string counts (covered by above tests)
        let compiledEventCount = compiledStringForPrint.count
        let compiledEffectCount = compiledStringForEffectPrint.count
        
        let expectedCompiledEventCount = 57
        let expectedCompiledEffectCount = 30
       
        XCTAssertEqual(expectedCompiledEventCount,compiledEventCount)
        XCTAssertEqual(expectedCompiledEffectCount,compiledEffectCount)
         
        //Symbol alignment differential
        let userSettableSymbolComponents: IndexSet = [pC.index_FailNodeSymbolSpacer, pC.index_OutcomeSymbol]
        let compositeForSymbols = userSettableSymbolComponents.filteredIndexSet { $0 < composite.count }.map { composite[$0] }
        let spacerCountForSymbols = compositeForSymbols.map{$0.symbolSpaceCount()}.reduce(0, +)
        let characterCountForSymbols = compositeForSymbols.map{$0.count}.reduce(0, +)
        let symbolDifferentialCount = spacerCountForSymbols - characterCountForSymbols
        
        //For discount of characters from the point of alignment (here "Decision event description")
        let comp27Count = composite[27].count
        //Calculate expected position on the event string (point of alignment) that the effect string should begin on the following line
        //NB! expectedCompiledEventCount count should always be the same for each message group type /settings (31 for non relative print number message strings
        // the adjusting spacers should balance where composite element counts change
        //However the expectedReadoutCount will ordinarily be more than readoutSpacer (to account for  user set symbols to ensure alignment)
        let expectedReadoutCount = (compiledEventCount - (comp27Count)) + symbolDifferentialCount
        //        Swift.print("expectedReadoutCount",expectedReadoutCount)
        //        Swift.print("readoutSpacer.count",readoutSpacer.count)
        
        XCTAssertEqual(expectedReadoutCount,readoutSpacer.count)
        //Visual alignment check
        Swift.print(compiledStringForPrint)
        Swift.print(readoutSpacer+compiledStringForEffectPrint)
        
         
        //Relative numbering of both print number and function number
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        // Modify expected
        expectedComposite[pC.index_RJustifyAdjusterFromFunctionElements] = String(repeating: pC.singleSpace, count: 9)
        // spacer_RJustifyAdjusterFromFunctionElements
        // = (Adjuster: FN 4 = 1 place = 5 inverse spaces) + functionSymbolCompensationSpacer = 4 (apple=2 + f+space) = 9 spaces
        
        expectedComposite[pC.index_AdjustmentForFunctionNumberPlaces] = String(repeating: pC.singleSpace, count: 5)
        // = (Adjuster: FN 4 = 1 place = 5 inverse spaces) ( = 5 spaces)
        expectedComposite[pC.index_UsedFunctionNumber] = "4"
        expectedComposite[pC.index_UsedNodeNumber] = "1"
        expectedComposite[pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 5)
        // = (Adjuster: PN 1 = 1 place = 5 inverse spaces)
        // Recomposite array
        composite =  printer.compileSequentialComposite(printNumber, messageToPrint, nodeType, SMST.fakeSettings, formatting, functionName, values)
        // Check composite
        XCTAssertEqual(indexesWithUnequalValues(composite, expectedComposite), [])
        // Recompile strings
        printer.compileStringsFromComposite(composite, messageType, SMST.fakeSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
        // Recompile readoutspacer
        readoutSpacer = printer.readoutSpacer(fromComposite: composite, SMST.fakeSettings)
        // Check returned strings
        XCTAssertEqual(compiledStringForPrint, "ABCE         4   !N-1     🔴  - Decision event description")
        //Unchanged
        XCTAssertEqual(readoutSpacer + compiledStringForEffectPrint, "                                Effect:Consequence description")
        
        //Only repeat detailed count breakdown check if fail
        //Visual alignment check
        Swift.print(compiledStringForPrint)
        Swift.print(readoutSpacer+compiledStringForEffectPrint)
    }
    
    
    // Display relative print number setting applies to all groups of print message strings and they will align
    // However It would not align readouts with the non relative version (or there would be no room for the extra information)
    
    // but relative and non relative messages (or node only) will never appear simultaneously
    
    func test_compileSequentialComposite_ForDecisionFalse_WithRelativePrintNumberDisplay_ReturnsCorrectStrings() {
        let printNumber = 398
        guard let messageToPrint = printMessages[printNumber] else { return  }
        
        guard let formatting = ClarityActivator.formatting else { return }
        let functionName = "" // if set it will change the value of some of the composite elements
        let values: Any? = nil // if set it will change the value of some of the composite elements
        
        //Relative numbering of both print number and function number
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        
        //Display absolute node number
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
        // 1. Test composite has correct values
         
        
        var expectedComposite = self.expectedComposite
        // Set bespoke values on expectedComposite indexes here
        //eg.
 
        //All difference from the default plus adjustments for relative PN
        expectedComposite[pC.index_EntityCode] = "ABCE"
        expectedComposite[pC.index_RJustifyAdjusterFromFunctionElements] = String(repeating: pC.singleSpace, count: 9)
        // spacer_RJustifyAdjusterFromFunctionElements
        // = (Adjuster: FN 4 = 1 place = 5 inverse spaces) + functionSymbolCompensationSpacer = 4 (apple=2 + f+space) = 9 spaces
        expectedComposite[pC.index_AdjustmentForFunctionNumberPlaces] = String(repeating: pC.singleSpace, count: 5)
        // = (Adjuster: FN 4 = 1 place = 5 inverse spaces) ( = 5 spaces)
        expectedComposite[pC.index_UsedFunctionNumber] = "4"
        expectedComposite[pC.index_FailNodeSymbol] = "!"
        expectedComposite[pC.index_UsedNodeNumber] = "1"
        expectedComposite[pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 5)
        // = (Adjuster: PN 1 = 1 place = 5 inverse spaces)
        expectedComposite[pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 3)
        // spacer_LJustifyAdjusterFromAbsoluteNodeNumberPlaces
        // = (Adjuster: PN 398 = 3 place = 3 inverse spaces)
        expectedComposite[pC.index_AbsoluteNodeNumber] = "398"
        expectedComposite[pC.index_OutcomeSymbol] = "🔴"
        expectedComposite[pC.index_EffectDescription] = "Consequence description"
        let nodeType = printer.resolveNodeTypeGroup(messageToPrint, functionName, values)
        // Composite array
        let composite =  printer.compileSequentialComposite(printNumber, messageToPrint, nodeType, SMST.fakeSettings, formatting, functionName, values)
        
//        Swift.print(composite)
        // Check composite
        XCTAssertEqual(indexesWithUnequalValues(composite, expectedComposite), [])
        
        //2. Test returned message strings compiled from the composite
        var compiledStringForPrint = ""
        var compiledStringForEffectPrint = ""
        var printEffectString = false
        
        var printValueType: PrintValueType = .none
        let messageType = NodeType.elseCondition
        //Compile strings
        printer.compileStringsFromComposite(composite, messageType, SMST.fakeSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
        // Recompile readoutspacer
        let readoutSpacer = printer.readoutSpacer(fromComposite: composite, SMST.fakeSettings)
        // Check returned strings
        XCTAssertEqual(compiledStringForPrint, "ABCE         4   !N-1        398  🔴  - Decision event description")
        XCTAssertEqual(readoutSpacer + compiledStringForEffectPrint, "                                        Effect:Consequence description")
        //Only need to repeat detailed count breakdown check on failing test ... adapt and insert here from the first of this series of tests ...
        //Visual alignment check
        Swift.print(compiledStringForPrint)
        Swift.print(readoutSpacer+compiledStringForEffectPrint)
    }
    
    func test_compileSequentialComposite_ForDecisionFalse_WithRelativePrintNumberDisplay_ReturnsCorrectStringsForLargerNumbers(){
        var printNumber = 9998
        guard let messageToPrint = printMessages[printNumber] else { return  }
        
        guard let formatting = ClarityActivator.formatting else { return }
        let functionName = "" // if set it will change the value of some of the composite elements
        let values: Any? = nil // if set it will change the value of some of the composite elements
        
        //Relative numbering of both print number and function number
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        //Display absolute node number
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
        
        var expectedComposite = self.expectedComposite
         
        //All difference from the default including adjustments for relative PN
        expectedComposite[pC.index_EntityCode] = "BBCC"
        expectedComposite[pC.index_RJustifyAdjusterFromFunctionElements] = String(repeating: pC.singleSpace, count: 9)
        // spacer_RJustifyAdjusterFromFunctionElements
        // = (Adjuster: FN 6 = 1 place = 5 inverse spaces) + functionSymbolCompensationSpacer = 4 (apple=2 + f+space) = 9 spaces
        expectedComposite[pC.index_AdjustmentForFunctionNumberPlaces] = String(repeating: pC.singleSpace, count: 5)
        // = (Adjuster: FN 6 = 1 place = 5 inverse spaces) ( = 5 spaces)
        expectedComposite[pC.index_UsedFunctionNumber] = "6"
        expectedComposite[pC.index_FailNodeSymbol] = "!"
        expectedComposite[pC.index_UsedNodeNumber] = "1"
        expectedComposite[pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 5)
        // = (Adjuster: PN 1 = 1 place = 5 inverse spaces)
        expectedComposite[pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 2)
        // spacer_LJustifyAdjusterFromAbsoluteNodeNumberPlaces
        // = (Adjuster: PN 9998 = 3 place = 3 inverse spaces)
        expectedComposite[pC.index_AbsoluteNodeNumber] = "9998"
        expectedComposite[pC.index_OutcomeSymbol] = "🔴"
        expectedComposite[pC.index_EffectDescription] = "Consequence description"
        
        // Composite array
        let nodeType = printer.resolveNodeTypeGroup(messageToPrint, functionName, values)
        
        var composite =  printer.compileSequentialComposite(printNumber, messageToPrint, nodeType, SMST.fakeSettings, formatting, functionName, values)
        
        // Check composite
        XCTAssertEqual(indexesWithUnequalValues(composite, expectedComposite), [])
        //2. Test returned message strings compiled from the composite
        var compiledStringForPrint = ""
        var compiledStringForEffectPrint = ""
        var printEffectString = false
        
        var printValueType: PrintValueType = .none
        var messageType = NodeType.elseCondition
        
        //Compile strings
        printer.compileStringsFromComposite(composite, messageType, SMST.fakeSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
        // Compile readoutspacer
        var readoutSpacer = printer.readoutSpacer(fromComposite: composite, SMST.fakeSettings)
        
        XCTAssertEqual(compiledStringForPrint, "BBCC         6   !N-1       9998  🔴  - Decision event description")
        XCTAssertEqual(readoutSpacer + compiledStringForEffectPrint, "                                        Effect:Consequence description")
        
        Swift.print(compiledStringForPrint)
        Swift.print(readoutSpacer+compiledStringForEffectPrint)
        // Alignment check
        Swift.print("ABCE         4   !N-1        398  🔴  - Decision event description")
        
       
        
        //high Print number with high function number
        printNumber = 99988
        guard let messageToPrint = printMessages[printNumber] else { return  }
        //Relative numbering of both print number and function number
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = false
 
        
        expectedComposite[pC.index_RJustifyAdjusterFromFunctionElements] = String(repeating: pC.singleSpace, count: 5)
        // spacer_RJustifyAdjusterFromFunctionElements
        // = (Adjuster: FN 11129 = 5 places = 1 inverse spaces) + functionSymbolCompensationSpacer = 4 (apple=2 + f+space) = 5 spaces
        expectedComposite[pC.index_AdjustmentForFunctionNumberPlaces] = String(repeating: pC.singleSpace, count: 1)
        // = (Adjuster: FN 11129 = 1 place = 1 inverse spaces) ( = 1 spaces)
        expectedComposite[pC.index_UsedFunctionNumber] = "11129"
        expectedComposite[pC.index_FailNodeSymbol] = "!"
        expectedComposite[pC.index_UsedNodeNumber] = "1"
        expectedComposite[pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 5)
        // = (Adjuster: PN 1 = 1 place = 5 inverse spaces)
        expectedComposite[pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 1)
        // spacer_LJustifyAdjusterFromAbsoluteNodeNumberPlaces
        // = (Adjuster: PN 99988 = 5 place = 1 inverse spaces)
        expectedComposite[pC.index_AbsoluteNodeNumber] = "99988"
        
        // Composite array
        composite =  printer.compileSequentialComposite(printNumber, messageToPrint, nodeType, SMST.fakeSettings, formatting, functionName, values)
        
        // Check composite
        XCTAssertEqual(indexesWithUnequalValues(composite, expectedComposite), [])
        
        compiledStringForPrint = ""
        compiledStringForEffectPrint = ""
        printEffectString = false
        
        printValueType = .none
        messageType = NodeType.elseCondition
        
        //Compile strings
        printer.compileStringsFromComposite(composite, messageType, SMST.fakeSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
        
        readoutSpacer = printer.readoutSpacer(fromComposite: composite, SMST.fakeSettings)
        
        XCTAssertEqual(compiledStringForPrint, "BBCC     11129   !N-1      99988  🔴  - Decision event description")
        XCTAssertEqual(readoutSpacer + compiledStringForEffectPrint, "                                        Effect:Consequence description")
        
        Swift.print(compiledStringForPrint)
        Swift.print(readoutSpacer+compiledStringForEffectPrint)
    }
    
    func test_compileSequentialComposite_ForDecisionTrue_WithRelativePrintNumberDisplay_ReturnsCorrectStringsForLargerNumbers(){
        // Test alignment of the 'not/else bang' by comparison with true
        // Test 'incursion' of relative node number does not affect absolute node number position
        let printNumber = 99999
        guard let messageToPrint = printMessages[printNumber] else { return  }
        
        guard let formatting = ClarityActivator.formatting else { return }
        let functionName = "" // if set it will change the value of some of the composite elements
        let values: Any? = nil // if set it will change the value of some of the composite elements
        
        //Relative numbering of both print number and function number
     
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        //Display absolute node number
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
        
        var expectedComposite = self.expectedComposite
        
        //All difference from the default including adjustments for relative PN
        expectedComposite[pC.index_EntityCode] = "BBCC"
        expectedComposite[pC.index_RJustifyAdjusterFromFunctionElements] = String(repeating: pC.singleSpace, count: 5)
        // spacer_RJustifyAdjusterFromFunctionElements
        // = (Adjuster: FN 11129 = 5 place = 1 inverse spaces) + functionSymbolCompensationSpacer = 4 (apple=2 + f+space) = 5 spaces
        expectedComposite[pC.index_AdjustmentForFunctionNumberPlaces] = String(repeating: pC.singleSpace, count: 1)
        // = (Adjuster: FN 11129 = 5 place = 1 inverse spaces) ( = 1 spaces)
        expectedComposite[pC.index_UsedFunctionNumber] = "11129"
        expectedComposite[pC.index_FailNodeSymbol] = pC.singleSpace
        expectedComposite[pC.index_UsedNodeNumber] = "12"
        expectedComposite[pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 4)
        // = (Adjuster: PN 12 = 2 place = 4 inverse spaces)
        expectedComposite[pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 1)
        // spacer_LJustifyAdjusterFromAbsoluteNodeNumberPlaces
        // = (Adjuster: PN 99999 = 5 place = 1 inverse spaces)
        expectedComposite[pC.index_AbsoluteNodeNumber] = "99999"
        expectedComposite[pC.index_OutcomeSymbol] = "✅"
        expectedComposite[pC.index_EffectDescription] = "Consequence description"
        
        // Composite array
        let nodeType = printer.resolveNodeTypeGroup(messageToPrint, functionName, values)
        let composite =  printer.compileSequentialComposite(printNumber, messageToPrint, nodeType, SMST.fakeSettings, formatting, functionName, values)
        
        
        Swift.print(composite)
        
        // Check composite
        XCTAssertEqual(indexesWithUnequalValues(composite, expectedComposite), [])
        
        //2. Test returned message strings compiled from the composite
        var compiledStringForPrint = ""
        var compiledStringForEffectPrint = ""
        var printEffectString = false

        var printValueType: PrintValueType = .none
        let messageType = NodeType.ifTrueCondition

        //Compile strings
        printer.compileStringsFromComposite(composite, messageType, SMST.fakeSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
        // Compile readoutspacer
        let readoutSpacer = printer.readoutSpacer(fromComposite: composite, SMST.fakeSettings)

        XCTAssertEqual(compiledStringForPrint, "BBCC     11129    N-12     99999  ✅  - Decision event description")
        XCTAssertEqual(readoutSpacer + compiledStringForEffectPrint, "                                        Effect:Consequence description")

        Swift.print(compiledStringForPrint)
        Swift.print(readoutSpacer+compiledStringForEffectPrint)
        //Visual alignment check
        Swift.print("BBCC     11129   !N-1      99988  🔴  - Decision event description")
    }
    
    func test_compileSequentialComposite_ForFunctionNames_(){
        //Visual check of expected
        let functionName = #function
//        Swift.print("ABCD 🍎f    15    "+functionName)
        
        let printNumber = 72
        guard let messageToPrint = printMessages[printNumber] else { return  }
        
        guard let formatting = ClarityActivator.formatting else { return }
        
        let values: Any? = nil // if set it will change the value of some of the composite elements
        
        var expectedComposite = self.expectedComposite
       
        //All difference from the default including adjustments for relative PN
        expectedComposite[pC.index_EntityCode] = "ABCD"
        expectedComposite[pC.index_RJustifyAdjusterFromFunctionElements] = String(repeating: pC.singleSpace, count: 8)
        // spacer_RJustifyAdjusterFromFunctionElements
        // = (Adjuster: FN 15 = 2 place = 4 inverse spaces) + functionSymbolCompensationSpacer = 4 (apple=2 + f+space) = 8 spaces
        expectedComposite[pC.index_AdjustmentForFunctionNumberPlaces] = String(repeating: pC.singleSpace, count: 4)
        // = (Adjuster: FN 15 = 2 place = 4 inverse spaces) ( = 4 spaces)
        expectedComposite[pC.index_UsedFunctionNumber] = "15"
        expectedComposite[pC.index_FailNodeSymbol] = pC.singleSpace // Set as singleSpace for function names as a byproduct of setting for non fail nodes but index NOT compiled into the meesage string
        expectedComposite[pC.index_ControlFlowNodeTypeSymbol] = pC.emptyString // Remain empty for function names
        expectedComposite[17] = functionName // Required for function names
        expectedComposite[pC.index_UsedNodeNumber] = "72"
        expectedComposite[pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 4)
        // = (Adjuster: PN 15 = 2 place = 4 inverse spaces)
        expectedComposite[pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 4)
        // spacer_LJustifyAdjusterFromAbsoluteNodeNumberPlaces
        // = (Adjuster: PN 15 = 2 place = 4 inverse spaces)
        expectedComposite[pC.index_AbsoluteNodeNumber] = "72"
        expectedComposite[pC.index_OutcomeSymbol] = pC.emptyString // Remain empty for function names
        //Descriptions not relevant to functions but expectedComposite defaulted to different from the test JSON for 72
        expectedComposite[pC.index_EffectDescription] = "Consequence description"
        
        let nodeType = printer.resolveNodeTypeGroup(messageToPrint, functionName, values)
        // Composite array
        let composite =  printer.compileSequentialComposite(printNumber, messageToPrint, nodeType, SMST.fakeSettings, formatting, functionName, values)
        
        
//        Swift.print(composite)
        // Check composite
        XCTAssertEqual(indexesWithUnequalValues(composite, expectedComposite), [])
        
        //2. Test returned message strings compiled from the composite
        var compiledStringForPrint = ""
        var compiledStringForEffectPrint = ""
        var printEffectString = false

        var printValueType: PrintValueType = .none
        let messageType = NodeType.functionName

        //Compile string (only one returned for function names)
        printer.compileStringsFromComposite(composite, messageType, SMST.fakeSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
        XCTAssertEqual(compiledStringForPrint, "ABCD 🍎f    15    "+functionName)
        XCTAssertFalse(printEffectString)
        
        Swift.print(compiledStringForPrint)
        //Alignment - absolute PN calc
        Swift.print("ABCE        15   !N-1     🔴  - Decision event description")
        Swift.print("BBCC        29   !N-1      99988  🔴  - Decision event description")
    }
    
    func test_compileSequentialComposite_ForNodeOnly_(){
        //Visual check of expected
        let functionName = ""
        let funcNameForAlignmentCheck = #function
        Swift.print("ABCD 🍎f    15    "+funcNameForAlignmentCheck)
        Swift.print("ABCE        15   !N-1     🔴  - Decision event description")
        Swift.print("ABCD        15    12345")
        Swift.print("ABCD        15     2345")
        Swift.print("ABCD        15      345")
        Swift.print("ABCD        15       45")
        Swift.print("ABCD        15        5")
        
        
        let printNumber = 2
        guard let messageToPrint = printMessages[printNumber] else { return  }

        guard let formatting = ClarityActivator.formatting else { return }

        let values: Any? = nil // if set it will change the value of some of the composite elements

        var expectedComposite = self.expectedComposite

        SMST.fakeSettings.displayNodeInformationWithoutDescriptions = true
        
        //All difference from the default including adjustments for relative PN
        expectedComposite[pC.index_EntityCode] = "ABCD"
        expectedComposite[pC.index_RJustifyAdjusterFromFunctionElements] = String(repeating: pC.singleSpace, count: 8)
        // spacer_RJustifyAdjusterFromFunctionElements
        // = (Adjuster: FN 15 = 2 place = 4 inverse spaces) + functionSymbolCompensationSpacer = 4 (apple=2 + f+space) = 8 spaces
        expectedComposite[pC.index_AdjustmentForFunctionNumberPlaces] = String(repeating: pC.singleSpace, count: 4)
        // = (Adjuster: FN 15 = 2 place = 4 inverse spaces) ( = 4 spaces)
        expectedComposite[pC.index_UsedFunctionNumber] = "15"
        expectedComposite[pC.index_FailNodeSymbol] = pC.singleSpace // Set as singleSpace for node only as a byproduct of setting for non fail nodes but index NOT compiled into the message string
        expectedComposite[pC.index_ControlFlowNodeTypeSymbol] = "N"
       
        expectedComposite[pC.index_UsedNodeNumber] = "2"
        expectedComposite[pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 5)
        // = (Adjuster: PN 2 = 1 place = 5 inverse spaces) // Set but not used
        expectedComposite[pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces] = String(repeating: pC.singleSpace, count: 5)
        // spacer_LJustifyAdjusterFromAbsoluteNodeNumberPlaces
        // = (Adjuster: PN 2 = 1 place = 5 inverse spaces) // Will always be absolute for node only logging
        expectedComposite[pC.index_AbsoluteNodeNumber] = "2"
        expectedComposite[pC.index_OutcomeSymbol] = "✅"
        
        //Descriptions not relevant to functions but expectedComposite defaulted to different from the test JSON for 72
        expectedComposite[pC.index_EffectDescription] = "Do something"

        let nodeType = printer.resolveNodeTypeGroup(messageToPrint, functionName, values)
        // Composite array
        let composite =  printer.compileSequentialComposite(printNumber, messageToPrint, nodeType, SMST.fakeSettings, formatting, functionName, values)


//        Swift.print(composite)
        // Check composite
        XCTAssertEqual(indexesWithUnequalValues(composite, expectedComposite), [])

        //2. Test returned message strings compiled from the composite
        var compiledStringForPrint = ""
        var compiledStringForEffectPrint = ""
        var printEffectString = false

        var printValueType: PrintValueType = .none
        let messageType = NodeType.ifTrueCondition

        //Compile string (only one returned for function names)
        printer.compileStringsFromComposite(composite, messageType, SMST.fakeSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
        XCTAssertEqual(compiledStringForPrint, "ABCD        15        2")
        //No effect  string for node only
        XCTAssertFalse(printEffectString)

        Swift.print(compiledStringForPrint)
        Swift.print(printValueType)

    }
    
    
    
    
    func test_StringsContainingSymbolsReturnDoubleSpaceOfTheContainedSymbolsCharacterCount(){
        
        XCTAssertEqual("✅".symbolSpaceCount(), ("✅".count)*2)
        XCTAssertEqual("Success ✅".symbolSpaceCount(), ("✅".count)*2 + "Success ".count)
    }
    


// MARK: - 🧪 Tests -  ResolveMessageTypeGroup
func test_ResolveMessageTypeGroupGivenFunctionParameterArgumentReturnsFunctionName() {
    let functionName = #function
    guard let messageToPrint = printMessages[2] else { return  }
    let messageType = printer.resolveNodeTypeGroup(messageToPrint,functionName, nil)
    
    XCTAssertEqual(messageType, .functionName)
}

func test_ResolveMessageTypeGroupGivenValuesParameterArgumentReturnsValueReporter() {
    
    guard let messageToPrint = printMessages[2] else { return  }
    let messageType = printer.resolveNodeTypeGroup(messageToPrint,"", 5)
    
    XCTAssertEqual(messageType, .valueReporter)
}

func test_ResolveMessageTypeGroupGivenNoAdditionalArgumentsReturnsCorrectMessageType() {
    
    guard let messageToPrint = printMessages[2] else { return  }
    let messageType = printer.resolveNodeTypeGroup(messageToPrint,"", "")
    
    
    XCTAssertEqual(messageType, .valueReporter)
}

// MARK: - 🧪 Tests -  symbolsFromFormatting
func test_SymbolsFromFormatting() {
    
    let messageType = NodeType.ifTrueCondition
    let functionType = FunctionType.customFunc
    var controlFlowNodeTypeSymbol = ""
    var outcomeSymbol = ""
    var functionTypeSymbol = ""
    
    printer.symbolsFromFormatting(messageType, functionType, &controlFlowNodeTypeSymbol, &outcomeSymbol, &functionTypeSymbol)
    
    XCTAssertEqual(controlFlowNodeTypeSymbol, "N")
    XCTAssertEqual(outcomeSymbol, "✅")
    XCTAssertEqual(functionTypeSymbol, "🍎")
}


// MARK: - 🧪 Tests -  totalPlaces
func test_TotalPlacesFromIntReturnsCorrectValue() {
    var intToTest = 5
    XCTAssertEqual(printer.totalPlaces(from: intToTest), 1)
    intToTest = 50
    XCTAssertEqual(printer.totalPlaces(from: intToTest), 2)
    intToTest = 500
    XCTAssertEqual(printer.totalPlaces(from: intToTest), 3)
    intToTest = 5000
    XCTAssertEqual(printer.totalPlaces(from: intToTest), 4)
    intToTest = 50000
    XCTAssertEqual(printer.totalPlaces(from: intToTest), 5)
}

func test_TotalPlacesFromIntZeroReturns1() {
    let intToTest = 0
    XCTAssertEqual(printer.totalPlaces(from: intToTest), 1)
}

// MARK: - 🧪 Tests - spacer from places calculation
func test_SpacerFromPlacesReturnsCorrectStringSpaceCharacters() {
    var stringToTest = ""
    printer.spacerFromInversePlaces(5, &stringToTest)
    XCTAssertEqual(stringToTest, " ")
}


// MARK: - 🧪 Tests - calculateEntityCodeDifferentialSpacer calculation
//The character count of an entityCode can never be more than the maxium entityCode count collated from MessageCollector
func test_entityCodeEqualToMaxReturnsDifferential0() {
    //With JSON files all set to no bigger than entity code count of 4
    let characterCount = 4
    var entityCodeDiffSpacer = ""
    let maxEntityCodeCharacterCount = MessageCollator.maxEntityCodeCharacterCount
    printer.calculateEntityCodeDifferentialSpacer(characterCount,maxEntityCodeCharacterCount, &entityCodeDiffSpacer)
    
    XCTAssertEqual(entityCodeDiffSpacer.count, 0)
}
func test_entityCode1LessThanMaxReturnsDifferential1() {
    //With JSON files all set to no bigger than entity code count of 4
    let characterCount = 3
    var entityCodeDiffSpacer = ""
    let maxEntityCodeCharacterCount = MessageCollator.maxEntityCodeCharacterCount
    printer.calculateEntityCodeDifferentialSpacer(characterCount,maxEntityCodeCharacterCount, &entityCodeDiffSpacer)
    
    XCTAssertEqual(entityCodeDiffSpacer.count, 1)
}

func test_entityCode2LessThanMaxReturnsDifferential2() {
    //With JSON files all set to no bigger than entity code count of 4
    let characterCount = 2
    var entityCodeDiffSpacer = ""
    let maxEntityCodeCharacterCount = MessageCollator.maxEntityCodeCharacterCount
    printer.calculateEntityCodeDifferentialSpacer(characterCount,maxEntityCodeCharacterCount, &entityCodeDiffSpacer)
    
    XCTAssertEqual(entityCodeDiffSpacer.count, 2)
}

// MARK: - 🧪 Tests - ReadoutSpacer
func test_ReadoutSpacerMethodCalculatesSpacerFromCorrectIndexes() {
    // Indexes used by the readout spacer are:
    var messageIndexes: IndexSet = []
    let customSpacerIndexes =  pC.customSpacerIndexes
    let defaultSpacers = pC.defaultReadoutSpacers
    let defaultComponents = pC.defaultReadoutComponents
    let userSettableSymbolComponents = pC.userSettableSymbolReadoutComponents
    // measured separately in method = userSettableSymbolComponents = [15,24]  (because ordinary count method returns erroneous count for symbols)
    // Makes no difference to this test (that readoutSpacer counts from correct indexes
    // Here in this test counted as normal
    messageIndexes.formUnion(customSpacerIndexes)
    messageIndexes.formUnion(defaultSpacers)
    messageIndexes.formUnion(defaultComponents)
    messageIndexes.formUnion(userSettableSymbolComponents)
    
    //   messageIndexes = [0,1,2,3,8,9,10,12,13,15,16,18,19,23,24,25]
    // relativeNodeNumberingIndexes = [20,21,22]
    
    let relativeNodeNumberingIndexes = pC.absoluteNodeIndexes
    
    var arrayToTest = ["0","1","2",
                       "3","not used","not used","not used","not used","8","9",
                       "10","not used","12","13","not used","15","16",
                       "not used","18","19","not used","not used","not used","23",
                       "24","25","not used","not used","not used","not used","not used"]
    
    var stringToTest = ""
    stringToTest = printer.readoutSpacer(fromComposite: arrayToTest, SMST.fakeSettings)
     
    arrayToTest.arrayFromIndexes(messageIndexes)
    var filteredElements = arrayToTest.compactMap ({ $0 })
    var joined = filteredElements.joined()
    
    XCTAssertEqual(stringToTest.count, joined.count)
    
    SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
    arrayToTest = ["0","1","2",
                       "3","not used","not used","not used","not used","8","9",
                       "10","not used","12","13","not used","15","16",
                       "not used","18","19","20","21","22","23",
                       "24","25","not used","not used","not used","not used","not used"]
    
    
    stringToTest = printer.readoutSpacer(fromComposite: arrayToTest, SMST.fakeSettings)
    
    messageIndexes.formUnion(relativeNodeNumberingIndexes)
    
    arrayToTest.arrayFromIndexes(messageIndexes)
    filteredElements = arrayToTest.compactMap ({ $0 })
    joined = filteredElements.joined()
     
    XCTAssertEqual(stringToTest.count, joined.count)
}

// MARK: - 🧪 Tests - compileStringsFromComposite > compileStringForPrintType (Standard non-relative display)
// These tests also test compileStringForPrintType by call flow


// Given set of arguments
// compiledStringForPrint, stringComposite, isPrintEffect and  compiledStringForEffectPrint resolve correctly


func test_CompileStringsForDecisionMessageTypesReturnsCorrectValues() {
    
    let stringComposite = ["0 ","1 ","2 ",
                           "3 ","4 ","5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 ","20 ", "21 ","22 ","23 ","24 ","25 ","26 ","27 ","28 ","29 ","30 "]
    
    // All decision types should use following indexes
    // Event message = defaultMessageIndexes: [1,2,3,8,9,12,14,15,18,19,24,25,27] AND customSpacerIndexes [0,7,11,23]
    // Combined [0,1,2,3,7,8,9,11,12,14,15,18,19,23,24,25,27]
    
    // Effect message = effectIndexes: [29,30]
    
    
    // Arguments
    var messageType = NodeType.ifTrueCondition
    let usedSettings = SMST.fakeSettings
    let values: Any? = nil
    // inouts (returns)
    var printValueType = PrintValueType.none
    var compiledStringForPrint = ""
    var printEffectString = false
    var compiledStringForEffectPrint = ""
    //Expected
    let expectedEventString = "0 1 2 3 8 9 10 12 13 15 16 18 19 23 24 25 27 "
    let expectedEffectString = "29 30 "
    
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    
    
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    //        print(compiledStringForPrint)
    //        print(compiledStringForEffectPrint)
    // The result should be identical for all decision types other than .functionName and .valueReporter
    // All ten should be tested regardless
    messageType = .elseCondition
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .ifTrueConditionNegativeOutcome
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .elseConditionPositiveOutcome
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .caseTruePositiveOutcome
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .caseTrueNegativeOutcome
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .guardPass
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .guardFail
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .doTryPass
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .catchTryFail
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
}





func test_CompileStringsForValueReporterMessageTypeWithSingleValueReturnsCorrectValues() {
    
    let stringComposite = ["0 ","1 ","2 ",
                           "3 ","4 ","5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 ","20 ", "21 ","22 ","23 ","24 ","25 ","26 ","27 ","28 ","29 ","30 "]
    
    // valueReporter should use following indexes
    //  defaultMessageIndexes: [1,2,3,8,9,12,14,15,18,19,24,25,27] AND customSpacerIndexes [0,7,11,23] AND valueReportIndexes [26,28]
    // Combined [0,1,2,3,7,8,9,11,12,14,15,18,19,23,24,25,26,27,28]
    
    // Arguments
    let messageType = NodeType.valueReporter
    let usedSettings = SMST.fakeSettings
    let values = "a"
    // inouts (returns)
    var printValueType = PrintValueType.none
    var compiledStringForPrint = ""
    var printEffectString = false
    var compiledStringForEffectPrint = ""
    //Expected
    let expectedEventString = "0 1 2 3 8 9 10 12 13 15 16 18 19 23 24 25 26 27 28 "
    
    
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    
    
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertFalse(printEffectString)
    
    guard case let .singleValue(single: single) = printValueType else {
        XCTFail("Expected PrintValueType.singleValue, but was \(printValueType)")
        return
    }
    XCTAssertEqual(single as! String, "a")
}

func test_CompileStringsForValueReporterMessageTypeWithDictionaryValuesReturnsCorrectValues() {
    
    let stringComposite = ["0 ","1 ","2 ",
                           "3 ","4 ","5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 ","20 ", "21 ","22 ","23 ","24 ","25 ","26 ","27 ","28 ","29 ","30 "]
    
    // valueReporter should use following indexes
    //  defaultMessageIndexes: [1,2,3,8,9,12,14,15,18,19,24,25,27] AND customSpacerIndexes [0,7,11,23] AND valueReportIndexes [26,28]
    // Combined [0,1,2,3,7,8,9,11,12,14,15,18,19,23,24,25,26,27,28]
    
    // Arguments
    let messageType = NodeType.valueReporter
    let usedSettings = SMST.fakeSettings
    let values = ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]
    // inouts (returns)
    var printValueType = PrintValueType.none
    var compiledStringForPrint = ""
    var printEffectString = false
    var compiledStringForEffectPrint = ""
    //Expected
    let expectedEventString = "0 1 2 3 8 9 10 12 13 15 16 18 19 23 24 25 26 27 28 "
    
    
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    
    
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertFalse(printEffectString)
    
    guard case let .dictionaryValue(dictionary: dictionary) = printValueType else {
        XCTFail("Expected PrintValueType.singleValue, but was \(printValueType)")
        return
    }
    XCTAssertEqual(dictionary["b"] as! Int , 2)
}

func test_CompileStringsForValueReporterMessageTypeWithArrayValuesReturnsCorrectValues() {
    
    let stringComposite = ["0 ","1 ","2 ",
                           "3 ","4 ","5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 ","20 ", "21 ","22 ","23 ","24 ","25 ","26 ","27 ","28 ","29 ","30 "]
    
    // valueReporter should use following indexes
    //  defaultMessageIndexes: [1,2,3,8,9,12,14,15,18,19,24,25,27] AND customSpacerIndexes [0,7,11,23] AND valueReportIndexes [26,28]
    // Combined [0,1,2,3,7,8,9,11,12,14,15,18,19,23,24,25,26,27,28]
    
    // Arguments
    let messageType = NodeType.valueReporter
    let usedSettings = SMST.fakeSettings
    let values = ["a", "b", "c", "d", "e"]
    // inouts (returns)
    var printValueType = PrintValueType.none
    var compiledStringForPrint = ""
    var printEffectString = false
    var compiledStringForEffectPrint = ""
    //Expected
    let expectedEventString = "0 1 2 3 8 9 10 12 13 15 16 18 19 23 24 25 26 27 28 "
    
    
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    
    
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertFalse(printEffectString)
    
    guard case let .arrayValue(array: array) = printValueType else {
        XCTFail("Expected PrintValueType.singleValue, but was \(printValueType)")
        return
    }
    XCTAssertEqual(array[3] as! String , "d")
}

func test_CompileStringsForFunctionNameMessageTypeReturnsCorrectValues() {
    
    let stringComposite = ["0 ","1 ","2 ",
                           "3 ","4 ","5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 ","20 ", "21 ","22 ","23 ","24 ","25 ","26 ","27 ","28 ","29 ","30 "]
    
    // functionName should use following indexes
    // functionNameIndexes [1,2,4,5,6,8,10,13,16] AND customSpacerIndexes [0,7,11,23]
    //NB! does not actually use 23 but should not affect it so leave for now as a convenience
    // Combined [0,1,2,4,5,6,7,8,10,11,13,16,23]
    
    // Arguments
    let messageType = NodeType.functionName
    let usedSettings = SMST.fakeSettings
    let values: Any? = nil
    // inouts (returns)
    var printValueType = PrintValueType.none
    var compiledStringForPrint = ""
    var printEffectString = false
    var compiledStringForEffectPrint = ""
    //Expected
    let expectedEventString = "0 1 2 4 5 6 7 8 9 11 12 17 23 "
    
    
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    
    
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertFalse(printEffectString)
    
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    
}

func test_CompileStringsFoNodeOnlyMessageTypeReturnsCorrectValues() {
    
    let stringComposite = ["0 ","1 ","2 ",
                           "3 ","4 ","5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 ","20 ", "21 ","22 ","23 ","24 ","25 ","26 ","27 ","28 ","29 ","30 "]
    
    // nodeOnly applies to all decision types (NOT functionName or valueReporter) - applying ifTrueCondition here
    // nodeOnly should use following indexes
    // nodeOnlyIndexes [1,2,3,8,9,13,17,18] AND customSpacerIndexes [0,7,11,23]
    //NB! does not actually use 23 but should not affect it so leave for now as a convenience
    // Combined [0,1,2,3,7,8,9,11,13,17,18,23]
    SMST.fakeSettings.displayNodeInformationWithoutDescriptions = true
    // Arguments
    let messageType = NodeType.ifTrueCondition
    let usedSettings = SMST.fakeSettings
    let values: Any? = nil
    // inouts (returns)
    var printValueType = PrintValueType.none
    var compiledStringForPrint = ""
    var printEffectString = false
    var compiledStringForEffectPrint = ""
    //Expected
    let expectedEventString = "0 1 2 3 8 9 10 12 20 21 23 "
    
    
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    
    
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    
    
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    
}


// MARK: - 🧪 Tests - compileStringsFromComposite >  compileStringForPrintType (Relative node number display)
func test_CompileStringsForControlNodeGroupMessageType_ForRelativeNodeNumber_ReturnsCorrectValues() {
    
    let stringComposite = ["0 ","1 ","2 ",
                           "3 ","4 ","5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 ","20 ", "21 ","22 ","23 ","24 ","25 ","26 ","27 ","28 ","29 ","30 "]
    
    // All decision types should use following indexes
    // Event message = defaultMessageIndexes: [1,2,3,8,9,12,14,15,18,19,24,25,27] AND customSpacerIndexes [0,7,11,23] AND absoluteNodeIndexes [20,21,22]
    // Combined [0,1,2,3,7,8,9,11,12,14,15,18,19,20,21,22,23,24,25,27]
    
    // Effect message = effectIndexes: [29,30]
    SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
    
    // Arguments
    var messageType = NodeType.ifTrueCondition
    let usedSettings = SMST.fakeSettings
    let values: Any? = nil
    // inouts (returns)
    var printValueType = PrintValueType.none
    var compiledStringForPrint = ""
    var printEffectString = false
    var compiledStringForEffectPrint = ""
    //Expected
    let expectedEventString = "0 1 2 3 8 9 10 12 13 15 16 18 19 20 21 22 23 24 25 27 "
    let expectedEffectString = "29 30 "
    
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    
    
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }

    //        // All ten should be tested regardless
    messageType = .elseCondition
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .ifTrueConditionNegativeOutcome
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .elseConditionPositiveOutcome
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .caseTruePositiveOutcome
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .caseTrueNegativeOutcome
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .guardPass
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .guardFail
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .doTryPass
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    messageType = .catchTryFail
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertTrue(printEffectString)
    XCTAssertEqual(compiledStringForEffectPrint, expectedEffectString)
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
}


func test_CompileStringsForValueReporterMessageType_WithSingleValue_ForRelativeNodeNumber_ReturnsCorrectValues() {
    
    let stringComposite = ["0 ","1 ","2 ",
                           "3 ","4 ","5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 ","20 ", "21 ","22 ","23 ","24 ","25 ","26 ","27 ","28 ","29 ","30 "]
    
    // valueReporter should use following indexes
    //  defaultMessageIndexes: [1,2,3,8,9,12,14,15,18,19,24,25,27] AND customSpacerIndexes [0,7,11,23] AND valueReportIndexes [26,28] AND absoluteNodeIndexes [20,21,22]
    // Combined [0,1,2,3,7,8,9,11,12,14,15,18,19,20,21,22,23,24,25,26,27,28]
    SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
    // Arguments
    let messageType = NodeType.valueReporter
    let usedSettings = SMST.fakeSettings
    let values = "a"
    // inouts (returns)
    var printValueType = PrintValueType.none
    var compiledStringForPrint = ""
    var printEffectString = false
    var compiledStringForEffectPrint = ""
    //Expected
    let expectedEventString = "0 1 2 3 8 9 10 12 13 15 16 18 19 20 21 22 23 24 25 26 27 28 "
    
    
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    
    
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertFalse(printEffectString)
    
    guard case let .singleValue(single: single) = printValueType else {
        XCTFail("Expected PrintValueType.singleValue, but was \(printValueType)")
        return
    }
    XCTAssertEqual(single as! String, "a")
}

func test_CompileStringsForValueReporterMessageType_WithDictionaryValues_ForRelativeNodeNumber_ReturnsCorrectValues() {
    
    let stringComposite = ["0 ","1 ","2 ",
                           "3 ","4 ","5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 ","20 ", "21 ","22 ","23 ","24 ","25 ","26 ","27 ","28 ","29 ","30 "]
    
    // valueReporter should use following indexes
    //  defaultMessageIndexes: [1,2,3,8,9,12,14,15,18,19,24,25,27] AND customSpacerIndexes [0,7,11,23] AND valueReportIndexes [26,28] AND absoluteNodeIndexes [20,21,22]
    // Combined [0,1,2,3,7,8,9,11,12,14,15,18,19,20,21,22,23,24,25,26,27,28]
    SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
    // Arguments
    let messageType = NodeType.valueReporter
    let usedSettings = SMST.fakeSettings
    let values = ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]
    // inouts (returns)
    var printValueType = PrintValueType.none
    var compiledStringForPrint = ""
    var printEffectString = false
    var compiledStringForEffectPrint = ""
    //Expected
    let expectedEventString = "0 1 2 3 8 9 10 12 13 15 16 18 19 20 21 22 23 24 25 26 27 28 "
    
    
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    
     
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertFalse(printEffectString)
    
    guard case let .dictionaryValue(dictionary: dictionary) = printValueType else {
        XCTFail("Expected PrintValueType.singleValue, but was \(printValueType)")
        return
    }
    XCTAssertEqual(dictionary["b"] as! Int , 2)
}

func test_CompileStringsForValueReporterMessageType_WithArrayValues_ForRelativeNodeNumber_ReturnsCorrectValues() {
    
    let stringComposite = ["0 ","1 ","2 ",
                           "3 ","4 ","5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 ","20 ", "21 ","22 ","23 ","24 ","25 ","26 ","27 ","28 ","29 ","30 "]
    
    // valueReporter should use following indexes
    //  defaultMessageIndexes: [1,2,3,8,9,12,14,15,18,19,24,25,27] AND customSpacerIndexes [0,7,11,23] AND valueReportIndexes [26,28] AND absoluteNodeIndexes [20,21,22]
    // Combined [0,1,2,3,7,8,9,11,12,14,15,18,19,20,21,22,23,24,25,26,27,28]
    SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
    // Arguments
    let messageType = NodeType.valueReporter
    let usedSettings = SMST.fakeSettings
    let values = ["a", "b", "c", "d", "e"]
    // inouts (returns)
    var printValueType = PrintValueType.none
    var compiledStringForPrint = ""
    var printEffectString = false
    var compiledStringForEffectPrint = ""
    //Expected
    let expectedEventString = "0 1 2 3 8 9 10 12 13 15 16 18 19 20 21 22 23 24 25 26 27 28 "
    
    
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    
    
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertFalse(printEffectString)
    
    guard case let .arrayValue(array: array) = printValueType else {
        XCTFail("Expected PrintValueType.singleValue, but was \(printValueType)")
        return
    }
    XCTAssertEqual(array[3] as! String , "d")
}

func test_CompileStringsForFunctionNameMessageType_ForRelativeNodeNumber_ReturnsCorrectValues() {
    
    let stringComposite = ["0 ","1 ","2 ",
                           "3 ","4 ","5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 ","20 ", "21 ","22 ","23 ","24 ","25 ","26 ","27 ","28 ","29 ","30 "]
    
    // functionName should use following indexes
    // functionNameIndexes [1,2,4,5,6,8,10,13,16] AND customSpacerIndexes [0,7,11,23]
    //NB! does not actually use 23 but should not affect it so leave for now as a convenience
    // Combined [0,1,2,4,5,6,7,8,10,11,13,16,23]
    
    //NB Currently relative node number should have NO effect outcome is the same as standard
    SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
    // Arguments
    let messageType = NodeType.functionName
    let usedSettings = SMST.fakeSettings
    let values: Any? = nil
    // inouts (returns)
    var printValueType = PrintValueType.none
    var compiledStringForPrint = ""
    var printEffectString = false
    var compiledStringForEffectPrint = ""
    //Expected
    let expectedEventString = "0 1 2 4 5 6 7 8 9 11 12 17 23 "
    
    
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    
    
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    XCTAssertFalse(printEffectString)
    
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
    
}

func test_CompileStringsFoNodeOnlyMessageType_ForRelativeNodeNumber_ReturnsCorrectValues() {
    
    let stringComposite = ["0 ","1 ","2 ",
                           "3 ","4 ","5 ","6 ","7 ","8 ","9 ","10 ","11 ","12 ","13 ","14 ","15 ","16 ","17 ","18 ","19 ","20 ", "21 ","22 ","23 ","24 ","25 ","26 ","27 ","28 ","29 ","30 "]
    
    // nodeOnly applies to all decision types (NOT functionName or valueReporter) - applying ifTrueCondition here
    // nodeOnly should use following indexes
    // nodeOnlyIndexes [1,2,3,8,9,13,17,18] AND customSpacerIndexes [0,7,11,23]
    //NB! does not actually use 23 but should not affect it so leave for now as a convenience
    // Combined [0,1,2,3,7,8,9,11,13,17,18,23]
    SMST.fakeSettings.displayNodeInformationWithoutDescriptions = true
    
    //NB Currently relative node number should have NO effect outcome is the same as standard
    SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
    // Arguments
    let messageType = NodeType.ifTrueCondition
    let usedSettings = SMST.fakeSettings
    let values: Any? = nil
    // inouts (returns)
    var printValueType = PrintValueType.none
    var compiledStringForPrint = ""
    var printEffectString = false
    var compiledStringForEffectPrint = ""
    //Expected
    let expectedEventString = "0 1 2 3 8 9 10 12 20 21 23 "
    
    
    printer.compileStringsFromComposite(stringComposite, messageType, usedSettings, values, &printValueType, &compiledStringForPrint, &printEffectString, &compiledStringForEffectPrint)
    
    
    XCTAssertEqual(compiledStringForPrint, expectedEventString)
    
    
    guard case .none = printValueType else {
        XCTFail("Expected PrintValueType.none, but was \(printValueType)")
        return
    }
}

}
