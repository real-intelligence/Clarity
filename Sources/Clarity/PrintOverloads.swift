//
//  PrintOverloads.swift
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





/// A  global constant that stores a single ClarityPrintLogic instance for use by the Swift print overload functions.
 let printer = ClarityPrintLogic()


// MARK: -  🖨  print overload functions

/**
A public global function that formats and prints a message to the console corresponding to data stored as JSON for a given print number and behaves as an analogue overload of the Swift  [`print(_:separator:terminator:)`](https://developer.apple.com/documentation/swift/1541053-print) function.
    
 - Parameters:
   - printNumber: An `Int` that acts as a unique number used as a key to access a specific associated message from a dictionary containing all message data.
   - functionName: An optional parameter for a `#function` macro argument. If this parameter is included ``Clarity`` formats and prints the log as a function name node for the function that contains `printNumber` (see <doc:Output-called-function-names>).
   - settings: An optional parameter for a dynamic ``SettingsManagerService`` instance. The ``SettingsManagerService`` instance can have its properties set programmatically to a variety of values. This enables more convenient and dynamic evaluation of a wider range of unit tests in a test target than is possible when using the JSON access mechanism.
 */
public func print(_ printNumber: Int,
                  functionName: String? = nil,
                  settings: SettingsManagerService? = nil){

    if (ClarityActivator.isClientInDebugMode && ClarityActivator.isClientOverrideDebug == false) || ClarityActivator.isClientOverrideRelease{
        printer.printLogic(printNumber, settings, functionName )
    }
}

/**
 A public global function that formats and prints a message to the console corresponding to data stored as JSON for a given print number and behaves as an analogue overload of the Swift  [`print(_:separator:terminator:)`](https://developer.apple.com/documentation/swift/1541053-print) function.

 - Parameters:
   - printNumber: An `Int` that acts as a unique number used as a key to access a specific associated message from a dictionary containing all message data.
   - values: An optional parameter for the inclusion of variable values to be printed as part of the message. If this parameter is included ``Clarity`` formats and prints the log as a value report node (see <doc:Output-values-and-errors>). The parameter can be a single value of any type,  a  [`Collection`]( https://developer.apple.com/documentation/swift/collection) of any type or an instance conforming to the [`Error`]( https://developer.apple.com/documentation/swift/error) protocol.
   - settings: An optional parameter for a dynamic ``SettingsManagerService`` instance. The ``SettingsManagerService`` instance can have its properties set programmatically to a variety of values. This enables more convenient and dynamic evaluation of a wider range of unit tests in a test target than is possible when using the JSON access mechanism.
 */
public func print(_ printNumber: Int,
                  values: Any? = nil,
                  settings: SettingsManagerService? = nil){
    
    if (ClarityActivator.isClientInDebugMode && ClarityActivator.isClientOverrideDebug == false) || ClarityActivator.isClientOverrideRelease{
        printer.printLogic(printNumber, settings, nil, values)
    }
}



