//
//  EntityLogService.swift
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
 A struct that is used as the top level container of an intermediate service model used to decode EntityLog JSON data.
      
 The struct matches the structure of the EntityLog JSON exactly with the intention of being used to service an EntityLog struct that models the JSON differently. It embeds nested structs representing arrays in the JSON data.
      
 The structure of the EntityLog JSON is designed for the convenience of the user. It represents the way print numbers appear in the source code relative to functions positioned at the top level of the JSON hierarchy. The EntityLog struct model on the other hand is designed for the efficiency of the framework with print number messages positioned at the top level of the struct hierarchy.
      
 - Note:
 The struct uses a custom semantic naming system to name properties associated with key value pairs and their position in the JSON. This system was developed as an aid to correctly map each key to its position in the struct.
 */
struct EntityLogService: Codable, Equatable {
    
    /// A string mapped to the `entity_code` key in the EntityLog JSON data.
    let kA: String
    /// An array of KB21 instances mapped to the `entity_functions` key in the EntityLog JSON data.
    let kB21A: [KB21]
    
    /**
     A struct embedded inside an `EntityLogService` struct that is used as a nested layer within an intermediate service model used to decode EntityLog JSON data.
              
     The struct models an array of JSON objects mapped to the `entity_functions` key in the EntityLog JSON data.
              
     - Note:
     The struct uses a custom semantic naming system to name properties associated with key value pairs and their position in the JSON. This system was developed as an aid to correctly map each key to its position in the struct.
     */
    struct KB21: Codable , Equatable {
        /// An integer mapped to the `function_number` key in the EntityLog JSON data.
        let kC: Int
        /// A bool mapped to the `function_number_always_custom` key in the EntityLog JSON data.
        let kI: Bool
        /// A string mapped to the `function_type` key in the EntityLog JSON data.
        let kJ: FunctionType
        /// An array of KD31 instances mapped to the `function_nodes` key in the EntityLog JSON data.
        let kD31A: [KD31]
        
        /**
         An enum that conforms to the `CodingKey` protocol  for storing the key strings used to decode `KB21` from the JSON data. .
         */
        enum CodingKeys: String, CodingKey {
            /// A string used to decode the Int property `kC` from the key `function_number`.
            case kC = "function_number"
            /// A string used to decode the Bool property `kI` from the key `function_number_always_custom`.
            case kI = "function_number_always_custom"
            /// A string used to decode the String property `kJ` from the key `function_type`.
            case kJ = "function_type"
            /// A string used to decode the KD31 array property `kD31A` from the key `function_nodes`.
            case kD31A = "function_nodes"
        }
        
        /**
         A struct embedded inside a `KB21` struct that is used as a nested layer within an intermediate service model used to decode EntityLog JSON data
                      
         The struct models an array of JSON objects mapped to the `function_nodes` key in the EntityLog JSON data.
                      
         - Note:
         The struct uses a custom semantic naming system to name properties associated with key value pairs and their position in the JSON. This system was developed as an aid to correctly map each key to its position in the struct.
         */
        struct KD31: Codable , Equatable {
            /// An integer mapped to the `print_number` key in the EntityLog JSON data.
            let kE: Int
            /// An enum of type NodeType mapped to the `node_type` key in the EntityLog JSON data where it is represented as an integer.
            let kF: NodeType
            /// A string mapped to the `event_description` key in the EntityLog JSON data.
            let kG: String
            /// A string mapped to the `effect_description` key in the EntityLog JSON data.
            let kH: String
            
            /**
             An enum that conforms to the `CodingKey` protocol for storing the key strings used to decode `KD31` from the JSON data.
             */
            enum CodingKeys: String, CodingKey {
                /// A string used to decode the Int property `kE` from the key `print_number`.
                case kE = "print_number"
                /// A string used to decode the NodeType property `kF` from the key `node_type`.
                case kF = "node_type"
                /// A string used to decode the String property `kG` from the key `event_description`.
                case kG = "event_description"
                /// A string used to decode the String property `kH` from the key `effect_description`.
                case kH = "effect_description"
            }
        }
    }
}


extension EntityLogService {
    /**
     An enum that conforms to the `CodingKey` protocol for storing the key strings used to decode `EntityLogService` from the JSON data.
     */
    enum CodingKeys: String, CodingKey {
        /// A string used to decode the Int property `kA` from the key `entity_code`.
        case kA = "entity_code"
        /// A string used to decode the KB21 array property `kB21A` from the key `entity_functions`.
        case kB21A = "entity_functions"
    }
}

/**
 An enum for storing the node type state of the message associated with a print number.
 
 Each case is used to specify formatting when displaying the associated message in the console.
 */
