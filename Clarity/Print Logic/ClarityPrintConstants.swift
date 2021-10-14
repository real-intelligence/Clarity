//
//  ClarityPrintConstants.swift
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

/// A shorthand `typealias` convenience for the `PrintConstants` namespace.
typealias pC = PrintConstants

/// An Enum namespace for constants that are used across different entities in the Clarity framework.
enum PrintConstants {
    //Elements
    /// A Unicode string value that has zero length.
    static let emptyString = String()
    
    /// A Unicode string value that is a single space separator.
    static let singleSpace = "\u{0020}"
    
    /// A Unicode string value that is a double space separator.
    static let doubleSpace = String(repeating: singleSpace, count: 2)
    
    /// A Unicode string value that is a triple space separator.
    static let tripleSpace = String(repeating: singleSpace, count: 3)
    
    /// A Unicode string value that is a double quadruple separator.
    static let quadrupleSpace = String(repeating: singleSpace, count: 4)
    
    //Special symbols
    /**
      A Unicode string value that is an exclamation mark.
      
      This value is currently used as a symbol to represent all types of conditional `else` clauses and the `catch` block of `do-catch` statements in event message strings.
     
      A future version of Clarity will have an option to designate a single node number for both clauses of conditional `if` statements that contain `else` clauses. When the option is selected the symbol will appear adjacent to a node number to signify an  `else` clause for that node.
     */
    static let failNodeSymbol = "!"
    
    //Labels
    /// A Unicode string representing the label of an effect message.
    static let effectLabel = "Effect:"
    
    /**
     A Unicode string representing the single value label of a value reporter message.
     
     - Note:
      A single space suffix is concatenated at the end of the label rather than allocated its own slot in the composite array. This is for array optimisation purposes as well as for code semantics: the space is part of a sentence rather than acting as a column separator.
     */
    static let valueReporterLabel = "Value for variable"+singleSpace
    
    /**
     A Unicode string representing the plural values label of a value reporter message.
     
     - Note:
      A single space suffix is concatenated at the end of the label rather than allocated its own slot in the composite array. This is for array optimisation purposes as well as for code semantics: the space is part of a sentence rather than acting as a column separator.
     */
    static let valuesReporterLabel = "Values for variables"+singleSpace
    /**
     A Unicode string representing the label of an error reporter message.
     
     - Note:
      A single space suffix is concatenated at the end of the label rather than allocated its own slot in the composite array. This is for array optimisation purposes as well as for code semantics: the space is part of a sentence rather than acting as a column separator.
     */
    static let errorReporterLabel = "Error for"+singleSpace
    
    
    
    /**
     A Unicode string representing the singular linking verb label for a reporter message.
     
     - Note:
      A single space prefix is concatenated at the beginning of the label rather than allocated its own slot in the composite array. This is for array optimisation purposes as well as for code semantics: the space is part of a sentence rather than acting as a column separator.
     */
    static let isLabel =  singleSpace+"is:"
    
    /**
     A Unicode string representing the plural linking verb label for a reporter message.
     
     - Note:
      A single space prefix is concatenated at the beginning of the label rather than allocated its own slot in the composite array. This is for array optimisation purposes as well as for code semantics: the space is part of a sentence rather than acting as a column separator.
     */
    static let areLabel = singleSpace+"are:"
   
    //Linkers
    
    /**
     A Unicode string representing a linker symbol between the message node 'SKU style' information section of an event message and its description readout.
     
     - Note:
     A double space prefix is concatenated at the beginning of the label and a single space suffix is concatenated at the end of the label. These spaces act as column separators but are not allocated slots in the composite array for optimisation purposes. They are also part of a section that would lose efficacy as a linker if spaced further apart: there are no custom spacers in these positions for this reason.
     */
    static let linker_EventDescription = doubleSpace+"-"+singleSpace
    
    /// A Unicode string representing a linker symbol between a control flow node symbol and a node number of event and reporter messages.
    static let linker_NodeNumber = "-"
    
    //Spacers
    //  - Node only
    /// A Unicode string representing a general column spacer between function numbers and the node symbol section of control flow messages.
    static let spacer_G1 = tripleSpace
    
    /**
     A Unicode string representing a spacer that enables the fail node symbol to appear in the slot that is directly before other components of the node symbol section.
         
     - Note:
     If a message contains the fail node symbol the spacer is placed in the composite slot index `index_FailNodeSymbolSpacer`. If a message does not contain the fail node symbol the spacer is placed in both the fail node symbol slot `index_FailNodeSymbol` and the dedicated slot for the spacer `index_FailNodeSymbolSpacer`.

     The spacer length is calculated from the fail node symbol character count so the two slots will always be the same length.
          
     This arrangement maintains a left alignment of the other components of the node symbol section in one column.
     
     - Important:
     If the fail node symbol is ever made user customisable or changed to an Apple symbol the spacer length would need to be calculated using the method `symbolSpaceCount()`.
 */
    static let spacer_FailNodeSymbol = String(repeating: singleSpace, count: failNodeSymbol.count)
    
