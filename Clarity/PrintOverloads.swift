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
import SwiftUI




/// A private global constant that stores a single ClarityPrintLogic instance for use by the Swift print overload functions.
private let printer = ClarityPrintLogic()


/**
A public overload of the Swift `print(_:separator:terminator:)` function that formats and prints a message to the console corresponding to data stored as JSON for a given print number.

This function is placed outside a struct or class to enable clients to call it without having to specify a defining type – in the same manner as the Swift `print(_:separator:terminator:)` function.

 The Clarity framework assumes three main ‘nodes’ of interest in a control flow: function call points, the resolution of conditional statements and the reporting of specific values including descriptions of Error instances. This function is intended to be placed at such node points in the client application code.

 All message data relating to each print number is placed entirely in associated JSON files. This enables the printing of unlimited verbose commentary yet having zero impact on the source code.


 - Parameters:
   - printNumber:  A unique number used as a key to access a specific associated message from a dictionary containing all message data.
   - functionName: An optional parameter for a `#function` macro argument. If this parameter is included Clarity formats and prints the log as a function call node for the function that contains `printNumber`.
   - settings: An optional parameter for a mock `SettingsManagerService` instance. The mock SettingsManagerService instance can have its properties set programmatically to a variety of values. This enables more convenient and dynamic evaluation of a wider range of unit tests in a test target than is possible when using the JSON access mechanism.


 - Note:
 All calls to this function must provide an argument to the `printNumber` parameter.
 
 A function call node and a value report node would never be associated with the same print number and therefore have separate overloads rather than a single function with multiple parameters.

 Formatting and display outcome is controlled by user preferences in the associated Settings and Formatting JSON files.

 Conditional node details printed include the entity code, the function number, the node symbol-number, the outcome symbol, the event description and the effect description on the following line.
 
 The function identity details printed include the entity code, the function ‘group type’ symbols, the function number, and the function name.
 
 Examples printing a conditional node message for print number 35 and a function call node – the identity of a function that contains print nodes 34 and 35:
 ````
 //JSON file for print numbers in a struct, class or enum
 {
     "entity_code":"ENTCC",
     "entity_functions" : [
         {
             "function_number":15,
             "function_number_always_custom":false,
             "function_type":"f",
             "function_nodes":[
                 {
                     "print_number":34,
                     "node_type":0,
                     "event_description":"N/A - this is a function call point node",
                     "effect_description":"N/A"
                 },
                 {
                     "print_number":35,
                     "node_type":1,
                     "event_description":"An expected event occurred",
                     "effect_description":"this should happen next"
                 }
             ]
         }
     ]
 }
 //Source code (conditional node):
 print(35)
 //Indicative console output:
 ENTCC        15    N-35    ✅  - An expected event occurred
                                  Effect:this should happen next
 
 //Source code (function call node):
 // Using the same print number as another node within function_nodes ...
 // but providing the `functionName` argument has the same outcome.
 // so not strictly necessary to give function call nodes a dedicated print number
 
 print(35, functionName: #function) // 'borrowed' print number
 print(34, functionName: #function) // dedicated print number
 
 
 //Indicative console output for both calls:
 ENTCC 🍎f    15    myFunctionContainingPrintNumbers34And35()
 
 
 //Note: the printouts format and align correctly in the console
 //This is the best approximation of the console possible here using markdown
 
 ````
 */

public func print(_ printNumber: Int,
                  functionName: String? = nil,
                  settings: SettingsManagerService? = nil){

    if (ClarityActivator.isClientInDebugMode && ClarityActivator.isClientOverrideDebug == false) || ClarityActivator.isClientOverrideRelease{
        printer.printLogic(printNumber, settings, functionName )
    }
}