enum NodeType: Int,Codable , Equatable {
     /**
     The message should be displayed as a function name.

     The message will include the function name if the argument `#function` is supplied to the optional `functionName` parameter of the `print(_:functionName:settings:)` overload.

     If no argument is supplied it will simply display the entity code, function symbol and function number.
     */
    case functionName = 0
    /// The message should be displayed as the successful pass of a conditional `if` statement in the control flow.
    case ifTrueCondition
    /// The message should be displayed as failing to pass a conditional `if` statement and reaching a paired `else` clause in the control flow.
    case elseCondition
    /// The message should be displayed as the successful pass of a conditional `if` statement that has a negative or undesired outcome in the control flow.
    case ifTrueConditionNegativeOutcome
    /// The message should be displayed as failing to pass a conditional `if` statement and reaching a paired `else` clause that has a positive or desired outcome in the control flow.
    case elseConditionPositiveOutcome
    /// The message should be displayed as the successful match of a conditional `switch` statement case that has a positive or desired outcome in the control flow.
    case caseTruePositiveOutcome
    /// The message should be displayed as the successful match of a conditional `switch` statement case that has a negative or undesired outcome in the control flow.
    case caseTrueNegativeOutcome
    /// The message should be displayed as the successful pass of a conditional `guard` statement in the control flow.
    case guardPass
    /// The message should be displayed as failing to pass a conditional `guard` statement and reaching its associated `else` clause in the control flow.
    case guardFail
    /// The message should be displayed as signifying the execution of the  `do` block of a `do-catch` statement after successfully attempting `try` on a function that throws an error in the control flow.
    case doTryPass
    /// The message should be displayed as signifying the execution of the `catch` block of a `do-catch` statement after unsuccessfully attempting `try` on a function that throws an error in the control flow.
    case catchTryFail
    /**
     The message should be displayed as a value or comment report.

     The message will be displayed as a value report if a value argument is supplied to the optional `values` parameter of the `print(_:values:settings:)` overload.
              
     If no argument is supplied it will simply display the report `event_description` as a comment.

     If a value argument is supplied any value or values are displayed on subsequent lines in the console after the report description.
     */
    case valueReporter
    /**
     The message should be displayed as an error report.

     The message will be displayed as an error report if the value argument supplied to the optional `values` parameter of the `print(_:values:settings:)` overload conforms to the 'Error' protocol.
              
     If an error argument is supplied the error is displayed on the following line in the console after the error report `event_description`.
              
     - Note:
     If the error conforms to LocalizedError the error will be displayed as a NSLocalizedString written for the specific custom error case. Otherwise the error will be described as the type name of the `Error` supplied to the `values` parameter.
              
     Alternatively the error description will be described if `localizedDescription` is called on the error as it is supplied to the `values` parameter.
              
     If no argument is supplied it will simply display the error report `event_description` as a comment without actual error information.
     */
    case errorReporter
}
/**
 An enum for storing the function group state of the message associated with a print number.

 Each case is used to specify the formatting of function name node types when displaying the associated message in the console.

 Each case is assigned a single character value as an abbreviation of the case name. The values are the same used to specify the `FunctionType` of a message in the EntityLog JSON although the values are not directly bound.

 - Note:
 The use of this feature is discretional and does not bind the function referenced in the source code to the group specified by a particular case: any case can be used for any group of function, mapped to signify an alternative group or the single default case `CustomFunc` can be used for all functions.
      
 The grouping of functions named in the enum is not intended to be an exhaustive list or the representation of an ideal demarcation.
      
 The purpose of differential formatting according to function group is as an additional visual aid that makes it easier to spot anomalies or unexpected routes in the control flow. It is also designed to help developers gain understanding of the functionality of unfamiliar code.
 */
enum FunctionType: String,Codable , Equatable {
    /// The message `FunctionName` `NodeType` should be formatted as an initialiser.
    case initialiser = "i"
    /// The message `FunctionName` `NodeType` should be formatted as a custom function or method.
    case customFunc = "f"
    /// The message `FunctionName` `NodeType` should be formatted as a custom override of a system library method.
    case systemOverride = "o"
    /// The message `FunctionName` `NodeType` should be formatted as an action method.
    case actionMethod = "a"
    /// The message `FunctionName` `NodeType` should be formatted as a delegate method.
    case delegateMethod = "g"
    /// The message `FunctionName` `NodeType` should be formatted as a datasource method.
    case datasourceMethod = "d"
    /// The message `FunctionName` `NodeType` should be formatted as a computed variable.
    case computedVar = "v"
    /// The message `FunctionName` `NodeType` should be formatted as a method implementation written in a protocol extension.
    case protocolExtensionMethod = "e"
}
