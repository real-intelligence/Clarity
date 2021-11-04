//
//  EntityLog.swift
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
 A struct that is used to model EntityLog JSON data.
 
 The struct models data from an instance of `EntityLogService` injected into its initialiser by the `MessageCollator` initialiser. `EntityLogService` is modelled directly from the JSON data.  `EntityLog` reorganises this data into a dictionary of messages keyed by print number.  It embeds a nested `Message` struct that contains a flattened representation of all data associated with a print number.
 
 The initialiser also identifies any duplicate print numbers that exist in the EntityLog data and stores them in a static dictionary property on `MessageCollator`.
 */
struct EntityLog: Codable, Equatable {
    /**
     A dictionary of Message instances keyed by print number.
          
     This dictionary is merged into a dictionary of messages for all EntityLogs by the `MessageCollator` initialiser.
     */
    var messages = [Int: Message]()
    /**
     An array of Ints representing the print numbers contained in the EntityLog.
          
     The sole purpose of the array is for the identification of any duplicate print numbers.
     
     - Note:
     The array is **not** used for assigning keys or values to the `messages` dictionary.
     */
    var printNumbers = [Int]()
    /**
     A string representing the entity code of the EntityLog.
          
     It is referenced by UsedPrintNumberIdentifiable to list all used print numbers in each EntityLog and by `MessageCollator` to set the maximum entity code character count of the entity codes used in all EntityLogs.
     
     - Note:
     The property is **not** used to assign the `entityCode` property in each `Message` instance and exists as a convenience for referencing instances.
     */
    var entityCode: String

    
    /**
     A struct embedded inside an `EntityLog` struct that is used as a flattened representation of all data associated with each individual print number contained in an `EntityLog`.
     */
    struct Message: Codable, Equatable {
        /**
         A string representing the entity code of the EntityLog containing the print number.
              
         - Note:
         The value of the property will be the same for all print numbers contained in an EntityLog but will be different from other messages merged into the `MessageCollator``messages` dictionary.
         */
        var entityCode: String
        /// An Int representing the custom function number of the function that contains the print number node.
        var functionNumber: Int
        /**
         An Int representing the relative function number of the function that contains the print number with respect to the EntityLog.
                     
         The relative function number is the index number of the function as it is listed in the array keyed by `entity_functions` of the EntityLog JSON file.
         
         Function numbers are displayed as relative function numbers if the setting `calculateFunctionNumbersRelativeToEntity` is set to the bool value true.
                  
         - Note:
         The value returned from the `firstIndex(of:)->Self.Index?` used on the `kB21A` (`entity_functions`) array in the initialiser is unwrapped using the nil coalescing operator. If the value returned is nil `functionNumberInEntity` is set to -1 and incremented by 1 to return 0 ( a result that should never occur). Otherwise the value is simply incremented by 1 (to offset the zero indexing of arrays) and return the entity function's sequential position in the array.
         */
        var functionNumberInEntity: Int
        /**
         A Bool representing whether the function number of the function that contains the print number is always displayed as the custom value set in the EntityLog JSON file.
                            
         This property is used to override the general setting `calculateFunctionNumbersRelativeToEntity` for the particular function number.
         */
        var functionNumberAlwaysCustom: Bool
        /// An enum of type FunctionType representing the function type of the function that contains the print number.
        var functionType: FunctionType
        /// An enum of type NodeType representing the node type of the node containing the print number.
        var nodeType: NodeType
        /**
         An Int representing the relative node number of the node that contains the print number with respect to its function.
                     
         The relative node number is the index number of the node as it is listed in the array keyed by `function_nodes` of the EntityLog JSON file.
         
         Print numbers are displayed as relative node numbers if the setting `calculateNodeNumbersRelativeToFunction` is set to the bool value true.
                  
         - Note:
         The value returned from the `firstIndex(of:)->Self.Index?` used on the `kD31A` (`function_nodes`) array in the initialiser is unwrapped using the nil coalescing operator. If the value returned is nil `nodeNumberWithinFunction` is set to -1 and incremented by 1 to return 0 ( a result that should never occur). Otherwise the value is simply incremented by 1 (to offset the zero indexing of arrays) and return the node's sequential position in the array.
         */
        var nodeNumberWithinFunction: Int
        ///A string representing the event description of the node containing the print number.
        var eventDescription: String
        ///A string representing the effect description of the node containing the print number.
        var effectDescription: String
    }
}


extension EntityLog {
    /**
     An initialiser for EntityLog that takes an instance of EntityLogService and uses it to create a dictionary of `Message` structs that contain a flattened representation of all data associated with each print number.
     
     The initialiser also identifies any duplicate print numbers that exist in the EntityLog data and stores them in a static dictionary property on `MessageCollator`.
     */
    
    init(from service: EntityLogService) {
        entityCode = service.kA

        for kb21 in service.kB21A {
            let index = service.kB21A.firstIndex(of: kb21)
            let functionNumberInEntity = (index ?? -1) + 1

            for kd31 in kb21.kD31A {
                printNumbers.append(kd31.kE)
                let index = kb21.kD31A.firstIndex(of: kd31)
                let nodeNumberWithinFunction = (index ?? -1) + 1
                let entityCode = service.kA
                let functionNumber = kb21.kC
                let functionType = kb21.kJ
                let functionNumberAlwaysCustom = kb21.kI
                let nodeType = kd31.kF
                let eventDescription = kd31.kG
                let effectDescription = kd31.kH
                
                let messageObject = Message(entityCode: entityCode, functionNumber: functionNumber,functionNumberInEntity: functionNumberInEntity, functionNumberAlwaysCustom: functionNumberAlwaysCustom, functionType: functionType, nodeType: nodeType, nodeNumberWithinFunction: nodeNumberWithinFunction, eventDescription: eventDescription, effectDescription: effectDescription)
                
                messages[kd31.kE] = messageObject
            }
        }

        let duplicatePrintNumbers = Array(printNumbers)
        var uniqueDuplicatePrintNumbers = duplicatePrintNumbers.uniqueDuplicates()
        
        if uniqueDuplicatePrintNumbers.count == 1 && uniqueDuplicatePrintNumbers.first == 0 {
            uniqueDuplicatePrintNumbers.removeAll()
        }
        
        if !uniqueDuplicatePrintNumbers.isEmpty {
            MessageCollator.duplicatePrintNumbersKeyedByEntityCode[service.kA] = uniqueDuplicatePrintNumbers
        }
    }
}
