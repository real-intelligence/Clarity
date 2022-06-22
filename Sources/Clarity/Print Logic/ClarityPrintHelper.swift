//
//  ClarityPrintHelper.swift
//  Clarity
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

import Foundation

/**
A protocol that groups print logic helper methods for use by ClarityPrintLogic in its single method that calculates, formats and prints messages to the console.
 
Default versions of the helper methods are implemented in a protocol extension.
 */
protocol ClarityPrintHelper {
    
}



extension ClarityPrintHelper{
    
    /**
     A method that calculates whether a print number should have its associated message printed to the console according to given parameters.
     
     The function returns the Bool `goForPrint` as an inout parameter.
     
     There are four main task phases to the method:
     1. Initialise the default value for `goForPrint` to `true`.
     2. Initialise and set Bool values from derived specifications used for the verification calculations.
     3. Verify in the negative a sequence of print scenarios that have increasing priority. If any scenario is verified as invalid or 'no go' set `goForPrint` to false.
     4. Evaluate the master override print scenarios from `settings`.  If an evaluation succeeds reset `goForPrint` to the given override value.

     - Parameters:
     - settings: A SettingsManagerService instance. The argument to the parameter is not optional: the instance will have already been guarded against being nil and unwrapped for this method to be called.
     - entityCode:  A String representing the EntityCode value of the EntityLog containing `printNumber` .
     - printNumber:   An Int representing a unique number used as a key to access a specific associated message from a dictionary containing all message data.
     - functionNumber:  An Int representing the function number value as specified for the key `function_number` in the EntityLog JSON file corresponding to the print number.
     - nodeType:  The NodeType case of the Message associated with `printNumber`.
     - goForPrint:  An `inout` parameter that returns whether a print number should have its associated message printed to the console according to specifications calculated from the other given parameters.
     
     - Note
     The parameter `functionNumber` is given a default value to allow its omission in unit tests where not required.
     */
    func goForPrintFromSettings(_ settings: SettingsManagerService,
                                _ entityCode: String,
                                _ printNumber: Int,
                                functionNumber: Int = 0,
                                _ nodeType: NodeType,
                                _ goForPrint: inout Bool) {
        
        ///🍽 1. Set GO for print as the default
        goForPrint = true
        
        ///🍽 2. Initialize and set Bool values from derived specifications
        let isSuppressAllClarityLogs = settings.suppressAllClarityLogs
        let islogIsolatedPrintNumbersOnly = settings.logIsolatedPrintNumbersOnly
        let isPrintNumbersInPrintNumbersArray = settings.isolatedPrintNumbers.contains(printNumber)
        let isLogFunctionNamesOnly = settings.logFunctionNamesOnly
        let isSuppressLogFunctionNames = settings.suppressLogFunctionNames
        let islogAllPrintNumbers = settings.printAllClarityLogs
        let isDisplayNodeSequenceWithoutDescriptions = settings.displayNodeSequenceWithoutDescriptions
        
        let isMessageTypeFunctionName = nodeType == .functionName
        let isValueReporterFunctionName = nodeType == .valueReporter
        let isErrorReporterFunctionName = nodeType == .errorReporter
        
        //Isolated entities
        var isIsolateEntityTrueForOtherEntityCodes = false
        var isIsolateEntityTrueForPrintNumberEntityCode = false
        //Isolated functions
        var isIsolatedFunctionsTrueForOtherEntityCodes = false
        var                             isIsolatedFunctionNumbersContainPrintNumberFunctionNumber = false
        var isIsolatedFunctionsTrueForPrintNumberEntityCode = false
     
        for isolatedEntity in settings.isolatedEntities{
            if isolatedEntity.isolate{
                if isolatedEntity.entityCode != entityCode {
                    isIsolateEntityTrueForOtherEntityCodes = true
                }else{
                    isIsolateEntityTrueForPrintNumberEntityCode = true
                }
            }
        }
        
        for isolatedFunctionEntity in settings.isolatedFunctions{
            if isolatedFunctionEntity.isolate{
                if isolatedFunctionEntity.entityCode != entityCode {
                    isIsolatedFunctionsTrueForOtherEntityCodes = true
                }else{
                    isIsolatedFunctionsTrueForPrintNumberEntityCode = true
                    if isolatedFunctionEntity.isolatedFunctionNumbers.contains(functionNumber) {
                        isIsolatedFunctionNumbersContainPrintNumberFunctionNumber = true
                    }
                }
            }
        }
        
        ///🧮 3-1. Verify non valid print scenarios from specifications
        if islogIsolatedPrintNumbersOnly && settings.isolatedPrintNumbers.count==0{
            Swift.print("❗️ Clarity framework - settings NON-VALID 👺scenario 1")
            Swift.print("SETTINGS ERROR! isolatedPrintNumbers must contain print numbers if logIsolatedPrintNumbersOnly is true")
            goForPrint = false
        }
        
        if isLogFunctionNamesOnly && isSuppressLogFunctionNames{
            Swift.print("❗️ Clarity framework - settings NON-VALID 👺scenario 2")
            Swift.print("ERROR! set EITHER logFunctionNamesOnly OR suppressLogFunctionNames to true NOT both")
            goForPrint = false
        }
        
        ///🧮 3-2. Verify NO GO print scenarios from specifications
        if islogIsolatedPrintNumbersOnly && (isPrintNumbersInPrintNumbersArray == false) && (islogAllPrintNumbers == false) {
            if ClarityDeveloperAlerts.isClarityDeveloperInternalPrintingGONOGO{
                Swift.print("🚫 NO GO print scenario 1 – Print number NOT in the isolated array AND isolating print numbers")
            }
            goForPrint = false
        }
        
        if isLogFunctionNamesOnly && (isMessageTypeFunctionName == false){
            if ClarityDeveloperAlerts.isClarityDeveloperInternalPrintingGONOGO{
                Swift.print("🚫 NO GO print scenario 2 – Print number NOT a functionName NodeType AND logging function names only")
            }
            goForPrint = false
        }
        
        if isSuppressLogFunctionNames && isMessageTypeFunctionName{
            if ClarityDeveloperAlerts.isClarityDeveloperInternalPrintingGONOGO{
                Swift.print("🚫 NO GO print scenario 3 – Print number a functionName NodeType AND supressing logging function names")
            }
            goForPrint = false
        }
        
        if isIsolateEntityTrueForOtherEntityCodes && (isIsolateEntityTrueForPrintNumberEntityCode == false) {
            if ClarityDeveloperAlerts.isClarityDeveloperInternalPrintingGONOGO{
                Swift.print("🚫 NO GO print scenario 4 – Print number NOT in an isolated EntityCode AND is isolating EntityLogs")
            }
            goForPrint = false
        }
        
        if (isIsolatedFunctionsTrueForOtherEntityCodes == true &&                             isIsolatedFunctionNumbersContainPrintNumberFunctionNumber == false) ||                             (isIsolatedFunctionsTrueForPrintNumberEntityCode == true && isIsolatedFunctionNumbersContainPrintNumberFunctionNumber == false) {
            if ClarityDeveloperAlerts.isClarityDeveloperInternalPrintingGONOGO{
                Swift.print("🚫 NO GO print scenario 5 – Print number NOT in an isolated function EntityCode AND is isolating functions")
            }
            goForPrint = false
        }
         
        if isDisplayNodeSequenceWithoutDescriptions &&  (isValueReporterFunctionName || isErrorReporterFunctionName) {
            if ClarityDeveloperAlerts.isClarityDeveloperInternalPrintingGONOGO{
                Swift.print("🚫 NO GO print scenario 6 – Print number is ValueReporter OR  ErrorReporter AND is isolating display node sequence only")
            }
            goForPrint = false
        }
        
        
        
        ///🧮 4. Evaluate master override print scenarios from specifications
        if islogAllPrintNumbers{
            if ClarityDeveloperAlerts.isClarityDeveloperInternalPrintingGONOGO{
                Swift.print("🍀 GO FOR print scenario 1 – printAllClarityLogs checked: override ALL PRIOR no go settings that resolve to false")
            }
            goForPrint = true
        }
        
        if isSuppressAllClarityLogs{
            if ClarityDeveloperAlerts.isClarityDeveloperInternalPrintingGONOGO{
                Swift.print("🚫 NO GO print scenario 6 – suppressAllClarityLogs checked: override ALL other settings that resolve to true")
            }
            goForPrint = false
        }
    }
    
    
    