/**
A public overload of the Swift `print(_:separator:terminator:)` function that formats and prints a message to the console corresponding to data stored as JSON for a given print number.

This function is placed outside a struct or class to enable clients to call it without having to specify a defining type – in the same manner as the Swift `print(_:separator:terminator:)` function.

 The Clarity framework assumes three main ‘nodes’ of interest in a control flow: function call points, the resolution of conditional statements and the reporting of specific values including descriptions of Error instances. This function is intended to be placed at such node points in the client application code.

 All message data relating to each print number is placed entirely in associated JSON files. This enables the printing of unlimited verbose commentary yet having zero impact on the source code.


 - Parameters:
   - printNumber:  A unique number used as a key to access a specific associated message from a dictionary containing all message data.
   - values: An optional parameter for the inclusion of variable values to be printed as part of the message. If this parameter is included Clarity formats and prints the log as a value report node. The parameter can be a single value of any type,  a `Collection` of any type or an instance conforming to the `Error` protocol.
   - settings: An optional parameter for a mock `SettingsManagerService` instance. The mock SettingsManagerService instance can have its properties set programmatically to a variety of values. This enables more convenient and dynamic evaluation of a wider range of unit tests in a test target than is possible when using the JSON access mechanism.

 - Note:
 All calls to this function must provide an argument to the `printNumber` parameter.
 
 A function call node and a value report node would never be associated with the same print number and therefore have separate overloads rather than a single function with multiple parameters.

 Formatting and display outcome is controlled by user preferences in the associated Settings and Formatting JSON files.

 Conditional node details printed include the entity code, the function number, the node symbol-number, the outcome symbol, the event description and the effect description on the following line.
 
 Value reporting node details printed include the entity code, the function number, the report node symbol-number, the report symbol, the value or error custom description and the value(s) on the following line(s). If the value is an instance conforming to the `Error` protocol the error description is reported on the following line.
 
 Examples printing a conditional node message for print number 35 and an example printing a value report node associated with a message for print number 5:
 ````
 //JSON file for print numbers in a struct, class or enum
 {
     "entity_code":"ENTCC",
     "entity_functions" : [
         {
             "function_number":15,
             "function_number_always_custom":false,
             "function_type":"f",
             "function_nodes":[
                 {
                     "print_number":5,
                     "node_type":11, // or 12 for an error report
                     "event_description":"in myArray",
                     "effect_description":"N/A - only the event_description is printed as part of the value report"
                 },
                 {
                     "print_number":35,
                     "node_type":1,
                     "event_description":"An expected event occurred",
                     "effect_description":"this should happen next"
                 }
             ]
         }
     ]
 }
 //Source code
 print(35)
 //Indicative console output:
 ENTCC        15    N-35    ✅  - An expected event occurred
                                  Effect:this should happen next
 
 //Source code
 let myArray = [1,2]
 print(5, values: myArray)
 
 //Indicative console output:
 ENTCC        15    R-5     📋  - Values for variables in myArray are:
                                  1
                                  2
 
 
 //Note: the printouts format and align correctly in the console
 //This is the best approximation of the console possible here using markdown
 ````
 */

public func print(_ printNumber: Int,
                  values: Any? = nil,
                  settings: SettingsManagerService? = nil){
    
    if (ClarityActivator.isClientInDebugMode && ClarityActivator.isClientOverrideDebug == false) || ClarityActivator.isClientOverrideRelease{
        printer.printLogic(printNumber, settings, nil, values)
    }
}



extension View {
    
