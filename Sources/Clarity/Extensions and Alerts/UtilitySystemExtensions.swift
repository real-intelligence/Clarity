//
//  UtilitySystemExtensions.swift
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


extension String{
    /**
     A static extension method that returns a timestamp formatted as an non-breaking string.
     
     The  non-breaking format is intended as a convenience for adding a timestamp to a file name.
     - Returns: A timestamp formatted as a non-breaking string.
     */
    static func makeSimpleTimeStamp() -> Self {
        let timeStamp = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return formatter.string(from: timeStamp)
    }
}



extension Array where Element: Hashable {
    /**
     An extension method that returns an array of unique duplicate elements contained in an array.
     
     There are three main task phases to the method:
      1. Create a dictionary using the `init(grouping:by:)` initialiser whose keys are the grouping returned by each element in the original array.
      2. Filter the values of each grouping for those that have a count greater than 1. These will be the array values that have duplicates.
      3. Create a new array from the filtered keys of the dictionary. This will contain the unique duplicates of the original array.
     
     - Note
     The array element must conform to Hashable.

     - Returns: An array that contains the unique duplicate elements contained in the original array.
     */
    func uniqueDuplicates() -> Array {
        let groups = Dictionary(grouping: self, by: {$0})
        let duplicateGroups = groups.filter {$1.count > 1}
        let duplicates = Array(duplicateGroups.keys)
        
        return duplicates
    }
}


extension Int {
    
    /**
     An extension for a failable initialiser that initialises an Int from a Double.
     
     The initialiser will fail if the Double value is less than the minimum representable integer for an Int on the device or the Double value is more than the maximum representable integer for an Int on the device.
     
     - Parameters:
         - doubleValue: A Double value.
     */
    init?(doubleValue: Double) {
        guard (doubleValue <= Double(Int.max).nextDown) && (doubleValue >= Double(Int.min).nextUp) else {
            return nil
        }
        self.init(doubleValue)
    }
}


extension Array{

    /**
     An extension method that takes an `IndexSet` and uses it to mutate an array so that it only contains the values at the given indices.
     
     The use of IndexSet is predicated on the fact that it is a collection of increasing integers and can therefore be mapped onto the corresponding array element.
    
     There are two main task phases to the method:
      1. Ensure that the indices of the IndexSet are valid for the array by filtering the IndexSet so that it only contains indices with values less than the array count.
      2. Map each index to the corresponding array element mutating the original array with the return value.
     
     - Parameters:
         - indexes: An IndexSet.
     */
    mutating func arrayFromIndexes(_ indexes:IndexSet) {
         
        self = indexes.filteredIndexSet { $0 < self.count }.map { self[$0] }
        }
    }

extension String{
    /**
     An extension method that returns an Int representing the count value of the String that includes Apple symbols, letters, numbers and whitespace. Apple symbols have their count multiplied by 2.
     
     - Important
     Apple symbols return a character count value of 1 but use the space of two characters in the console.
     
     The method count calculation is predicated on the fact that a string assigned for a user symbol could include any combination of character types.
    
     There are three main task phases to the method:
      1. Use map and filter to return a count of Apple symbols in the string.
      2. Use map and filter to return a count of the other character types in the string.
      3. Return the value of the combined count after multiplying the Apple symbol count by 2 .
     */
    func symbolSpaceCount() -> Int {
        let symbols = self.map{$0.isSymbol}.filter{$0}.count
        let other = self.map{$0.isLetter || $0.isNumber  || $0.isWhitespace }.filter{$0}.count
        return (symbols * 2) + other
    }
}
