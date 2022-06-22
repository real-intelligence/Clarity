//
//  FormattingManagerService.swift
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
A struct that is used as the top level container of a model used to decode Formatting JSON data.
          
The struct matches the structure of the Formatting JSON exactly and is not currently used to service a struct that models the JSON differently. It embeds nested structs representing objects in the JSON data.
          
- Note
The struct uses a custom semantic naming system to name properties associated with key value pairs and their position in the JSON. This system was developed as an aid to correctly map each key to its position in the struct.
     */
struct FormattingManagerService: Codable, Equatable {
    
    /// A struct of type OutcomeSymbols mapped to the `outcome_symbols` key in the Formatting JSON data where it is represented as a JSON object.
    let kAOb: OutcomeSymbols
    /// A struct of type ControlFlowNodeSymbols mapped to the `controlflow_node_type_symbols` key in the Formatting JSON data where it is represented as a JSON object.
    let kBOb: ControlFlowNodeSymbols
    /// A struct of type FunctionTypeSymbols mapped to the `function_type_symbols` key in the Formatting JSON data where it is represented as a JSON object.
    let kCOb: FunctionTypeSymbols
    /// A struct of type Spacers mapped to the `spacers` key in the Formatting JSON data where it is represented as a JSON object.
    let kDOb: Spacers
    
    /**
     A struct embedded inside a `FormattingManagerService` struct used as a nested layer within a model used to decode Formatting JSON data.

     The struct models the JSON object mapped to the `outcome_symbols` key in the Formatting JSON data.

     Most of the parameters within the `outcome_symbols` JSON object relate to the outcome of various conditional statements. The parameters key string values are used to format the outcome symbol of node types when displaying messages in the console.
     
     - Note
     The struct uses a custom semantic naming system to name properties associated with key value pairs and their position in the JSON. This system was developed as an aid to correctly map each key to its position in the struct.
         */
    struct OutcomeSymbols: Codable, Equatable {
        /// A string mapped to the `if_true_condition` key in the Formatting JSON data.
        let kA: String
        /// A string mapped to the `else_condition` key in the Formatting JSON data.
        let kB: String
        /**
         A string mapped to the `if_true_condition_negative_outcome` key in the Formatting JSON data.
         - Note
         The use of the `if_true_condition_negative_outcome` key in place of the `if_true_condition` is discretional.
         
         The `if_true_condition` and `else_condition` keys can be used for all conditional statements and still convey general outcome.
                  
         The purpose of differential formatting according to the semantic outcome of conditional statements is as an additional visual aid that makes it easier to spot anomalies or unexpected routes in the control flow. It is also designed to help developers gain understanding of the functionality of unfamiliar code.
         */
        let kC: String
        /**
         A string mapped to the `else_condition_positive_outcome` key in the Formatting JSON data.
         - Note
         The use of the `else_condition_positive_outcome` key in place of the `else_condition` is discretional.
         
         The `if_true_condition` and `else_condition` keys can be used for all conditional statements and still convey general outcome.
                  
         The purpose of differential formatting according to the semantic outcome of conditional statements is as an additional visual aid that makes it easier to spot anomalies or unexpected routes in the control flow. It is also designed to help developers gain understanding of the functionality of unfamiliar code.
         */
        let kD: String
        /**
         A string mapped to the `case_true_positive_outcome` key in the Formatting JSON data. This key is for print statements placed in the case branch body of Switch statements that are designated as a positive or expected outcome.
         - Note
         The purpose of differential formatting according to the semantic outcome of conditional statements is as an additional visual aid that makes it easier to spot anomalies or unexpected routes in the control flow. It is also designed to help developers gain understanding of the functionality of unfamiliar code.
         */
        let kE: String
        /**
         A string mapped to the `case_true_negative_outcome` key in the Formatting JSON data. This key is for print statements placed in the case branch body of Switch statements that are designated as a negative or unexpected outcome.
         - Note
         The use of this feature is discretional – alternatively, the key `case_true_positive_outcome` could be used for all Switch cases.
         
         The purpose of differential formatting according to the semantic outcome of conditional statements is as an additional visual aid that makes it easier to spot anomalies or unexpected routes in the control flow. It is also designed to help developers gain understanding of the functionality of unfamiliar code.
         */
        let kF: String
        /// A string mapped to the `guard_pass` key in the Formatting JSON data.
        let kG: String
        /// A string mapped to the `guard_fail` key in the Formatting JSON data.
        let kH: String
        /// A string mapped to the `do_try_pass` key in the Formatting JSON data.
        let kI: String
        /// A string mapped to the `catch_try_fail` key in the Formatting JSON data.
        let kJ: String
        /// A string mapped to the `value_reporter` key in the Formatting JSON data.
        let kK: String
        /// A string mapped to the `error_reporter` key in the Formatting JSON data.
        let kL: String
        
