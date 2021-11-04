//
//  TestingUtilities.swift
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

import Foundation


// MARK: - 🛠 Utilities - Round trip JSON decoding
enum TestError: Error {
    case notEqual
    case dataCorrupt
}


func roundTripEncodeDecodeDataTest<T: Codable & Equatable>(codableInstance: T) throws {
    // Used by RoundTripJSONDecodingTests
    // Tests whether the instance type specified to match the JSON file is encodable and decodable into JSON data
    // This test is NOT suitable to test instance types that are flattened and therefore different from the JSON file structure
    // argument: item is an instance of the instance type
    //NB! The link to the JSON file depends on how makeSUT is implemented but NOT necessary - that is tested in testArchive
    
    //1. Encode an instance using Encoder
    //2. Decode the Data object using Decoder into an instance of type of the given expected instance
    //3. Test that the two instances are the same
    
    let encoder = JSONEncoder()
    let data = try encoder.encode(codableInstance)
    let decoder = JSONDecoder()
    let restoredInstance = try decoder.decode(T.self, from: data)
    
    if codableInstance != restoredInstance {
        print("Expected")
        dump(codableInstance)
        print("Actual")
        dump(restoredInstance)
        throw TestError.notEqual
    }else{
        print("roundTripEncodeDecodeDataTest succeeded")
    }
}




func roundtripArchiveJSONStringDecodeDataTest<T: Codable & Equatable>(json: String, codableInstance: T) throws {
    // Used by RoundTripJSONDecodingTests
    // Tests whether the instance derived from given json matches an object made to represent the given JSON
    // This test is NOT suitable to test instance types that are flattened and  therefore different from the JSON file structure
    // argument: json should therefore be the same as the one used to create the expected: argument instance for test to make sense
    // Designed to fail if wrong json file accessed
    
    //1. Encode the JSON string into a Data object using: .utf8
    //2. Decode the Data object using Decoder into an instance of type of the given codableInstance instance
        //(Attempts to decode the data according to the TYPE of the incoming expected: argument object)
    //3. Test that the two instances are the same
    
    guard let data = json.data(using: .utf8) else {
        throw TestError.dataCorrupt
    }
    let decoder = JSONDecoder()
    let restoredInstance = try decoder.decode(T.self, from: data)
    if codableInstance != restoredInstance {
        print("Expected")
        dump(codableInstance)
        print("Actual")
        dump(restoredInstance)
        throw TestError.notEqual
    }else{
        print("roundtripArchiveJSONStringDecodeDataTest succeeded")
    }
}


func combinedEntityLogs() -> String{
    // Used by RoundTripJSONDecodingTests
    
    //To allow archive test to test multiple json files combined into an array
    let logtmp = EntityLogServiceTests.entityLogServiceArray
    let encoder = JSONEncoder()
    let data = try! encoder.encode(logtmp)
    
    let str = String(decoding: data, as: UTF8.self)
    return str
}


// MARK: - 🛠 Utilities - CompilePrintStringMethodsTests

func indexesWithUnequalValues(_ array1: [String],_ array2: [String]) -> [Int]  {
    // Used by CompilePrintStringMethodsTests > Tests -  compileSequentialComposite(_:_:_:_:_:_:_:)
    
    // NOTE: Could be made into an array extention would need to have first array as self
    // ... however Prefer the look of parameters side by side - more expressive in the tests
    let indexesContainingUnequalValues = zip(array1, array2).enumerated().filter {$1.0 != $1.1}.map {$0.offset}
    return indexesContainingUnequalValues
}

// MARK: - 🛠 Utilities - ClarityActivatorTests
extension String {
    //For use by ClarityActivatorTests used to compile substrings from alert messages so that they are capabable of being tested by XCTAssert_ methods
  subscript (r: CountableClosedRange<Int>) -> String {
    let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
    let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
    return String(self[startIndex...endIndex])
  }
}
