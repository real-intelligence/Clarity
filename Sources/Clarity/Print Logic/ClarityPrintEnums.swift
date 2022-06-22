//
//  ClarityPrintEnums.swift
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
 An enum for storing the general type of the value passed in a print statement.
  
 The enum divides cases into one of the three generic collection types, a single type or none.
  
 The type of value passed to the print statement is indeterminate therefore value element types are either `Any` or `AnyHashable`.
  
 The general type of a value is all that is required to handle printing elements appropriately to the console (the purpose of the print statement values argument).
 
 - Note
    Each `PrintValueType` case is calculated from a message `NodeType` and not stored on the message itself.
 */
enum PrintValueType {
    /// The value is of type `Dictionary<AnyHashable, Any>`
    /// - `dictionary`: the associated dictionary value.
    case dictionaryValue(dictionary: Dictionary<AnyHashable, Any>)
    /// The value is of type `Array<Any>`
    /// - `array`: the associated array value.
    case arrayValue(array:[Any])
    /// The value is of type `Set<AnyHashable>`
    /// - `set`: the associated set value.
    case setValue(set:Set<AnyHashable>)
    /// The value is a single value of type `Any`
    /// - `single`: the associated value.
    case singleValue(single: Any)
    /// There is no value passed in the print statement that has a print number with the associated `NodeType` case `.ValueReporter` or `NodeType` case `.ErrorReporter`.
    case none
}

/**
 An enum for storing the print type of a message.
  
 The components that are used to build a message string are determined by a combination of the message `NodeType`, user settings derived from JSON and any arguments passed to the associated print statement.
  
 `PrintType` contains cases for all possible combinations and none.
 
 - Note
    The `PrintType` case is not stored on the message itself.
 */
enum PrintType {
    /// The message string should include components for a value reporter that has an associated array value.
    case valuesArray
    /// The message string should include components for a value reporter that has an associated array value. It should also include additional components to display the print number.
    case valuesArrayDisplayPrintNumber
    /// The message string should include components for a value reporter that has an associated set value.
    case valuesSet
    /// The message string should include components for a value reporter that has an associated set value. It should also include additional components to display the print number.
    case valuesSetDisplayPrintNumber
    /// The message string should include components for a value reporter that has an associated dictionary value.
    case valuesDictionary
    /// The message string should include components for a value reporter that has an associated dictionary value. It should also include additional components to display the print number.
    case valuesDictionaryDisplayPrintNumber
    /// The message string should include components for a value reporter that has an associated single value.
    case valueSingle
    /// The message string should include components for a value reporter that has an associated single value. It should also include additional components to display the print number.
    case valueSingleDisplayPrintNumber
    /// The message string should include components for a function name.
    case functionName
    /// The message string should include components for a control flow event.
    case event
    /// The message string should include components for a control flow event. It should also include additional components to display the print number.
    case eventDisplayPrintNumber
    /// The message string should include components for the effect of a control flow event.
    case effect
    /// The message string should include components for the effect of a control flow event. It should also include additional components to display the print number.
    case effectDisplayPrintNumber
    /// The message string should include components for a node only display of a control flow event.
    case nodeOnly
    /// The message string should include components for a reporter.
    case reporter
    /// The message string should include components for a reporter. It should also include additional components to display the print number.
    case reporterDisplayPrintNumber
    /// The message string should include components for an error reporter.
    case errorReporter
    /// The message string should include components for an error reporter. It should also include additional components to display the print number.
    case errorReporterDisplayPrintNumber
    /// The calculation to identify components to use for the message string failed to produce a result.
    case none
}


