//
//  ClarityPrintPerformanceTests.swift
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

class ClarityPrintPerformanceTests: XCTestCase {

    // MARK: - ⏱ Tests - Performance
    func testPerformanceDecision() throws {
        // This is an example of a performance test case.
        self.measure {
            print(5)
        }
    }
    func testPerformanceSingleValue() throws {
        // This is an example of a performance test case.
         
        self.measure {
            print(206, values: "1")
        }
    }
    func testPerformanceValuesDictionary() throws {
        // This is an example of a performance test case.
        let someDic = ["a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9]
        self.measure {
            print(5, values:someDic)
        }
    }
    
    func testPerformanceValuesArray() throws {
        // This is an example of a performance test case.
        let someArray = [1,2,3,4,5]
        self.measure {
            print(5, values:someArray)
        }
    }
    
    func testPerformanceFunction() throws {
        // This is an example of a performance test case.
        
        self.measure {
            print(1, functionName: #function)
        }
    }

}