    /// A Unicode string representing a column spacer between the print number sometimes displayed when relative node numbering is used and the outcome symbol of an event message.
    static let spacer_PostAbsoluteNodeNumber = doubleSpace

    // - Functions
    /// A Unicode string representing a column spacer between the entity code and the function symbol section of a function name message.
    static let spacer_F1 = singleSpace
    /// A Unicode string representing a column spacer between the function number and function name for a function name message.
    static let spacer_F2 = quadrupleSpace
    /**
     A Unicode string representing a spacer that compensates for the function type symbol when calculating right justification between the entity code and the raw value of `FunctionType` for control flow messages.
     
     - Important:
     If the raw value of `FunctionType` is ever made user customisable or changed to an Apple symbol the spacer length would need to be calculated using the method `symbolSpaceCount()`.

     - Note:
     `FunctionType` should not be confused with `FunctionTypeSymbols` that are user customisable.
     */
    static let spacer_FType = singleSpace
    
    // Sequential print slot indexes
    /// An `IndexSet` containing the indexes of custom editable spacers within the message string composite  array.
    static let customSpacerIndexes:IndexSet   = [pC.index_C1,
                                                 pC.index_C2,
                                                 pC.index_C3,
                                                 pC.index_C4]
    
    /// An `IndexSet` containing the indexes of default message components within the message string composite array.
    static var defaultMessageIndexes:IndexSet = [pC.index_EntityCode,
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
                                                 pC.index_EventDescription]
    
    /// An `IndexSet` containing the indexes of print number (absolute node number) message components within the message string composite array.
    static let absoluteNodeIndexes:IndexSet   = [pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces,
                                                 pC.index_AbsoluteNodeNumber,
                                                 pC.index_PostAbsoluteNodeNumber]
    
    
    /// An `IndexSet` containing the indexes of value reporter message components within the message string composite array.
    static let valueReportIndexes:IndexSet    = [pC.index_ReporterValuesLabel,
                                                 pC.index_ReporterAuxiliaryLabel]
    
    
    /**
     An `IndexSet` containing the indexes of reporter message components within the message string composite array.

     This `IndexSet` is used to build a message for print statements that have an associated value reporter node type but have no value argument supplied.

     The difference between a reporter and a value reporter message is that it simply omits the value labels.
     */
    static let reporterIndexes:IndexSet       = [pC.index_EntityCode,
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
                                                 pC.index_EventDescription]
 
    
    /// An `IndexSet` containing the indexes of function name message components within the message string composite array.
    static let functionNameIndexes:IndexSet   = [pC.index_EntityCode,
                                                 pC.index_EntityCodeDifferential,
                                                 pC.index_F1,
                                                 pC.index_FunctionTypeSymbol,
                                                 pC.index_FunctionTypeString,
                                                 pC.index_AdjustmentForFunctionNumberPlaces,
                                                 pC.index_UsedFunctionNumber,
                                                 pC.index_F2,
                                                 pC.index_FunctionName]
    
    ///An `IndexSet` containing the indexes of effect message components within the message string composite array.
    static let effectIndexes:IndexSet         = [pC.index_EffectLabel,
                                                 pC.index_EffectDescription]
    
    
    ///An `IndexSet` containing the indexes of node only message components within the message string composite array.
    static let nodeOnlyIndexes:IndexSet       = [pC.index_EntityCode,
                                                 pC.index_EntityCodeDifferential,
                                                 pC.index_RJustifyAdjusterFromFunctionElements,
                                                 pC.index_UsedFunctionNumber,
                                                 pC.index_G1,
                                                 pC.index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces,
                                                 pC.index_AbsoluteNodeNumber]
    
    //Indexes for readoutSpacer calculation
    /**
     An `IndexSet` containing the indexes of readout spacer section spacers within the message string composite array.
     
     This `IndexSet` is used for the calculation of the readout spacer section of event and value messages.
     */
    static let defaultReadoutSpacers: IndexSet                         = [pC.index_EntityCodeDifferential,
                                                                          pC.index_RJustifyAdjusterFromFunctionElements,
                                                                          pC.index_G1,
                                                                          pC.index_FailNodeSymbol]
    
    
    /**
     An `IndexSet` containing the indexes of readout spacer section components within the message string composite array.
     
     This `IndexSet` is used for the calculation of the readout spacer section of event and value messages.
     
     - Note:
     Readout spacer section compensation for the function type symbol is calculated into the value at `index_RJustifyAdjusterFromFunctionElements` and is therefore accounted for by `defaultReadoutSpacers`.
     */
    static let defaultReadoutComponents: IndexSet                      = [pC.index_EntityCode,
                                                                          pC.index_UsedFunctionNumber,
                                                                          pC.index_Linker_NodeNumber,
                                                                          pC.index_UsedNodeNumber,
                                                                          pC.index_LJustifyAdjusterFromUsedNodeNumberPlaces,
                                                                          pC.index_Linker_EventDescription]
    