        /**
         An enum that conforms to the `CodingKey` protocol  for storing the key strings used to decode `kAOb` from the JSON data. .
         */
        enum CodingKeys: String, CodingKey {
            /// A string used to decode the String property `kA` from the key `if_true_condition`.
            case kA = "if_true_condition"
            /// A string used to decode the String property `kB` from the key `else_condition`.
            case kB = "else_condition"
            /// A string used to decode the String property `kC` from the key `if_true_condition_negative_outcome`.
            case kC = "if_true_condition_negative_outcome"
            /// A string used to decode the String property `kD` from the key `else_condition_positive_outcome`.
            case kD = "else_condition_positive_outcome"
            /// A string used to decode the String property `kE` from the key `case_true_positive_outcome`.
            case kE = "case_true_positive_outcome"
            /// A string used to decode the String property `kF` from the key `case_true_negative_outcome`.
            case kF = "case_true_negative_outcome"
            /// A string used to decode the String property `kG` from the key `guard_pass`.
            case kG = "guard_pass"
            /// A string used to decode the String property `kH` from the key `guard_fail`.
            case kH = "guard_fail"
            /// A string used to decode the String property `kI` from the key `do_try_pass`.
            case kI = "do_try_pass"
            /// A string used to decode the String property `kJ` from the key `catch_try_fail`.
            case kJ = "catch_try_fail"
            /// A string used to decode the String property `kK` from the key `value_reporter`.
            case kK = "value_reporter"
            /// A string used to decode the String property `kL` from the key `error_reporter`.
            case kL = "error_reporter"
        }
    }
    
    
    /**
     A struct embedded inside a `FormattingManagerService` struct used as a nested layer within a model used to decode Formatting JSON data.

     The struct models the JSON object mapped to the `controlflow_node_type_symbols` key in the Formatting JSON data.
     
     The parameters key string values are used to format the control flow node type symbol of node types when displaying messages in the console.
     
     - Note
     The struct uses a custom semantic naming system to name properties associated with key value pairs and their position in the JSON. This system was developed as an aid to correctly map each key to its position in the struct.
         */
    struct ControlFlowNodeSymbols: Codable, Equatable {
        
        /// A string mapped to the `if_else_conditional` key in the Formatting JSON data. This key is for all print statements placed in `if` statements and `else` clauses in the control flow that produce event messages.
        let kA: String
        /// A string mapped to the `switch_case` key in the Formatting JSON data. This key is for all print statements placed in `Switch` statement case clauses in the control flow that produce event messages.
        let kB: String
        /// A string mapped to the `guard` key in the Formatting JSON data. This key is for all print statements placed in `guard` statements and associated `else` clauses in the control flow that produce event messages.
        let kC: String
        /// A string mapped to the `do_catch_try` key in the Formatting JSON data. This key is for all print statements placed in `do-catch` statements in the control flow that produce event messages.
        let kD: String
        /// A string mapped to the `value_reporter` key in the Formatting JSON data. This key is for all print statements that are displayed as a value or comment report.
        let kE: String
        /// A string mapped to the `value_reporter` key in the Formatting JSON data. This key is for all print statements that are displayed as an error report.
        let kF: String
        
        
        
        /**
         An enum that conforms to the `CodingKey` protocol  for storing the key strings used to decode `kBOb` from the JSON data. .
         */
        enum CodingKeys: String, CodingKey {
            /// A string used to decode the String property `kA` from the key `if_else_conditional`.
            case kA = "if_else_conditional"
            /// A string used to decode the String property `kB` from the key `switch_case`.
            case kB = "switch_case"
            /// A string used to decode the String property `kC` from the key `guard`.
            case kC = "guard"
            /// A string used to decode the String property `kD` from the key `do_catch_try`.
            case kD = "do_catch_try"
            /// A string used to decode the String property `kE` from the key `value_reporter`.
            case kE = "value_reporter"
            /// A string used to decode the String property `kF` from the key `error_reporter`.
            case kF = "error_reporter"
        }
    }
    
    /**
     A struct embedded inside a `FormattingManagerService` struct used as a nested layer within a model used to decode Formatting JSON data.

     The struct models the JSON object mapped to the `function_type_symbols` key in the Formatting JSON data.
     
     The parameters key string values are used to format the function type symbol of node types when displaying `functionName` messages in the console.
     
     - Note
     The grouping of functions named in the enum is not intended to be an exhaustive list or the representation of an ideal demarcation.
          
     The purpose of differential formatting according to function group is as an additional visual aid that makes it easier to spot anomalies or unexpected routes in the control flow. It is also designed to help developers gain understanding of the functionality of unfamiliar code.
     
     The struct uses a custom semantic naming system to name properties associated with key value pairs and their position in the JSON. This system was developed as an aid to correctly map each key to its position in the struct.
         */
    struct FunctionTypeSymbols: Codable, Equatable {
        /// A string mapped to the `initialiser` key in the Formatting JSON data.
        let kA: String
        /// A string mapped to the `custom_function` key in the Formatting JSON data.
        let kB: String
        /// A string mapped to the `system_method_override` key in the Formatting JSON data.
        let kC: String
        /// A string mapped to the `action_method` key in the Formatting JSON data.
        let kD: String
        /// A string mapped to the `delegate_method` key in the Formatting JSON data.
        let kE: String
        /// A string mapped to the `datasource_method` key in the Formatting JSON data.
        let kF: String
        /// A string mapped to the `computed_variable` key in the Formatting JSON data.
        let kG: String
        /// A string mapped to the `protocol_extension_method` key in the Formatting JSON data.
        let kH: String
        