    /**
     A method that assigns specific values to specific indexes of a String array according to given parameters before returning the array.

     The Swift print API does not provide grid references for printing strings to specific positions in the console. Clarity requires the ability to correctly align related elements in specific columns for multiple message types – strings that consist of different elements.

     Clarity solves this problem by compiling a master composite array of strings that are assembled in the sequential order that they appear across the different message types. Required strings can then be concatenated from specified indexes in the array.

     Each element that can have a different value is allocated a dedicated ‘slot’ represented by an index in the array. If an element is not included in a message type it is either omitted or replaced by a spacer depending on the circumstances.

     Slot positions themselves do not necessarily always align across the different message types once different groups of elements have been removed. The aim is to ensure related elements are placed in specific columns that align vertically.

     This approach is effective and performant.

     - Important
     The method is agnostic about how the array should be used for concatenating the message string. A component value is assigned to every slot position represented in the array whether or not the slot is used in the message string for the print number. It is only important that the correct values are assigned to the components for the context of the message to print.

     The size of the array should remain optimum for the sake of performance. Testing a large array with empty indexes as placeholders had a small but noticeable impact on the speed of unit tests run in total.

     - Note
     The ‘slot’ index numbers are named and stored in a constant file to ensure a single value of truth. This allows the composite to be easily amended in future releases.

     The string character count of certain spacers are calculated from components with strings of variable character count. This includes calculations that ensure some number columns remain right aligned and other component columns remain left aligned.

     There are three main task phases to the method:
      1. Resolve values for the message variable components.
      2. Resolve all spacer component values.
      3. Assign components to the composite array from the resolved values and constants stored in  PrintConstants.

     - Parameters:
          - printNumber: An Int representing a unique number used as a key to access a specific associated message from a dictionary containing all message data.
          - messageToPrint: An EntityLog.Message instance representing the message associated with `printNumber`.
          - settings: A SettingsManagerService instance.
          - formatting: A FormattingManagerService instance.
          - functionName: An optional String representing the function name derived from a `#function` macro argument provided to the relevant public Clarity print overloads.
          - values: An optional parameter for the inclusion of variable values to be printed as part of the message. The parameter can be a single value of any type,  a `Collection` of any type or an instance conforming to the `Error` protocol.

     - Returns:An array of String components that include the composite elements that can be concatenated into a print message for a given print number.
     */
    func compileSequentialComposite(_ printNumber: Int, _ messageToPrint: EntityLog.Message, _ nodeType: NodeType,  _ settings: SettingsManagerService, _ formatting: FormattingManagerService, _ functionName: String? = nil, _ values: Any? = nil) -> [String]{
        
        ///🍽 1. Resolve values for the message variable components.
        let emptyString = pC.emptyString

        // Node number (print number)
        var usedNodeNumber = 0
        let relativeNodeNumber = messageToPrint.nodeNumberWithinFunction
        let absoluteNodeNumber = printNumber
        
        if settings.calculateNodeNumbersRelativeToFunction {
            //Relative
            usedNodeNumber = relativeNodeNumber
        }else{
            usedNodeNumber = absoluteNodeNumber
        }
        
        //Event and effect
        let eventDescription = messageToPrint.eventDescription
        let effectDescription = messageToPrint.effectDescription
        var controlFlowNodeTypeSymbol = emptyString
        var outcomeSymbol = emptyString
        
        //Function
        var functionTypeSymbol = messageToPrint.functionType.rawValue
        let functionType = messageToPrint.functionType
        let functionTypeString = functionType.rawValue
        let functionNumberAlwaysAbsolute = messageToPrint.functionNumberAlwaysCustom
        
        //Function number
        var usedFunctionNumber: Int
        let relativeFunctionNumber = messageToPrint.functionNumberInEntity
        let absoluteFunctionNumber = messageToPrint.functionNumber
        
        if settings.calculateFunctionNumbersRelativeToEntity && !functionNumberAlwaysAbsolute{
            //Relative
            usedFunctionNumber = relativeFunctionNumber
        }else{
            usedFunctionNumber = absoluteFunctionNumber
        }
        
        var plural = false
        if (values is [Any] || values is [String:Any]) && (values as AnyObject).count > 1{
            plural = true
        }
        
        var reporterValuesLabel = plural ? pC.valuesReporterLabel : pC.valueReporterLabel
        let reporterAuxiliaryLabel = plural ? pC.areLabel : pC.isLabel
        
        if nodeType == .errorReporter {
            reporterValuesLabel = pC.errorReporterLabel
        }
        
        let failureCondition = nodeType == .elseCondition || nodeType == .guardFail || nodeType == .catchTryFail
        let failNodeSymbol = failureCondition ? pC.failNodeSymbol : pC.spacer_FailNodeSymbol
        
        symbolsFromFormatting(nodeType, functionType, &controlFlowNodeTypeSymbol, &outcomeSymbol, &functionTypeSymbol)
        
        //Entitycode
        let entityCode = messageToPrint.entityCode
        var spacer_entityCodeDifferential = ""
        let entityCodeCharacterCount = entityCode.symbolSpaceCount()
        let maxEntityCodeCharacterCount = MessageCollator.maxEntityCodeCharacterCount
        
        calculateEntityCodeDifferentialSpacer(entityCodeCharacterCount, maxEntityCodeCharacterCount, &spacer_entityCodeDifferential)
        
        ///🔲 2.  Resolve all spacer component values.
        //Custom user-editable
        let spacer_C1 = String(repeating: pC.singleSpace, count: formatting.kDOb.kA)
        let spacer_C2 = String(repeating: pC.singleSpace, count: formatting.kDOb.kB)
        let spacer_C3 = String(repeating: pC.singleSpace, count: formatting.kDOb.kC)
        let spacer_C4 = String(repeating: pC.singleSpace, count: formatting.kDOb.kD)
        
        var spacer_LJustifyAdjusterFromUsedNodeNumberPlaces = emptyString
        
        var spacer_RJustifyAdjusterFromAbsoluteNodeNumberPlaces = emptyString
        var spacer_AdjustmentForFunctionNumberPlaces = emptyString
        
        let totalPlacesInNodeNumber =  totalPlaces(from: usedNodeNumber)
        let totalPlacesInRelativeNodeNumber =  totalPlaces(from: relativeNodeNumber)
        let totalPlacesInFunctionNumber =  totalPlaces(from: usedFunctionNumber)
        
        let totalPlacesInAbsoluteNodeNumber =  totalPlaces(from: absoluteNodeNumber)
        
        var spacer_LJustifyAdjusterFromAbsoluteNodeNumberPlaces = emptyString
        
        let functionSymbolCount = functionTypeSymbol.symbolSpaceCount()
        let functionSymbolSpacer =  String(repeating: pC.singleSpace, count: functionSymbolCount )

        spacerFromInversePlaces(totalPlacesInFunctionNumber, &spacer_AdjustmentForFunctionNumberPlaces)
        spacerFromInversePlaces(totalPlacesInNodeNumber, &spacer_LJustifyAdjusterFromUsedNodeNumberPlaces)
        spacerFromInversePlaces(totalPlacesInRelativeNodeNumber, &spacer_RJustifyAdjusterFromAbsoluteNodeNumberPlaces)
        spacerFromInversePlaces(totalPlacesInAbsoluteNodeNumber, &spacer_LJustifyAdjusterFromAbsoluteNodeNumberPlaces)
        
        let spacer_RJustifyAdjusterFromFunctionElements = spacer_AdjustmentForFunctionNumberPlaces + pC.spacer_F1 + functionSymbolSpacer + pC.spacer_FType
        
        /// 🪢 3. Assign components to the composite array.
        var stringComposite = [String](repeating: "", count: 31)
       
        stringComposite[pC.index_C1] = spacer_C1
        stringComposite[pC.index_EntityCode] = entityCode
        stringComposite[pC.index_EntityCodeDifferential] = spacer_entityCodeDifferential
        stringComposite[pC.index_RJustifyAdjusterFromFunctionElements] = spacer_RJustifyAdjusterFromFunctionElements
        stringComposite[pC.index_F1] = pC.spacer_F1
        stringComposite[pC.index_FunctionTypeSymbol] = functionTypeSymbol
        stringComposite[pC.index_FunctionTypeString] = functionTypeString
        stringComposite[pC.index_AdjustmentForFunctionNumberPlaces] = spacer_AdjustmentForFunctionNumberPlaces
        stringComposite[pC.index_C2] = spacer_C2
        stringComposite[pC.index_UsedFunctionNumber] = String(usedFunctionNumber)
        stringComposite[pC.index_G1] = pC.spacer_G1
        stringComposite[pC.index_F2] = pC.spacer_F2
        stringComposite[pC.index_C3] = spacer_C3
        stringComposite[pC.index_FailNodeSymbol] = failNodeSymbol
        stringComposite[pC.index_FailNodeSymbolSpacer] = pC.spacer_FailNodeSymbol
        stringComposite[pC.index_ControlFlowNodeTypeSymbol] = controlFlowNodeTypeSymbol
        stringComposite[pC.index_Linker_NodeNumber] = pC.linker_NodeNumber
        stringComposite[pC.index_FunctionName] = functionName ?? ""
        stringComposite[pC.index_UsedNodeNumber] = String(usedNodeNumber)
        stringComposite[pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces] = spacer_LJustifyAdjusterFromUsedNodeNumberPlaces
        stringComposite[pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces] = spacer_LJustifyAdjusterFromAbsoluteNodeNumberPlaces
        stringComposite[pC.index_AbsoluteNodeNumber] = String(absoluteNodeNumber)
        stringComposite[pC.index_PostAbsoluteNodeNumber] = pC.spacer_PostAbsoluteNodeNumber
        stringComposite[pC.index_C4] = spacer_C4
        stringComposite[pC.index_OutcomeSymbol] = outcomeSymbol
        stringComposite[pC.index_Linker_EventDescription] = pC.linker_EventDescription
        stringComposite[pC.index_ReporterValuesLabel] = reporterValuesLabel
        stringComposite[pC.index_EventDescription] = eventDescription //Column alignment point for effectLabel and reporterAuxiliaryLabel
        stringComposite[pC.index_ReporterAuxiliaryLabel] = reporterAuxiliaryLabel
        stringComposite[pC.index_EffectLabel] = pC.effectLabel
        stringComposite[pC.index_EffectDescription] = effectDescription
        
        return stringComposite
    }
    
    
    // MARK:   🦮🦮🦮  Composite helpers
    /**
     A method that resolves the NodeType of a message from the given parameters and returns the NodeType case.
     
     This method divides NodeTypes into three distinct categories: control nodes, function name or values depending on the presence of particular arguments.
     
     If a print statement contains an argument for either the `functionName` or `values` parameter any control node NodeType set for the print number will be overridden. The message will then be formatted as a function name or a value reporter depending on the argument regardless of the  message `nodeType`  property derived from JSON.


     This method checks for the existence of an argument for either the `functionName` or `values` parameter of the print statement and resolves the NodeType accordingly.

     There are two main task phases to the method:
       1. Evaluate `functionName`: if the argument is nil or a blank string set the node type case to the value of the message `nodeType`  property derived from JSON. Otherwise set the node type case to `.functionName`.
       2. Evaluate `values`: if the argument is not nil and it conforms to the `Error` protocol overwrite the node type case to `.errorReporter` otherwise overwrite the node type case to `.valueReporter`.
     - Note
     The `functionName` and `values` parameters will never both have arguments in the same call.

     - Parameters:
          - messageToPrint: An EntityLog.Message instance representing the message associated with a print number.
          - functionName: An optional String representing the function name derived from a `#function` macro argument provided to the relevant public Clarity print overloads.
          - values: An optional parameter for the inclusion of variable values to be printed as part of the message. The parameter can be a single value of any type,  a `Collection` of any type or an instance conforming to the `Error` protocol.
     - Returns: The NodeType case of `messageToPrint`.
     */
    func resolveNodeTypeGroup(_ messageToPrint: EntityLog.Message, _ functionName: String? , _ values: Any?) -> NodeType {

        var nodeType = (functionName == nil || functionName == "") ? (messageToPrint.nodeType) : .functionName

        if values != nil  {
            if values is Error{
                nodeType = .errorReporter
            }else{
                nodeType = .valueReporter
            }
        }
        return nodeType
    }
    