    /**
     An `IndexSet` containing the indexes of readout spacer section user settable components within the message string composite array.
     
     This `IndexSet` is used for the calculation of the readout spacer section of event and value messages.
     */
    static let userSettableSymbolReadoutComponents: IndexSet           = [pC.index_ControlFlowNodeTypeSymbol,
                                                                          pC.index_OutcomeSymbol]
    
    // stringComposite indexes
    ///An `Int` representing the slot position index of the first custom spacer within the message string composite array.
    static let index_C1                                     = 0
    ///An `Int` representing the slot position index of a message entity code within the message string composite array.
    static let index_EntityCode                             = 1
    ///An `Int` representing the slot position index of a message maximum entity code length deviation spacer within the message string composite array.
    static let index_EntityCodeDifferential                 = 2
    ///An `Int` representing the slot position index of a message function symbol elements right justification spacer within the message string composite array.
    static let index_RJustifyAdjusterFromFunctionElements   = 3
    ///An `Int` representing the slot position index of a message first function name section spacer within the message string composite array.
    static let index_F1                                     = 4
    ///An `Int` representing the slot position index of a message function type symbol within the message string composite array.
    static let index_FunctionTypeSymbol                     = 5
    ///An `Int` representing the slot position index of the message function type raw value character within the message string composite array.
    static let index_FunctionTypeString                     = 6
    ///An `Int` representing the slot position index of a message function number inverse adjustment spacer within the message string composite array.
    static let index_AdjustmentForFunctionNumberPlaces      = 7
    ///An `Int` representing the slot position index of the second custom spacer within the message string composite array.
    static let index_C2                                     = 8
    ///An `Int` representing the slot position index of a message function number within the message string composite array.
    static let index_UsedFunctionNumber                     = 9
    ///An `Int` representing the slot position index of a general column spacer for control flow messages within the message string composite array.
    static let index_G1                                     = 10
    ///An `Int` representing the slot position index of a message second function name section spacer within the message string composite array.
    static let index_F2                                     = 11
    ///An `Int` representing the slot position index of the third custom spacer within the message string composite array.
    static let index_C3                                     = 12
    ///An `Int` representing the slot position index of a message fail node symbol within the message string composite array.
    static let index_FailNodeSymbol                         = 13
    ///An `Int` representing the slot position index of a message fail node symbol spacer within the message string composite array.
    static let index_FailNodeSymbolSpacer                   = 14
    ///An `Int` representing the slot position index of a message control flow node symbol within the message string composite array.
    static let index_ControlFlowNodeTypeSymbol              = 15
    ///An `Int` representing the slot position index of a message node symbol to node number linker within the message string composite array.
    static let index_Linker_NodeNumber                      = 16
    ///An `Int` representing the slot position index of a message function name within the message string composite array.
    static let index_FunctionName                           = 17
    ///An `Int` representing the slot position index of a message node number within the message string composite array.
    static let index_UsedNodeNumber                         = 18
    ///An `Int` representing the slot position index of a message node number left justification spacer within the message string composite array.
    static let index_LJustifyAdjusterFromUsedNodeNumberPlaces       = 19
    ///An `Int` representing the slot position index of a message print number left justification spacer within the message string composite array.
    static let index_LJustifyAdjusterFromAbsoluteNodeNumberPlaces   = 20
    ///An `Int` representing the slot position index of a message print number within the message string composite array.
    static let index_AbsoluteNodeNumber                     = 21
    ///An `Int` representing the slot position index of the spacer following the message print number within the message string composite array.
    static let index_PostAbsoluteNodeNumber                 = 22
    ///An `Int` representing the slot position index of the fourth custom spacer within the message string composite array.
    static let index_C4                                     = 23
    ///An `Int` representing the slot position index of a message outcome symbol within the message string composite array.
    static let index_OutcomeSymbol                          = 24
    ///An `Int` representing the slot position index of a message SKU section to description linker within the message string composite array.
    static let index_Linker_EventDescription                = 25
    ///An `Int` representing the slot position index of a value reporter message values label within the message string composite array.
    static let index_ReporterValuesLabel                    = 26
    ///An `Int` representing the slot position index of an event message description within the message string composite array.
    static let index_EventDescription                       = 27
    ///An `Int` representing the slot position index of a value reporter message linking verb label within the message string composite array.
    static let index_ReporterAuxiliaryLabel                 = 28
    ///An `Int` representing the slot position index of an effect message label within the message string composite array.
    static let index_EffectLabel                            = 29
    ///An `Int` representing the slot position index of an effect message description within the message string composite array.
    static let index_EffectDescription                      = 30
}
