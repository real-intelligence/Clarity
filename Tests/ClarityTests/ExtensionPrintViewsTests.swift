//
//  ViewPrintTests.swift
//  ClarityTests
//
//  Created by Lawrie Development on 23/06/2022.
//

import XCTest
import SwiftUI



@testable import Clarity

struct MyView: View {
    var body: some View {
        return self
    }
}
struct MyViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
    }
}

final class ViewReturnPrintTests: XCTestCase {

    func test_assertPrintStatementReturnsAView()  {
        let view = MyView().body.print(5)
        XCTAssertNotNil(view)
        XCTAssert((view as Any) is (any View))
    }
    func test_assertFunctionNamePrintStatementReturnsAView()  {
        let view = MyView().body.print(5,functionName: #function)
        XCTAssertNotNil(view)
        XCTAssert((view as Any) is (any View))
    }
    func test_assertValueReporterPrintStatementReturnsAView()  {
        let view = MyView().body.print(5,values: 6)
        XCTAssertNotNil(view)
        XCTAssert((view as Any) is (any View))
    }

}

final class ViewReturnForViewModifierPrintTests: XCTestCase {

    func test_assertPrintStatementReturnsAView() {
        let view = MyViewModifier().print(5)
        XCTAssertNotNil(view)
        XCTAssert((view as Any) is (any View))
    }
    func test_assertFunctionNamePrintStatementReturnsAView()  {
        let view = MyViewModifier().print(5,functionName: #function)
        XCTAssertNotNil(view)
        XCTAssert((view as Any) is (any View))
    }
    func test_assertValueReporterPrintStatementReturnsAView()  {
        let view = MyViewModifier().print(5,values: 6)
        XCTAssertNotNil(view)
        XCTAssert((view as Any) is (any View))
    }
}





