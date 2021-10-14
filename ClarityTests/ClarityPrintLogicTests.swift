//
//  ClarityPrintLogicTests.swift
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

class ClarityPrintLogicTests: XCTestCase {
    
    // MARK: - 🦮 Helpers - Fake settings data for File access SUT


    
    
    
    
    // MARK: - 🦮 Helpers - Mock ClarityPrintLogic
    struct MockPrinter: ClarityPrintHelper{
    }
    let printer = MockPrinter()
    let printMessages = MessageCollator.sharedMessages
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
    
    
    //Fakes the print call logic string compilation
    func setSUTForComposite(_ printNumber: Int, _ printType: PrintType, _ functionName: String? = nil, values: Any? = nil ) -> (String, String) {
        guard let messageToPrint = printMessages[printNumber] else {
            return ("","")
        }
        guard let formatting = ClarityActivator.formatting else {
            return ("","")
        }
        let nodeType = printer.resolveNodeTypeGroup(messageToPrint, functionName, values)
        
        let stringComposite =  printer.compileSequentialComposite(printNumber, messageToPrint,nodeType, SettingsManagerServiceTests.fakeSettings, formatting, functionName, values)
        
        let compiledStringForPrint = printer.compileStringForPrintType(printType, withComposite: stringComposite)
        let readoutSpacer = printer.readoutSpacer(fromComposite: stringComposite, SMST.fakeSettings)
        
        return (compiledStringForPrint,readoutSpacer)
    }
    
    fileprivate func sutStringFromPrintNumberAndParameters(_ printNumber: Int, printType: PrintType, _ printResult: Bool = false, _ functionName: String? = nil,  values: Any? = nil) -> (compiledString: String, effect:String) {
        //Custom absolute numbering
        
        let compiledString = setSUTForComposite(printNumber,printType,functionName, values: values).0
        let effect = setSUTForComposite(printNumber,printType,functionName).0
        let readoutSpacer = setSUTForComposite(printNumber,printType,functionName).1
        if printResult {
            //Now need to divide print by different overload parameters
            if functionName != "" && functionName != nil{
                print(printNumber, functionName: functionName, settings: SMST.fakeSettings)
            }else if values != nil{
                print(printNumber, values: values, settings: SMST.fakeSettings)
            }else{
                print(printNumber, settings: SMST.fakeSettings)
            }
        }
        return (compiledString, readoutSpacer+effect)
    }
    

    
    // MARK: - 🧪 Tests -  Mock ClarityPrintLogic message string compiling
    // Given all parameters required to print a message string the compiled string is as expected correlating to various settings
    
    // IMPORTANT These tests test the correct compilation of strings from given parameters but they do NOT test whether the correct parameters are actually calculated
    // Nor do they test the actual output of the print logic method itself
 