    /**
     A method that returns as inout parameters the control flow node symbols and function type symbols to include in a message string according to the given parameters.
     
     The method switches on the incoming NodeType and FunctionType case parameter arguments and assigns symbol values derived from the Formatting JSON data to the `inout` parameters.
     
     - Note
     This method divides NodeTypes into three distinct categories: control flow nodes, outcome types or function types depending on the column the symbol is placed.
     
     If the `nodeType` parameter is a `functionName` case the two Switch statements on `nodeType` will default and the `inout` parameters will remain unchanged as empty strings. The Switch statement on `functionType` will assign a value to `functionTypeSymbol` on all calls (all Message instances have a FunctionType if not a function type symbol). If the `nodeType` parameter is not a `functionName` case the value will be ignored by the method that concatenates message strings.
     
     - Parameters:
       - nodeType: A `NodeType` case.
       - functionType: A `FunctionType` case.
       - controlFlowNodeSymbol: A String `inout` parameter that returns the control flow node symbol that represents the incoming `nodeType` argument.
       - outcomeTypeSymbol: A String `inout` parameter that returns the 'semantic outcome' symbol that represents the incoming `nodeType` argument.
       - functionTypeSymbol: A String `inout` parameter that returns the function 'type' symbol that represents the incoming `functionType` argument.
     */
    func symbolsFromFormatting(_ nodeType: NodeType, _ functionType: FunctionType, _ controlFlowNodeSymbol: inout String, _ outcomeTypeSymbol: inout String,  _ functionTypeSymbol: inout String) {

        if let formatting = ClarityActivator.formatting{
            switch nodeType{
            case .elseCondition, .ifTrueCondition, .elseConditionPositiveOutcome, .ifTrueConditionNegativeOutcome:
                controlFlowNodeSymbol = formatting.kBOb.kA
            case .caseTruePositiveOutcome , .caseTrueNegativeOutcome:
                controlFlowNodeSymbol = formatting.kBOb.kB
            case .guardFail , .guardPass:
                controlFlowNodeSymbol = formatting.kBOb.kC
            case .catchTryFail, .doTryPass:
                controlFlowNodeSymbol = formatting.kBOb.kD
            case .valueReporter:
                controlFlowNodeSymbol = formatting.kBOb.kE
            case .errorReporter:
                controlFlowNodeSymbol = formatting.kBOb.kF
                
            default:
                break
            }
            
            switch nodeType{
            case .ifTrueCondition:
                outcomeTypeSymbol = formatting.kAOb.kA
            case .elseCondition:
                outcomeTypeSymbol = formatting.kAOb.kB
            case .ifTrueConditionNegativeOutcome:
                outcomeTypeSymbol = formatting.kAOb.kC
            case .elseConditionPositiveOutcome:
                outcomeTypeSymbol = formatting.kAOb.kD
            case .caseTruePositiveOutcome:
                outcomeTypeSymbol = formatting.kAOb.kE
            case .caseTrueNegativeOutcome :
                outcomeTypeSymbol = formatting.kAOb.kF
            case .guardPass:
                outcomeTypeSymbol = formatting.kAOb.kG
            case .guardFail:
                outcomeTypeSymbol = formatting.kAOb.kH
            case .doTryPass:
                outcomeTypeSymbol = formatting.kAOb.kI
            case .catchTryFail:
                outcomeTypeSymbol = formatting.kAOb.kJ
            case .valueReporter:
                outcomeTypeSymbol = formatting.kAOb.kK
            case .errorReporter:
                outcomeTypeSymbol = formatting.kAOb.kL
                
            default:
                break
            }
            
            switch functionType {
            case .initialiser:
                functionTypeSymbol = formatting.kCOb.kA
            case .customFunc:
                functionTypeSymbol = formatting.kCOb.kB
            case .systemOverride:
                functionTypeSymbol = formatting.kCOb.kC
            case .actionMethod:
                functionTypeSymbol = formatting.kCOb.kD
            case .delegateMethod:
                functionTypeSymbol = formatting.kCOb.kE
            case .datasourceMethod:
                functionTypeSymbol = formatting.kCOb.kF
            case .computedVar:
                functionTypeSymbol = formatting.kCOb.kG
            case .protocolExtensionMethod:
                functionTypeSymbol = formatting.kCOb.kH
            }
        }
    }
    
    
    
/**
     A method that takes an Int value and returns its total number of digit places as an Int.

     There are two main task phases to the method:
        1. If the value of integer is 0 return the value 1. Zero is not a valid argument for calculating log 10 but zero is a possible value of an integer.
        2. Calculate the number of digit places in the number using the `log10(_:) ` function. This requires converting `integer` into a `Double` and adding 1 to the result ( the log 10 of a single digit equates to 0).
        3. Convert the `Double` back into an `Int` for the return.

     - Note
        This method is a candidate for converting into an extension method on Int.
 
     - Parameters:
          - integer: An Int representing the number that requires its number of digit places calculated.
     - Returns: An Int value that is the total number of digit places in the `integer` parameter .
     */
    func totalPlaces(from integer:Int) -> Int{

        if integer == 0 {
            return 1
        }
        let totalPlacesDouble = log10(Double(integer)) + 1
        guard let totalPlacesInt = Int(doubleValue: totalPlacesDouble) else { return 0 }
        return totalPlacesInt
    }
    
    
    
