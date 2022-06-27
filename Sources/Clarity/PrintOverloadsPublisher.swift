//
//  PrintOverloadsPublisher.swift
//  Clarity
//
//  Created by Lawrie Development on 27/06/2022.
//

import Foundation
import Combine






///  A public global function that formats and prints a message to the console corresponding to data stored as JSON for a given print number and behaves as an analogue overload of the Swift  [`print(_:separator:terminator:)`](https://developer.apple.com/documentation/swift/1541053-print) function.
///
///  This version of Clarity print statement takes a generic publisher type and outputs the `Output` and `Failure` type for the specific publisher in the form of a `Dictionary<String:String>` value formatted as a value reporter.
/// - Parameters:
///   - printNumber: An `Int` that acts as a unique number used as a key to access a specific associated message from a dictionary containing all message data.
///   - valuesForPublisherType: a generic publisher type.
///   - settings: An optional parameter for a dynamic ``SettingsManagerService`` instance. The ``SettingsManagerService`` instance can have its properties set programmatically to a variety of values. This enables more convenient and dynamic evaluation of a wider range of unit tests in a test target than is possible when using the JSON access mechanism.
public func print<T>(_ printNumber: Int,
                  valuesForPublisherType: T.Type,
                  settings: SettingsManagerService? = nil) where T: Publisher{
    
    if (ClarityActivator.isClientInDebugMode && ClarityActivator.isClientOverrideDebug == false) || ClarityActivator.isClientOverrideRelease{
        
        let outputType = String(describing:  T.Output.self)
        let failureType = String(describing:  T.Failure.self)
        let publisherTypes = ["Output": outputType, "Failure": failureType]
        
        
        printer.printLogic(printNumber, settings, nil, publisherTypes)
    }
}



