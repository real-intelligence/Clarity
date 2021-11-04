//
//  RoundTripJSONDecodingTests.swift
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

class RoundTripJSONDecodingTests: XCTestCase {
    
    // MARK: - 🦮 Helpers -  data from JSON file
    static func dataFromJsonFile(_ jsonFileName:String) -> Data {
        let frameworkBundle = Bundle(for: ClarityActivator.self)
        let url1 = frameworkBundle.url(forResource: jsonFileName, withExtension: "json", subdirectory:  "ClarityJSON")!
        return try! Data(contentsOf: url1)
    }
    
    var singleEntityLogService: EntityLogService = {
        let data1 = dataFromJsonFile("ABCD")
        
        let decoder = JSONDecoder()
        var log1 = try! decoder.decode(EntityLogService.self, from: data1)
        
        return log1
    }()
    
    
    // MARK: - 🦮 Helpers -  data from ClarityActivator
    // Special utility function because EntityLogService are compiled from multiple JSON files into an array
    var makeEntityLogServiceArraySUT: [EntityLogService]{
        return ClarityActivator.entityLogServiceArray
    }
    
    
    // MARK: - 🧪 Tests -  single EntityLogService round trip tests
    func test_CodableEntityLogService() throws {
        try roundTripEncodeDecodeDataTest(codableInstance: singleEntityLogService)
    }
    
    func test_ArchiveEntityLogService() throws {
        let data1 = RoundTripJSONDecodingTests.dataFromJsonFile("ABCD")
        let str = String(decoding: data1, as: UTF8.self)
        try roundtripArchiveJSONStringDecodeDataTest(json: str, codableInstance: singleEntityLogService)
    }
    
    // MARK: - 🧪 Tests -  multiple EntityLogService round trip tests
    func test_CodableEntityLogServiceArray() throws {
        try roundTripEncodeDecodeDataTest(codableInstance: makeEntityLogServiceArraySUT)
    }
    
    func test_ArchiveEntityLogServiceArray() throws {
        // This test seems redundant because there is no json file containing the array of data that is in actuality contained in separate json files
        // ... It has to be encoded first using the same EntityLogServiceTests logs (that this test tests against so they will always be the same)
        // The single EntityLogService does however get the JSON directly and is a true archive test hence reason to keep
        let jsonStrings = combinedEntityLogs()
        try roundtripArchiveJSONStringDecodeDataTest(json: jsonStrings, codableInstance: makeEntityLogServiceArraySUT)
    }
    
    // MARK: - 🧪 Tests -  SettingsManagerService round trip tests
    func test_SettingsService() throws {
        try roundTripEncodeDecodeDataTest(codableInstance:ClarityActivator.settings)
    }
    
    func test_ArchiveSettingsService() throws {
        let data1 = RoundTripJSONDecodingTests.dataFromJsonFile("Settings")
        let str = String(decoding: data1, as: UTF8.self)
        try roundtripArchiveJSONStringDecodeDataTest(json: str, codableInstance: ClarityActivator.settings)
    }
    
    // MARK: - 🧪 Tests -  FormattingManagerService round trip tests
    func test_FormattingService() throws {
        try roundTripEncodeDecodeDataTest(codableInstance:ClarityActivator.formatting)
    }
    
    func test_ArchiveFormattingService() throws {
        let data1 = RoundTripJSONDecodingTests.dataFromJsonFile("Formatting")
        let str = String(decoding: data1, as: UTF8.self)
        try roundtripArchiveJSONStringDecodeDataTest(json: str, codableInstance: ClarityActivator.formatting)
    }
    
    func test_ValidateClarityJSONDirectory() {
        //This test will only return true for verified files when the activation is go as certified by DEBUG mode or user overrides of print mode
        let bundle = Bundle(for: ClarityActivator.self)
        let verified = ClarityActivator.verifyClarityJSONDirectory(forBundle: bundle)
        XCTAssertTrue(verified)
    }
    
}