    /**
        A method that calculates the inverse number of digit places in a number based on a maximum of 5 digit places and a minimum of 1 digit place. It then returns a blank spacer string of the calculated length as an inout parameter.
         
        The inverse number is assigned to the parameter `count` of the String initialiser `init(repeating: count:)` with a single space String assigned to the parameter `repeating` to create a blank spacer string of the specified length.

         - Note
        The returned spacer is used to compile strings containing column elements that are correctly justified based on the variable content of other elements adjacent to them in the string.

        The basis of a maximum of 5 digit places is predicated on the notion that a client project using Clarity would never require the use of a maximum function number or print number exceeding 99,999.
              
        A future release could add a `max` parameter to this method allowing for an unlimited number of function and print numbers usable in Clarity (although this would be an improbable requirement).

         - Parameters:
              - integer: An Int representing a number that requires the inverse number of digit places calculated.
              -  inverseDigitPlacesSpacer: A String `inout` parameter for the return of a blank spacer that has a character count equal to the total inverse number of digit places in the `integer` parameter based on a maximum of 5 digit places.
         */
    func spacerFromInversePlaces(_ integer: Int?, _ inverseDigitPlacesSpacer: inout String) {
        
        var digits = Int()
        
        switch integer {
        case 1:
            digits = 5
        case 2:
            digits = 4
        case 3:
            digits = 3
        case 4:
            digits = 2
        case 5:
            digits = 1
        default:
            break
        }
        inverseDigitPlacesSpacer = String(repeating: pC.singleSpace, count: digits)
    }
    
    
    