    /**
    A public overload of the Swift `print(_:separator:terminator:)` function that formats and prints a message to the console corresponding to data stored as JSON for a given print number.
     
     This function behaves exactly as the Clarity global scope print overload with the same parameters other than to return an empty View that allows it to be used within the `body` variable of a View. However because it will always be called within a View it is still possible to call it without having to specify a defining type – in the same manner as the Swift `print(_:separator:terminator:)` function.

     The Clarity framework assumes three main ‘nodes’ of interest in a control flow: function call points, the resolution of conditional statements and the reporting of specific values including descriptions of Error instances. This function is intended to be placed at such node points in the client application code.

     All message data relating to each print number is placed entirely in associated JSON files. This enables the printing of unlimited verbose commentary yet having zero impact on the source code.

     - Parameters:
       - printNumber:  A unique number used as a key to access a specific associated message from a dictionary containing all message data.
       - functionName: An optional parameter for a `#function` macro argument. If this parameter is included Clarity formats and prints the log as a function call node for the function that contains `printNumber`.
       - settings: An optional parameter for a mock `SettingsManagerService` instance. The mock SettingsManagerService instance can have its properties set programmatically to a variety of values. This enables more convenient and dynamic evaluation of a wider range of unit tests in a test target than is possible when using the JSON access mechanism.
     
     - Returns:
     An empty View that allows the function to conform to the View protocol and be used within the `body` var of a View instance.

     - Note:
     All calls to this function must provide an argument to the `printNumber` parameter.
     
     A function call node and a value report node would never be associated with the same print number and therefore have separate overloads rather than a single function with multiple parameters.

     Formatting and display outcome is controlled by user preferences in the associated Settings and Formatting JSON files.

     Conditional node details printed include the entity code, the function number, the node symbol-number, the outcome symbol, the event description and the effect description on the following line.
     
     The function identity details printed include the entity code, the function ‘group type’ symbols, the function number, and the function name.
     
     Examples printing a conditional node message for print number 35 and a function call node – the identity of a function that contains print nodes 34 and 35:
     ````
     //JSON file for print numbers in a struct, class or enum
     {
         "entity_code":"ENTCC",
         "entity_functions" : [
             {
                 "function_number":15,
                 "function_number_always_custom":false,
                 "function_type":"f",
                 "function_nodes":[
                     {
                         "print_number":34,
                         "node_type":0,
                         "event_description":"N/A - this is a function call point node",
                         "effect_description":"N/A"
                     },
                     {
                         "print_number":35,
                         "node_type":1,
                         "event_description":"An expected event occurred",
                         "effect_description":"this should happen next"
                     }
                 ]
             }
         ]
     }
     //Source code (conditional node):
     print(35)
     //Indicative console output:
     ENTCC        15    N-35    ✅  - An expected event occurred
                                      Effect:this should happen next
     
     //Source code (function call node):
     // Using the same print number as another node within function_nodes ...
     // but providing the `functionName` argument has the same outcome.
     // so not strictly necessary to give function call nodes a dedicated print number
     
     print(35, functionName: #function) // 'borrowed' print number
     print(34, functionName: #function) // dedicated print number
     
     
     //Indicative console output for both calls:
     ENTCC 🍎f    15    myFunctionContainingPrintNumbers34And35()
     
     
     //Note: the printouts format and align correctly in the console
     //This is the best approximation of the console possible here using markdown
     
     ````
     */
    public func print(_ printNumber: Int,
                      functionName: String? = nil,
                      settings: SettingsManagerService? = nil) -> some View {
        
        if (ClarityActivator.isClientInDebugMode && ClarityActivator.isClientOverrideDebug == false) || ClarityActivator.isClientOverrideRelease{
             printer.printLogic(printNumber, settings, functionName)
        }
        return EmptyView()
    }
    
    
    /**
    A public overload of the Swift `print(_:separator:terminator:)` function that formats and prints a message to the console corresponding to data stored as JSON for a given print number.

     This function behaves exactly as the Clarity global scope print overload with the same parameters other than to return an empty View that allows it to be used within the `body` variable of a View. However because it will always be called within a View it is still possible to call it without having to specify a defining type – in the same manner as the Swift `print(_:separator:terminator:)` function.

     The Clarity framework assumes three main ‘nodes’ of interest in a control flow: function call points, the resolution of conditional statements and the reporting of specific values including descriptions of Error instances. This function is intended to be placed at such node points in the client application code.

     All message data relating to each print number is placed entirely in associated JSON files. This enables the printing of unlimited verbose commentary yet having zero impact on the source code.


     - Parameters:
       - printNumber:  A unique number used as a key to access a specific associated message from a dictionary containing all message data.
       - values: An optional parameter for the inclusion of variable values to be printed as part of the message. If this parameter is included Clarity formats and prints the log as a value report node. The parameter can be a single value of any type,  a `Collection` of any type or an instance conforming to the `Error` protocol.
       - settings: An optional parameter for a mock `SettingsManagerService` instance. The mock SettingsManagerService instance can have its properties set programmatically to a variety of values. This enables more convenient and dynamic evaluation of a wider range of unit tests in a test target than is possible when using the JSON access mechanism.
     
     - Returns:
     An empty View that allows the function to conform to the View protocol and be used within the `body` var of a View instance.

     - Note:
     All calls to this function must provide an argument to the `printNumber` parameter.
     
     A function call node and a value report node would never be associated with the same print number and therefore have separate overloads rather than a single function with multiple parameters.

     Formatting and display outcome is controlled by user preferences in the associated Settings and Formatting JSON files.

     Conditional node details printed include the entity code, the function number, the node symbol-number, the outcome symbol, the event description and the effect description on the following line.
     
     Value reporting node details printed include the entity code, the function number, the report node symbol-number, the report symbol, the value or error custom description and the value(s) on the following line(s). If the value is an instance conforming to the `Error` protocol the error description is reported on the following line.
     
     Examples printing a conditional node message for print number 35 and an example printing a value report node associated with a message for print number 5:
     ````
     //JSON file for print numbers in a struct, class or enum
     {
         "entity_code":"ENTCC",
         "entity_functions" : [
             {
                 "function_number":15,
                 "function_number_always_custom":false,
                 "function_type":"f",
                 "function_nodes":[
                     {
                         "print_number":5,
                         "node_type":11, // or 12 for an error report
                         "event_description":"in myArray",
                         "effect_description":"N/A - only the event_description is printed as part of the value report"
                     },
                     {
                         "print_number":35,
                         "node_type":1,
                         "event_description":"An expected event occurred",
                         "effect_description":"this should happen next"
                     }
                 ]
             }
         ]
     }
     //Source code
     print(35)
     //Indicative console output:
     ENTCC        15    N-35    ✅  - An expected event occurred
                                      Effect:this should happen next
     
     //Source code
     let myArray = [1,2]
     print(5, values: myArray)
     
     //Indicative console output:
     ENTCC        15    R-5     📋  - Values for variables in myArray are:
                                      1
                                      2
     
     
     //Note: the printouts format and align correctly in the console
     //This is the best approximation of the console possible here using markdown
     ````
     */
    public func print(_ printNumber: Int,
                      values: Any? = nil,
                      settings: SettingsManagerService? = nil) -> some View {
        
        if (ClarityActivator.isClientInDebugMode && ClarityActivator.isClientOverrideDebug == false) || ClarityActivator.isClientOverrideRelease {
             printer.printLogic(printNumber, settings, nil, values)
        }
        return EmptyView()
    }
}