        /**
         An enum that conforms to the `CodingKey` protocol  for storing the key strings used to decode `kCOb` from the JSON data. .
         */
        enum CodingKeys: String, CodingKey {
            /// A string used to decode the String property `kA` from the key `initialiser`.
            case kA = "initialiser"
            /// A string used to decode the String property `kB` from the key `custom_function`.
            case kB = "custom_function"
            /// A string used to decode the String property `kC` from the key `system_method_override`.
            case kC = "system_method_override"
            /// A string used to decode the String property `kD` from the key `action_method`.
            case kD = "action_method"
            /// A string used to decode the String property `kE` from the key `delegate_method`.
            case kE = "delegate_method"
            /// A string used to decode the String property `kF` from the key `datasource_method`.
            case kF = "datasource_method"
            /// A string used to decode the String property `kG` from the key `computed_variable`.
            case kG = "computed_variable"
            /// A string used to decode the String property `kH` from the key `protocol_extension_method`.
            case kH = "protocol_extension_method"
         
        }
    }
    
    /**
     A struct embedded inside a `FormattingManagerService` struct used as a nested layer within a model used to decode Formatting JSON data.

     The struct models the JSON object mapped to the `spacers` key in the Formatting JSON data.
     
     The parameters key integer values are used to add additional custom spacers at specific locations within each message printed to the console. A single integer represents one character of empty space in the console.
     
     - Note
     Use of the custom spacers is discretionary and not necessary for formatting print messages.
         */
    struct Spacers: Codable, Equatable {
        /**
         An Int mapped to the `spacer1` key in the Formatting JSON data.
         
         Spacer1 is positioned before the entity code in the message line. Its value is reflected by all other lines printed simultaneously with the message (such as the effect description and values).
         */
        let kA: Int
        /**
         An Int mapped to the `spacer2` key in the Formatting JSON data.
         
         Spacer2 is positioned between the function symbol group and the function number in the message line. Its value is reflected by all other lines printed simultaneously with the message (such as the effect description and values).
         */
        let kB: Int
        /**
         An Int mapped to the `spacer3` key in the Formatting JSON data.
         
         Spacer3 is positioned between the function number and the node symbol group in the message line. Its value is reflected by all other lines printed simultaneously with the message (such as the effect description and values).
         */
        let kC: Int
        /**
         An Int mapped to the `spacer4` key in the Formatting JSON data.
         
         Spacer4 is positioned between the node symbol group and the outcome symbol in the message line. Its value is reflected by all other lines printed simultaneously with the message (such as the effect description and values).
         
         - Note
         Spacer4 is not used by messages printed when the key `displayNodeSequenceWithoutDescriptions` value is true in the Settings JSON.
         */
        let kD: Int
        
        /**
         An enum that conforms to the `CodingKey` protocol  for storing the key strings used to decode `kDOb` from the JSON data.
         */
        enum CodingKeys: String, CodingKey {
            /// A string used to decode the String property `kA` from the key `spacer1`.
            case kA = "spacer1"
            /// A string used to decode the String property `kB` from the key `spacer2`.
            case kB = "spacer2"
            /// A string used to decode the String property `kC` from the key `spacer3`.
            case kC = "spacer3"
            /// A string used to decode the String property `kD` from the key `spacer4`.
            case kD = "spacer4"
        }
    }
}

extension FormattingManagerService {
    /**
     An enum that conforms to the `CodingKey` protocol  for storing the key strings used to decode `FormattingManagerService` from the JSON data.
     */
    enum CodingKeys: String, CodingKey {
        /// A string used to decode the String property `kAOb` from the key `outcome_symbols`.
        case kAOb = "outcome_symbols"
        /// A string used to decode the String property `kBOb` from the key `controlflow_node_type_symbols`.
        case kBOb = "controlflow_node_type_symbols"
        /// A string used to decode the String property `kCOb` from the key `function_type_symbols`.
        case kCOb = "function_type_symbols"
        /// A string used to decode the String property `kDOb` from the key `spacers`.
        case kDOb = "spacers"
    }
}