 /**
     A method that calculates the difference between the maximum character count of all EntityLog EntityCodes and a given EntityCode count. It then returns a blank spacer string of the calculated length as an inout parameter.

     - Note
     The returned differential spacer is applied to all message string types in the composite slot position following the slot for the `EntityCode` value. All following components in the message will be moved forward by the count of the differential spacer and thereby align with messages containing an `EntityCode` with a different character count. If a message belongs to an `EntityLog` with an `EntityCode` that is equal to the maximum count the differential spacer will have the value of an empty string (and not be offset forward).

     - Parameters:
          - characterCount: An Int representing the character count of a message `EntityCode` .
          - maxEntityCodeCharacterCount: An Int representing the maximum character count of all EntityLog Entity Codes in a client application.
          - entityCodeDifferentialSpacer: A String `inout` parameter for the return of a blank spacer that has a character count equal to the difference between `maxEntityCodeCharacterCount` and `characterCount`.

     */
    func calculateEntityCodeDifferentialSpacer(_ characterCount: Int, _ maxEntityCodeCharacterCount: Int, _ entityCodeDifferentialSpacer: inout String) {
         
        if characterCount != maxEntityCodeCharacterCount {
            let differential = maxEntityCodeCharacterCount - characterCount
            entityCodeDifferentialSpacer = String(repeating: pC.singleSpace, count: differential)
        }
    }
    
    
    /**
         A method that returns an empty spacer that has a character count equal to the length of a message string up to the beginning of the slot position for a message event description (the readout).
             
         The method takes a message component composite array as an argument for use to calculate the readout character count.
             
         The returned empty spacer is used to ensure correct alignment between the message event description readout and subsequent readouts on following lines in the console (the effect description and/or value reports).

         - Important
         Apple symbols return a character count value of 1 but use the space of two characters in the console. A client application can specify custom values for symbols: these could be set as ordinary String characters or Apple symbols therefore this method uses the extension method `symbolSpaceCount()` to calculate the correct value from the JSON Formatting data.

         There are six main task phases to the method:
            1. Copy the incoming composite argument to two internal variables: this is required for the calculation of the symbol character count. The array extension method `arrayFromIndexes(_:) is a mutating function that changes the indexes of components in the array as a result of removing non-used elements: calling it twice on the same array would return the wrong components and / or produce an 'out of bounds' error.
            2. Get the state of the Bool `displayNodePrintNumberWhenUsingRelativeNumbering`: this is required for the conditional inclusion of some component indexes.
            3. Create a union of the IndexSet constants containing all required component indexes.
            4. Use the IndexSets to filter both composite string array local variables to contain only the required component indexes using the array extension `arrayFromIndexes(_:)`.
            5. Calculate the total string character count for all strings in both composite arrays.
            6. Return a blank spacer string with a character count equal to the combined total.

         - Note
           `functionTypeSymbol` is accounted for by the constant `IndexSet` `defaultReadoutSpacers` via its character count included in `spacer_RJustifyAdjusterFromFunctionElements`.

         - Parameters:
              - composite: An array of Strings that include composite elements that can be concatenated into message strings for a single print number.
              - settings: A SettingsManagerService instance.

         - Returns: An empty String that has a character count equal to the length of a main message string up to the beginning of the slot position for a message event description readout.
         */
    