    // Decisions Events & Effects
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber2() {
    
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(2, printType: .event,true).compiledString, "ABCD        15    N-2     ✅  - Decision event description")
        
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(2, printType: .effect).effect, "                                Effect:Do something")
        
    }
    
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber398_ForRelativeNumberFormatting() {
        
        //Custom absolute numbering
        //Print 398 should display F89 & N398

        XCTAssertEqual(sutStringFromPrintNumberAndParameters(398, printType: .event, true).compiledString, "ABCE        89   !N-398   🔴  - Decision event description")
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(398, printType: .effect).effect, "                                Effect:Consequence description")
        
        //Relative numbering
        //Print 398 should display F4 & N1
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(398, printType: .event, true).compiledString, "ABCE         4   !N-1     🔴  - Decision event description")
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(398, printType: .effect).effect, "                                Effect:Consequence description")
         
    }

    


    
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber398_ForRelativeNumberFormatting_DisplayPrintNumber() {

//        XCTAssertEqual(sutStringFromPrintNumberAndParameters(398, printType: .Decision, true).compiledString, "ABCE        89   !N-398   🔴  - Decision event description")
//        XCTAssertEqual(sutStringFromPrintNumberAndParameters(398, printType: .Effect).effect, "                                Effect:Consequence description")
        
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(398, printType: .eventDisplayPrintNumber, true).compiledString, "ABCE         4   !N-1        398  🔴  - Decision event description")
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(398, printType: .effectDisplayPrintNumber).effect, "                                        Effect:Consequence description")
        
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(9998, printType: .eventDisplayPrintNumber, true).compiledString, "BBCC         6   !N-1       9998  🔴  - Decision event description")
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(9998, printType: .effectDisplayPrintNumber).effect, "                                        Effect:Consequence description")
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(99998, printType: .eventDisplayPrintNumber, true).compiledString, "BBCC     11129   !N-11     99998  🔴  - Decision event description")
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(99998, printType: .effectDisplayPrintNumber).effect, "                                        Effect:Consequence description")
    }
    
    func test_NodeOnly_ReturnsCorrectFormatting_ForPrintNumber2() {
        
        SMST.fakeSettings.displayNodeInformationWithoutDescriptions = true
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(2, printType: .nodeOnly,true).compiledString, "ABCD        15        2")
    
        //Effect value irrelevent – when nodeOnly it is not compiled or printed by the framework
        //(In the testing target it would be compiled if commanded to do so by sutStringFromPrintNumberAndParameters)
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(398, printType: .nodeOnly,true).compiledString, "ABCE         4      398")
        
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true // Now will have no effect nodeonly is absolutenodeonly
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(398, printType: .nodeOnly,true).compiledString, "ABCE         4      398")
    }
    
    //Function
    func test_FunctionArgument_ReturnsCorrectFormatting_ForPrintNumber72() {
        let functionName = #function
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(72, printType: .functionName, true, functionName).compiledString, "ABCD 🍎f    15    "+functionName)
        
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(72, printType: .functionName, true, functionName).compiledString, "ABCD 🍎f     1    "+functionName)
        
        
    }
    
    
    //Values
    func test_SingleValueArgument_ReturnsCorrectFormatting_ForPrintNumber205() {

        XCTAssertEqual(sutStringFromPrintNumberAndParameters(205, printType: .valueSingle, true, values: "a").compiledString, "BBCC        27    R-205   📋  - Value for variable Decision event description is:")
    }
    
    func test_SingleValueArgument_Relative_ReturnsCorrectFormatting_ForPrintNumber205() {
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true

        XCTAssertEqual(sutStringFromPrintNumberAndParameters(205, printType: .valueSingleDisplayPrintNumber, true, values: "a").compiledString, "BBCC        27    R-1        205  📋  - Value for variable Decision event description is:")
    }
    
    func test_DictionaryValuesArgument_ReturnsCorrectFormatting_ForPrintNumber205() {

        XCTAssertEqual(sutStringFromPrintNumberAndParameters(205, printType: .valuesDictionary, true, values: ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]).compiledString, "BBCC        27    R-205   📋  - Values for variables Decision event description are:")
    }
    
    func test_DictionaryValuesArgument_Relative_ReturnsCorrectFormatting_ForPrintNumber205() {
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
 
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(205, printType: .valuesDictionaryDisplayPrintNumber, true, values: ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]).compiledString, "BBCC        27    R-1        205  📋  - Values for variables Decision event description are:")
    }
    
 
    func test_ArrayValuesArgument_ReturnsCorrectFormatting_ForPrintNumber205() {

        XCTAssertEqual(sutStringFromPrintNumberAndParameters(205, printType: .valuesArray, true, values: [1,2,3,4,5,6]).compiledString, "BBCC        27    R-205   📋  - Values for variables Decision event description are:")
    }
    
    func test_ArrayValuesArgument_Relative_ReturnsCorrectFormatting_ForPrintNumber205() {
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
 
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
        
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(205, printType: .valuesArrayDisplayPrintNumber, true, values: [1,2,3,4,5,6]).compiledString, "BBCC        27    R-1        205  📋  - Values for variables Decision event description are:")
    }
    
    func test_ReporterWithNoValues_ReturnsCorrectFormatting_ForPrintNumber206() {
        
        //valueReporter that have NO value argument become printType: .reporter and have no valuesReporterLabel or reporterAuxiliaryLabel (should have same indexes as event but filled with different symbols)
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(206, printType: .reporter, true).compiledString, "BBCC        27    R-206   📋  - (variable name(s) or description(s)")

        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(206, printType: .reporterDisplayPrintNumber, true).compiledString, "BBCC        27    R-2        206  📋  - (variable name(s) or description(s)")
    }
    
    
    func test_ErrorReporterWithError_ReturnsCorrectFormatting_ForPrintNumber2() {

        //valueReporter that have NO value argument become printType: .reporter and have no valuesReporterLabel or reporterAuxiliaryLabel (should have same indexes as event but filled with different symbols)
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(299, printType: .errorReporter, true).compiledString, "ZZYY       889    E-299   ☎️  - Error for description of the error is:")

        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        SMST.fakeSettings.displayNodePrintNumberWhenUsingRelativeNumbering = true
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(299, printType: .errorReporterDisplayPrintNumber, true).compiledString, "ZZYY         4    E-1        299  ☎️  - Error for description of the error is:")
    }
    
    

    

    // MARK: -  🧪 Tests - Max entity code
    func test_MaxEntityCodeCharacterCount_ReturnsCorrectFormatting_ForLesserEntityCodeCounts (){
        
        //This test borrows stub from MessageCollatorTests  (not really necessary - could just use a local Int - but expresses the simulation of the values source)
        
        // From files
        var printNumber = 2
        let functionName: String? = nil
        let values: Any? = nil
        var printType: PrintType = .event
        
        guard let messageToPrint = printMessages[printNumber] else {
            return
        }
        guard let formatting = ClarityActivator.formatting else {
            return
        }
        
        
        var nodeType = printer.resolveNodeTypeGroup(messageToPrint, functionName, values)
        
        var stringComposite =  printer.compileSequentialComposite(printNumber, messageToPrint, nodeType, SMST.fakeSettings, formatting, functionName, values)
        
        //Alter EntityCode length
        //EntityCode = [1]
        //spacer_entityCodeDifferential = [2]
        var entityCode = "ABCD"
        let entityCodeCount = entityCode.count
        
        var maximumEntityCode = "ABCD" // max is the same as printed  (as in the files)
        
        var entityCodeDiffSpacer = ""
        
        //Borrow stub (not really necessary - could just use a local Int - but expresses the values source)
        MessageCollatorTests.StubMessageCollator.maxEntityCodeCharacterCount = maximumEntityCode.count
        
        printer.calculateEntityCodeDifferentialSpacer(entityCodeCount, MessageCollatorTests.StubMessageCollator.maxEntityCodeCharacterCount, &entityCodeDiffSpacer)
        
        stringComposite[1] = entityCode
        stringComposite[2] = entityCodeDiffSpacer
        
        var compiledStringForPrint = printer.compileStringForPrintType(printType, withComposite: stringComposite)
        printType = .effect
        var compiledEffectStringForPrint = printer.compileStringForPrintType(printType, withComposite: stringComposite)
        
        var readoutSpacer = printer.readoutSpacer(fromComposite: stringComposite, SMST.fakeSettings)
        
        
        XCTAssertEqual(compiledStringForPrint, "ABCD        15    N-2     ✅  - Decision event description")
        XCTAssertEqual(readoutSpacer+compiledEffectStringForPrint, "                                Effect:Do something")
        
        maximumEntityCode = "ABCDE" // simulate a larger max
        
        //Borrow stub (not really necessary - could just use a local Int - but expresses the values source)
        MessageCollatorTests.StubMessageCollator.maxEntityCodeCharacterCount = maximumEntityCode.count
        printer.calculateEntityCodeDifferentialSpacer(entityCodeCount, MessageCollatorTests.StubMessageCollator.maxEntityCodeCharacterCount, &entityCodeDiffSpacer)
        
        stringComposite[2] = entityCodeDiffSpacer
        printType = .event
        compiledStringForPrint = printer.compileStringForPrintType(printType, withComposite: stringComposite)
        printType = .effect
        compiledEffectStringForPrint = printer.compileStringForPrintType(printType, withComposite: stringComposite)
        readoutSpacer = printer.readoutSpacer(fromComposite: stringComposite, SMST.fakeSettings)
        //All printouts should edge further forward by the difference between their EntityCode count and the max
        XCTAssertEqual(compiledStringForPrint, "ABCD         15    N-2     ✅  - Decision event description")
        XCTAssertEqual(readoutSpacer+compiledEffectStringForPrint, "                                 Effect:Do something")
        
        //Relative
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        SMST.fakeSettings.calculateNodeNumbersRelativeToFunction = true
        
        printNumber = 398
        entityCode = "ABCE"
        
        guard let messageToPrint = printMessages[printNumber] else {
            return
        }
        
        nodeType = printer.resolveNodeTypeGroup(messageToPrint, functionName, values)
         
        stringComposite =  printer.compileSequentialComposite(printNumber, messageToPrint, nodeType, SMST.fakeSettings, formatting, functionName, values)
        
        stringComposite[1] = entityCode
        stringComposite[2] = entityCodeDiffSpacer
        
        printType = .event
        compiledStringForPrint = printer.compileStringForPrintType(printType, withComposite: stringComposite)
        printType = .effect
        compiledEffectStringForPrint = printer.compileStringForPrintType(printType, withComposite: stringComposite)
        readoutSpacer = printer.readoutSpacer(fromComposite: stringComposite, SMST.fakeSettings)
        
        XCTAssertEqual(compiledStringForPrint, "ABCE          4   !N-1     🔴  - Decision event description")
        XCTAssertEqual(readoutSpacer+compiledEffectStringForPrint, "                                 Effect:Consequence description")
        
        //Currently NOT used by MessageCollatorTests tests but could impact if this changes and called afterwards - therefore as a safety reset the borrowed stub
        //Done here rather than in a tear down that would be called multiple times unnecessarily
        MessageCollatorTests.StubMessageCollator.maxEntityCodeCharacterCount = 4
    }
    
    
    
    // MARK: - 🧪 Tests -  Mock ClarityPrintLogic value printing
    // Given an enum of type PrintValue with an associated value the values printed to the console are as expected
    func test_SingleValue_PrintsCorrectValueToConsole_ForPrintNumber205() {
        let valueInput = "a"
        let singlePrintValue = PrintValueType.singleValue(single: valueInput)
        var returnString = ""
        let expected = valueInput
  
        if case .singleValue(let single) = singlePrintValue {
            returnString = printer.printValue(single, withReadOutSpacer: "")
        }
        
        XCTAssertEqual(returnString,expected)
    }
    
 
    func test_DictionaryValue_PrintsCorrectValuesToConsole() {
        let valueInput = ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]
        let dictionaryPrintValue = PrintValueType.dictionaryValue(dictionary: valueInput)
        var stringArray = [""]
        
        let entityCode = "ABCD"
        let characterCount = entityCode.count
        var entityCodeDiffSpacer = ""
        let maxEntityCodeCharacterCount = MessageCollator.maxEntityCodeCharacterCount
        printer.calculateEntityCodeDifferentialSpacer(characterCount,maxEntityCodeCharacterCount, &entityCodeDiffSpacer)
        
        var expected = "a:1"

        if case .dictionaryValue(let dictionary) = dictionaryPrintValue {
            stringArray = printer.printCollectionValues(dictionary, withReadOutSpacer: "")
        }

        XCTAssertEqual(stringArray.sorted()[0],expected)
        //NB this exposed objc throwback – cannot change a var element 2 of a var 1 and expect var 1 to change
        // "a:1"/"e:5" set to a variable for some reason I thought 'expected' would change like a pointer
        //Hopefully I havent made this throwback mistake anywhere else
        //Upshot variables are only going to change when they are directly assigned to something different
        expected = "e:5"
        XCTAssertEqual(stringArray.sorted()[4],expected)
    }
    

    func test_ArrayValues_PrintsCorrectValueToConsole_ForPrintNumber205() {
        let valueInput = [1,2,3,5,6]
        let arrayPrintValue = PrintValueType.arrayValue(array:valueInput)
        var stringArray = [""]
        
        var expected = "1"

        if case .arrayValue(let array) = arrayPrintValue {
            stringArray = printer.printCollectionValues(array, withReadOutSpacer: "")
        }

        XCTAssertEqual(stringArray[0],expected)
        //NB this exposed objc throwback – cannot change a var element 2 of a var 1 and expect var 1 to change
        // "a:1"/"e:5" set to a variable for some reason I thought 'expected' would change like a pointer
        //Hopefully I havent made this throwback mistake anywhere else
        //Upshot variables are only going to change when they are directly assigned to something different
        expected = "6"
        XCTAssertEqual(stringArray[4],expected)
    }
    
    
    // MARK: - 🧪 Tests -  Mock ClarityPrintLogic message string compiling - other settings affecting compiled strings
    
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber205_ForFNAlwayscustom() {
        // BBCC > FN 27 >  function_number_always_custom == true
        //This test shows how the function_number_always_custom setting in the entity JSON (EntityLogService) for 'always use a custom function number' overrides the calculateFunctionNumbersRelativeToEntity setting in the Settings json
        SMST.fakeSettings.calculateFunctionNumbersRelativeToEntity = true
        
        // Show FN 27 instead of 3 because function_number_always_custom set to true in the JSON file
        
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(205, printType: .event, true).compiledString, "BBCC        27   !N-205   🔴  - Decision event description")
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(205, printType: .effect).effect, "                                Effect:Consequence description")
    }
    
 
    
    
    
    
    // MARK: - 🧪 Tests -  Mock ClarityPrintLogic message string compiling - message types affecting compiled strings
    // These tests check the correct message type string components have been compiled according to the value of node_type in the JSON files
    
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber2_DecisionTrue() {
        //Decision type 1
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(2, printType: .event, true).compiledString, "ABCD        15    N-2     ✅  - Decision event description")
    }
   
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber1_DecisionFalse() {
        //Decision type 1
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(1, printType: .event, true).compiledString, "ABCD        15   !N-1     🔴  - validation FAILED")
    }
    
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber3_NegativeTrue() {
        //(negative (undesired) outcome from a for condition)
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(3, printType: .event, true).compiledString, "ABCD        15    N-3     ⚠️  - validation FAILED")
    }
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber4_PositiveFalse() {
        //(positive (required) outcome from an else condition)
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(4, printType: .event, true).compiledString, "ABCD        15    N-4     ✅  - validation PASSED")
    }
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber5_SwitchCaseNegative() {
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(5, printType: .event, true).compiledString, "ABCD        15    C-5     ⚠️  - x result IS .failure")
    }
    
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber6_SwitchCasePositive() {
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(6, printType: .event, true).compiledString, "ABCD        15    C-6     ✅  - x result IS .success")
    }
    
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber7_GuardFail() {
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(7, printType: .event, true).compiledString, "ABCD        15   !G-7     ⚔️  - x result IS .failure")
    }
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber8_GuardPass() {
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(8, printType: .event, true).compiledString, "ABCD        15    G-8     ☑️  - x result IS .success")
    }
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber10_DoCatchTryFail() {
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(9, printType: .event, true).compiledString, "ABCD        15   !T-9     🎣  - x result IS .failure")
    }
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumber10_ForDoCatchTryPass() {
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(10, printType: .event, true).compiledString, "ABCD        15    T-10    ✅  - x result IS .success")
    }

    // MARK: - 🧪 Tests -  Mock ClarityPrintLogic message string compiling - left justified node numbers
    //
    func test_Decision_ReturnsCorrectFormatting_ForPrintNumbersWithDifferentDigitPowers() {
        
        let printNumberNode2 = 2
        //NB! 35 is being used to test duplicates in the JSON and will not function correctly
        let printNumberNode36 = 36
        let printNumberNode135 = 135
        let printNumberNode1135 = 1135
        let printNumberNode11135 = 11135
        
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(printNumberNode2, printType: .event, true).compiledString, "ABCD        15    N-2     ✅  - Decision event description")
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(printNumberNode36, printType: .event, true).compiledString, "ABCD        15    N-36    ✅  - Decision event description")
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(printNumberNode135, printType: .event, true).compiledString, "ABCD        15    N-135   ✅  - Decision event description")
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(printNumberNode1135, printType: .event, true).compiledString, "ABCD        15    N-1135  ✅  - Decision event description")
        XCTAssertEqual(sutStringFromPrintNumberAndParameters(printNumberNode11135, printType: .event, true).compiledString, "ABCD        15    N-11135 ✅  - Decision event description")
    }
    
    

    
 
    

    
    func test_count() {
        
        let stringToTest = ""
        XCTAssertEqual(stringToTest.count, 0)
        
         
    }
    

    
}
