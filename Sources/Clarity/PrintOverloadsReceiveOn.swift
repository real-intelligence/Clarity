//
//  PrintOverloadsString.swift
//  Clarity
//
//  Created by Lawrie Development on 23/06/2022.
//

import Foundation
import Combine

extension Publishers.ReceiveOn{
    
    
    /// A method that acts as an overload of the Swift `Publishers.ReceiveOn` `print(_:to:)` method.
    ///
    /// This method serves to compile Clarity formatted log information and pass it to the `prefix` parameter of the Swift `Publishers.ReceiveOn` `print(_:to:)` method.
    /// It also ensures 'receive value' print output aligns with the output of other Clarity print statements.
    /// - Parameters:
    ///   - printNumber: An `Int` that acts as a unique number used as a key to access a specific associated message from a dictionary containing all message data.
    ///   - stream: A stream for text output that receives messages, and which directs output to the console by default. A custom stream can be used to log messages to other destinations. The argument to this parameter is passed directly to the `stream`parameter of the Swift `Publishers.ReceiveOn` `print(_:to:)` method.
    /// - Returns: A publisher that prints log messages for all publishing events – the result of a call to the Swift `Publishers.ReceiveOn` `print(_:to:)` method.
    public func print(_ printNumber: Int, to stream: TextOutputStream? = nil) -> Publishers.Print<Self>?{
    
        //Use extended method to ClarityPrintLogic to compile string prefix from the print number
        //If nil then it means Clarity is not set correctly any  print(_  to) method will revert to Swift version therefore simply pass an empty string
        guard let clarityPrefix =  printer.printLogic(printNumber) else{
            return nil
        }
        
        // Prevent a reversion to system version print(to:) printing if Clarity deactivated or settings disabled the print number involved in keeping with functionality of other print statements
        // Unwrapped nil will be passed to the publisher in this instance instead: the publisher  does  nothing in response
        if clarityPrefix == "" {
            return nil
        }
        //Note that Xcode Beta 14  displays system library methods as custom methods but this is calling the Swift version
        return print(clarityPrefix, to: stream)
        
       
        
        
    }
}