    func readoutSpacer(fromComposite composite: [String], _ settings: SettingsManagerService) -> String {

        // copy local composites
        var composite = composite
        var compositeForSymbols = composite
        
        // get setting
        let displayRelativePrintNumber = settings.displayNodePrintNumberWhenUsingRelativeNumbering
        
        // get IndexSets (non symbols)
        let customSpacers = pC.customSpacerIndexes
        let otherSpacers: IndexSet   = pC.defaultReadoutSpacers
        let components: IndexSet     = pC.defaultReadoutComponents
        let conditionalComponents = pC.absoluteNodeIndexes
        // get IndexSet (symbols)
        let userSettableSymbolReadoutComponentIndexes: IndexSet = pC.userSettableSymbolReadoutComponents
        
        // resolve required (non symbols) Indexset
        var requiredNonUserSymbolReadoutComponentIndexes: IndexSet = []
        requiredNonUserSymbolReadoutComponentIndexes.formUnion(customSpacers)
        requiredNonUserSymbolReadoutComponentIndexes.formUnion(otherSpacers)
        requiredNonUserSymbolReadoutComponentIndexes.formUnion(components)
        
        if displayRelativePrintNumber{
            requiredNonUserSymbolReadoutComponentIndexes.formUnion(conditionalComponents)
        }
        //Filter arrays to only include required indexes
        composite.arrayFromIndexes(requiredNonUserSymbolReadoutComponentIndexes)
        compositeForSymbols.arrayFromIndexes(userSettableSymbolReadoutComponentIndexes)
        
        //Calculate spacer counts
        let spacerCount = composite.map{$0.count}.reduce(0, +)
        let spacerCountForSymbols = compositeForSymbols.map{$0.symbolSpaceCount()}.reduce(0, +)
        
        //Create string and return
        return String(repeating: pC.singleSpace, count: spacerCount+spacerCountForSymbols)
    }
    
