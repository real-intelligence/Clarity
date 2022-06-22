//
//  SettingsManagerService.swift
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
A struct that is used as the top level container of a model used to decode JSON data from the <doc:Settings>  JSON file in the ClarityJSON folder
     */
public struct SettingsManagerService: Codable, Equatable {
    /// A Bool mapped to the `suppressAllClarityLogs` key in the Settings JSON data.
    var suppressAllClarityLogs: Bool
    /// A Bool mapped to the `printAllClarityLogs` key in the Settings JSON data
    var printAllClarityLogs: Bool
    /// A Bool mapped to the `logFunctionNamesOnly` key in the Settings JSON data
    var logFunctionNamesOnly: Bool
    /// A Bool mapped to the `logIsolatedPrintNumbersOnly` key in the Settings JSON data
    var logIsolatedPrintNumbersOnly: Bool
    /// A Bool mapped to the `isolatedPrintNumbers` key in the Settings JSON data
    var isolatedPrintNumbers: [Int]
    /// A Bool mapped to the `suppressLogFunctionNames` key in the Settings JSON data
    var suppressLogFunctionNames: Bool
    /// A Bool mapped to the `isolatedEntities` key in the Settings JSON data
    var isolatedEntities: [IsolatedEntity]
    /// A Bool mapped to the `isolatedFunctions` key in the Settings JSON data
    var isolatedFunctions: [IsolatedFunction]
    /// A Bool mapped to the `calculateFunctionNumbersRelativeToEntity` key in the Settings JSON data
    var calculateFunctionNumbersRelativeToEntity: Bool
    /// A Bool mapped to the `calculateNodeNumbersRelativeToFunction` key in the Settings JSON data
    var calculateNodeNumbersRelativeToFunction: Bool
    /// A Bool mapped to the `displayNodePrintNumberWhenUsingRelativeNumbering` key in the Settings JSON data
    var displayNodePrintNumberWhenUsingRelativeNumbering: Bool
    /// A Bool mapped to the `displayNodeSequenceWithoutDescriptions` key in the Settings JSON data
    var displayNodeSequenceWithoutDescriptions: Bool
    /// A Bool mapped to the `listAllUsedPrintNumbers` key in the Settings JSON data
    var listAllUsedPrintNumbers: Bool
    /// A Bool mapped to the `listAllUsedPrintNumbersByEntityCode` key in the Settings JSON data
    var listAllUsedPrintNumbersByEntityCode: Bool
    /// A Bool mapped to the `listHighestUsedPrintNumber` key in the Settings JSON data
    var listHighestUsedPrintNumber: Bool
    /// A Bool mapped to the `alertOrphanedPrintNumbersDetected` key in the Settings JSON data
    var alertOrphanedPrintNumbersDetected: Bool
    /**
     A struct embedded inside an ``SettingsManagerService`` struct that is used as a nested layer within an intermediate service model used to decode <doc:Settings> JSON data.
              
     The struct models an array of JSON objects mapped to the `isolatedEntities` key in the <doc:Settings> JSON data.
     */
    public struct IsolatedEntity: Codable, Equatable{
        /// A String mapped to the `entityCode` key in the array keyed by the `isolatedEntities` key in the <doc:Settings> JSON data.
        public var entityCode: String
        /// A Bool mapped to the `isolate` key in the array keyed by the `isolatedEntities` key in the <doc:Settings> JSON data.
        public var isolate: Bool
    }
    /**
     A struct embedded inside an ``SettingsManagerService`` struct that is used as a nested layer within an intermediate service model used to decode <doc:Settings> JSON data.
              
     The struct models an array of JSON objects mapped to the `isolatedFunctions` key in the <doc:Settings> JSON data.
     */
    public struct IsolatedFunction: Codable, Equatable{
        /// A String mapped to the `entityCode` key in the array keyed by the `isolatedFunctions` key in the <doc:Settings> JSON data.
        public var entityCode: String
        /// A Bool mapped to the `isolate` key in the array keyed by the `isolatedFunctions` key in the <doc:Settings> JSON data.
        public var isolate: Bool
        /// An Int array mapped to the `isolatedFunctionNumbers` key in the array keyed by the `isolatedFunctions` key in the <doc:Settings> JSON data.
        public var isolatedFunctionNumbers: [Int]
    }
}




