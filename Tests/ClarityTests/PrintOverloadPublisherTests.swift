//
//  PrintOverloadPublisherTests.swift
//  ClarityTests
//
//  Created by Lawrie Development on 27/06/2022.
//

import XCTest
import Combine
@testable import Clarity

final class PrintOverloadPublisherTests: XCTestCase {

    func test_valuesForPublisherTypeVisualConsoleCheck()  {
         print(2, valuesForPublisherType: URLSession.DataTaskPublisher.self)
    }
    
    func test_publisherTypeValueReturnsExpectedOutputAndFailureType() {
        
        let myPublishertype = URLSession.DataTaskPublisher.self
        
        //This is the extract from print<T>(_ printNumber:valuesForPublisherType:settings:) that is difficut to isolate for testing
        //Be aware that if the function ever changes these lines this test could return a false pass
        let outputType = String(describing:  myPublishertype.Output.self)
        let failureType = String(describing:  myPublishertype.Failure.self)
        let publisherTypes = ["Output": outputType, "Failure": failureType]
        //....

        let dictionaryPrintValue = PrintValueType.dictionaryValue(dictionary: publisherTypes)
        var stringArray = [""]
        var expected = "Failure:URLError"

        if case .dictionaryValue(let dictionary) = dictionaryPrintValue {
            stringArray = printer.printCollectionValues(dictionary, withReadOutSpacer: "")
        }

        XCTAssertEqual(stringArray.sorted()[0],expected)
        expected = "Output:(data: Data, response: NSURLResponse)"
        XCTAssertEqual(stringArray.sorted()[1],expected)
    }

}