    // MARK:   🎁  Compilation
    /**
     A method that takes a String array of message elements for a single print number and concatenates a select composite within the array into message strings for printing to the console according to the given parameters. It then returns the message strings as `inout` parameters.
     
     The method also returns a Bool as an `inout` parameter that signifies whether there is a printable value for the effect description readout message string.
     
     The method sets relevant parameters required by the method `compileStringForPrintType(_:withComposite:)` that handles the task of concatenating the message string from selected composites.
     
     There are four main task phases to the method:
     1. Set the message `PrintType` according to a combination of its `NodeType` and relevant user settings. If the `NodeType` case is `.valueReporter` or `.errorReporter` but has no value the `PrintType` is set to the appropriate reporter case: this case occurs when the client application has set the print number `node_type` JSON key to 11 or 12 but not supplied a `values` argument to the print statement with the intention of reporting a comment.
     2. If the `NodeType` is equal to the case `.valueReporter` set the message `PrintValueType`  according to a combination of its value type and relevant user settings passing the value as an associated value. If the `NodeType` case is `.errorReporter` and the parameter  `values` is an `Error`  the `PrintValueType` is set to `.singleValue(single:)` with the result of calling `localizedDescription` on the error passed as the associated value.
     3. For all conditional node cases (non function name or value cases) set `printEffectString` to true and set `compiledStringForEffectPrint` by making an additional call to `compileStringForPrintType(_:withComposite:)` passing in the appropriate effect `PrintType` case along with the `composite` parameter argument.
     4. Set `compiledStringForPrint` by calling  `compileStringForPrintType(_:withComposite:)` passing in the `PrintType` case along with the `composite` parameter argument.

     - Parameters:
         - composite: An array of Strings that includes the composite elements that can be concatenated into a print message for a single print number.
         - nodeType: A `NodeType` case.
         - settings: A SettingsManagerService instance.
         - values: An optional parameter for the inclusion of variable values to be printed as part of the message. The parameter can be a single value of any type,  a `Collection` of any type or an instance conforming to the `Error` protocol.
         - printValueType: A `PrintValueType` case.
         - compiledStringForPrint: An `inout` String for the return of the main message line compiled from selected elements in `composite`.
         - printEffectString: An `inout` Bool that signifies whether `compiledStringForEffectPrint` holds a value that should be printed to the console.
         - compiledStringForEffectPrint: An `inout` String for the return of a secondary message line for effect readouts compiled from selected elements in `composite`.
     */
    func compileStringsFromComposite(_ composite: [String], _ nodeType: NodeType, _ settings: SettingsManagerService, _ values: Any?, _ printValueType: inout PrintValueType, _ compiledStringForPrint: inout String,   _ printEffectString: inout Bool, _ compiledStringForEffectPrint: inout String) {
        
        var printType:  PrintType = .none
        
        let displayNodeNumbersWhenUsingRelativeNumbering = settings.displayNodePrintNumberWhenUsingRelativeNumbering
        
        switch nodeType {
        case .valueReporter:
            if let dictionary = values as? Dictionary<AnyHashable, Any> {
                printType = displayNodeNumbersWhenUsingRelativeNumbering ? .valuesDictionaryDisplayPrintNumber: .valuesDictionary
                printValueType = .dictionaryValue(dictionary: dictionary)
            }else
            if let array = values as? Array<Any> {
                printType = displayNodeNumbersWhenUsingRelativeNumbering ? .valuesArrayDisplayPrintNumber: .valuesArray
                printValueType = .arrayValue(array: array)
            }else
            if let set = values as? Set<AnyHashable> {
                printType = displayNodeNumbersWhenUsingRelativeNumbering ? .valuesSetDisplayPrintNumber: .valuesSet
                printValueType = .setValue(set: set)
            }else
            if let value = values {
                printType = displayNodeNumbersWhenUsingRelativeNumbering ? .valueSingleDisplayPrintNumber: .valueSingle
                printValueType = .singleValue(single: value)
            }else{
                printType = displayNodeNumbersWhenUsingRelativeNumbering ? .reporterDisplayPrintNumber: .reporter
                printValueType = .none
            }
            
        case .errorReporter:
            if let value = values as? Error {
                printType = displayNodeNumbersWhenUsingRelativeNumbering ? .errorReporterDisplayPrintNumber: .errorReporter
                printValueType = .singleValue(single: value.localizedDescription)
            }else{
                printType = displayNodeNumbersWhenUsingRelativeNumbering ? .reporterDisplayPrintNumber: .reporter
                printValueType = .none
            }

        case .functionName:
            printType =  .functionName

        default:
            if settings.displayNodeSequenceWithoutDescriptions {
                printType = .nodeOnly
                //nodeOnly has no effect message readout -  only print main line message.
            }else{
                //Compile for the secondary line effect message readout
                printType = displayNodeNumbersWhenUsingRelativeNumbering ? .eventDisplayPrintNumber: .event
                printEffectString = true
                compiledStringForEffectPrint = compileStringForPrintType(displayNodeNumbersWhenUsingRelativeNumbering ? .effectDisplayPrintNumber: .effect, withComposite:composite)
            }
        }
        //Compile for all main line messages
        compiledStringForPrint = compileStringForPrintType(printType, withComposite:composite)
    }
    
    
    
