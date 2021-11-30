//
//  macOS_ExampleApp.swift
//  macOS Example
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

import SwiftUI
import Clarity

enum EmployeeIssueError: Error{
    case engaged
    case nonqualified
    case vacation
}

extension EmployeeIssueError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .engaged:
            return NSLocalizedString("The employee is assigned to another task", comment: "engaged")
        case .nonqualified:
            return NSLocalizedString("The employee is not qualified for the assigned task", comment: "nonqualified")
        case .vacation:
            return NSLocalizedString("The employee is on vacation", comment: "vacation")
        }
    }
}


@main
struct macOS_ExampleApp: App {
    
    init() {

       // Automatic activation/deactivation
        ClarityActivator(withBundle: Bundle.main, inPrintMode: ClarityActivator.isClientInDebugMode, displayStatus: false)
        
        // Manual activation/deactivation (for XCFramework)
        //        ClarityActivator(withBundle: Bundle.main, inPrintMode: true, displayStatus: false)
        
        // Use case demo code
        print(1, functionName:#function)
        
        let x = 1
        if x==1 {
            print(2)
        }
        
        if x==2 {
        }else{
            print(3)
            helperFunction(x)
        }
        doTryCatchDemo(forEmployeeName: "Graham")
    }
    
    func helperFunction(_ intParameter:Int){
        print(199, functionName: #function)
        
        switch intParameter {
        case 1:
            print(201)
        default:
            print(202)
        }
        
        switch intParameter {
        case 5:
            print(203)
        default:
            print(202)
            if intParameter==1 {
                print(204)
                var newValue = intParameter
                incrementMyIntValue(&newValue)
                print(205, values: newValue)
            }
        }
    }
    
    func incrementMyIntValue(_ intParameter:inout Int){
        print(220, functionName: #function)
        intParameter+=1
    }
    
    func doTryCatchDemo(forEmployeeName name: String) {
        print(225, functionName: #function)
        let allocationData = ["task":5823, "employee":name] as [String : Any]
        
        do {
            print(226, values: allocationData)
            _ = try allocate(task: 5823, toEmployee: name)
            print(227)
            fakeActionMethodInImaginaryOtherModule()
        } catch {
            print(228, values: error)
            print(229)
            doTryCatchDemo(forEmployeeName: "Julie")
        }
    }
    
    func allocate(task: Int, toEmployee name: String) throws -> String {
        print(230, functionName: #function)
        if name == "Graham" {
            print(231)
            throw EmployeeIssueError.engaged
        }
        print(232)
        return "task allocated"
    }
    
    func fakeActionMethodInImaginaryOtherModule() {
        print(500, functionName: #function)
        print(501)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
