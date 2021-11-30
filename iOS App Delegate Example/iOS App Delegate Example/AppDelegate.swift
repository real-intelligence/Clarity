//
//  AppDelegate.swift
//  iOS App Delegate Example
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

import UIKit
import Clarity_iOS

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
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Activation
        ClarityActivator(withBundle: Bundle.main, inPrintMode: ClarityActivator.isClientInDebugMode, displayStatus: false)
        
        print(1, functionName:#function)
        
        let pet = "Dog"

        if pet=="Dog" {
            print(2)
        }

        if pet=="Cat" {
        }else{
            print(3)
            evaluateMyPet(pet)
        }
        doTryCatchDemo(forEmployeeName: "Graham")
        return true
    }
    
    
    func evaluateMyPet(_ petType:String){
        print(199, functionName: #function)
        
        switch petType {
        case "Dog":
            print(201)
        default:
            print(202)
        }
        // Second example
        switch petType {
        case "Cat":
            print(203)
        default:
            if petType=="Dog" {
                print(204)
                var newPet = petType
                
                changePet(&newPet)
                print(205, values: newPet)
            }
        }
    }
    
    func changePet(_ petType:inout String){
        print(220, functionName: #function)
        petType = "Rabbit"
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

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