    /**
     A method that takes a String array of message elements for a single print number and returns a select composite within the array concatenated into a single message string according to the given `PrintType`.

     There are four main task phases to the method:
        1.  Get `IndexSet` constants of specific component indexes that have been sorted into related groups.
        2. Create unions between specific `IndexSet` constants in a first phase of building the required indexes for each `PrintType`.
        3. Switch on `printType`: create additional unions between relevant index sets and use them as arguments to filter the composite string array so that it only contains the required components for each `PrintType` case.
        4. Concatenate and return the filtered array.
     
     - Note
         The `IndexSet` for the effect message only includes component slots for readout values: the spacer is calculated separately by another method.

     - Parameters:
        - printType: A PrintType case.
        - initialComposite: An array of Strings that includes composite elements that can be concatenated into print messages for a single print number.
     
     - Returns: A single String concatenated from a select composite of string elements that represent a message for the associated print number.
     */
    func compileStringForPrintType(_ printType:PrintType, withComposite initialComposite:[String])-> String{
        
        var composite = initialComposite
        
        let customSpacers          = pC.customSpacerIndexes
        let absoluteNodeIndexes    = pC.absoluteNodeIndexes
        var valueReportIndexes     = pC.valueReportIndexes
        var defaultMessageIndexes  = pC.defaultMessageIndexes
        var functionNameIndexes    = pC.functionNameIndexes
        let effectIndexes          = pC.effectIndexes
        var nodeOnlyIndexes        = pC.nodeOnlyIndexes
        var reporterIndexes        = pC.reporterIndexes
        
        defaultMessageIndexes.formUnion(customSpacers)
        functionNameIndexes.formUnion(customSpacers)
        nodeOnlyIndexes.formUnion(customSpacers)
        reporterIndexes.formUnion(customSpacers)
        valueReportIndexes.formUnion(defaultMessageIndexes)
        
        switch printType {
        case .event:
            composite.arrayFromIndexes(defaultMessageIndexes)
        case .eventDisplayPrintNumber:
            defaultMessageIndexes.formUnion(absoluteNodeIndexes)
            composite.arrayFromIndexes(defaultMessageIndexes)
        case .valuesDictionary, .valuesArray, .valuesSet, .valueSingle , .errorReporter:
            composite.arrayFromIndexes(valueReportIndexes)
        case .valuesDictionaryDisplayPrintNumber, .valuesArrayDisplayPrintNumber,
             .valuesSetDisplayPrintNumber,
             .valueSingleDisplayPrintNumber, .errorReporterDisplayPrintNumber:
            valueReportIndexes.formUnion(absoluteNodeIndexes)
            composite.arrayFromIndexes(valueReportIndexes)
        case .functionName:
            composite.arrayFromIndexes(functionNameIndexes)
        case .effect, .effectDisplayPrintNumber:
            composite.arrayFromIndexes(effectIndexes)
        case .nodeOnly:
            composite.arrayFromIndexes(nodeOnlyIndexes)
        case .reporter:
            composite.arrayFromIndexes(reporterIndexes)
        case .reporterDisplayPrintNumber:
            reporterIndexes.formUnion(absoluteNodeIndexes)
            composite.arrayFromIndexes(reporterIndexes)
        default:
            break
        }
        return composite.joined()
    }
    
    
    
    // MARK: -  🖨  Print string(s) and values
    /**
     A method that takes a generic collection of value items and a blank spacer string. It uses arguments to these parameters to print value messages to the console.

     The inclusion of the given readout spacer ensures that the value strings are always aligned with other message readouts.
     
     Collection values are printed as a list: dictionaries list each key-value pair, arrays list values by index, sets list values in random order.

     There are three main task phases to the method:
     1. The collection is evaluated to identify its type.
     2. The collection is iterated according to its type so that the relevant string can be built and printed to the console.
     3. Each message is appended into a String array for the return value.
     
     - Note
     The value messages are appended into a String array that is returned for testing purposes only.
     - Parameters:
         - collection: A generic collection that conforms to `Sequence` that contains values to be printed to the console.
         - readOutSpacer: An empty String that has a character count equal to the length of a main message string up to the beginning of the slot position where a values message should begin.
     
     - Returns: An array of value message instances: one element for each value in the collection.
     */

    @discardableResult
    func printCollectionValues<T:Sequence>(_ collection: T, withReadOutSpacer readOutSpacer: String )-> [String] {
        var output = [String]()
        
        if T.self == Dictionary<AnyHashable,Any>.self {
            let values = collection as! [AnyHashable : Any]
            
            for (key,value) in values {
                let valueMessage = "\(readOutSpacer)\(key):\(value)"
                Swift.print(valueMessage)
                output.append(valueMessage)
            }
        }
        
        if T.self == Array<Any>.self {
            let values = collection as! [Any]
            for value in values {
                let valueMessage = "\(readOutSpacer)\(value)"
                Swift.print(valueMessage)
                output.append(valueMessage)
            }
        }
        if T.self ==  Set<AnyHashable>.self {
            let values = collection as! Set<AnyHashable>
            for value in values {
                let valueMessage = "\(readOutSpacer)\(value)"
                Swift.print(valueMessage)
                output.append(valueMessage)
            }
        }
        return output
    }
    
    
    /**
     A method that takes a single value of any type and a blank spacer string. It uses arguments to these parameters to print a value message to the console.

     The inclusion of the given readout spacer ensures that the value string is always aligned with other message readouts.
     
     - Note
     The value message is returned for testing purposes only.

     - Parameters:
         - singleValue: A single value of type  `Any` to be printed to the console.
         - readOutSpacer: An empty String that has a character count equal to the length of a main message string up to the beginning of the slot position where a value message should begin.
     
     - Returns: A String value message.
     */
    @discardableResult
    func printValue(_ singleValue: Any, withReadOutSpacer readOutSpacer: String) -> String{
        
        let valueMessage = "\(readOutSpacer)\(singleValue)"
        Swift.print(valueMessage)
        return valueMessage
    }
    
    
    /**
     A method that prints an alert and advice message when a Clarity statement is called in a client application that passes a print number argument not listed in any EntityLog JSON file.

     This alert will only be printed if the client application user setting  `alertOrphanedPrintNumbersDetected` is set to true.
     
        - Parameters:
            - printNumber: An Int representing the print number that has no associated EntityLog JSON file.
     */
     func printAlertForDetectedOrphanPrintNumber(_ printNumber: Int) {
       
        Swift.print("⚠️⚠️⚠️ Clarity framework ORPHANED PRINT NUMBER ALERT -⚠️⚠️⚠️")
        Swift.print("NO MESSAGE TO PRINT for print number \(printNumber)" )
        Swift.print("\nCheck that the print number in your source code is the\nnumber intended to reference an EntityLog JSON file")
        Swift.print("\nAlternatively check that the EntityLog JSON file that\nprint number \(printNumber) references has not been deleted.\n")
    }
}




