//
//  JSONAccess.swift
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



/**
 A protocol for decoding JSON data into models.
 
 The protocol has an extension that provides a default implementation of two non required methods that decode instances of a generic decoding service type from JSON files.
 */
protocol JSONAccess {
    /**
     A protocol method that is fired if an attempt to decode a JSON file by one of the protocol extension methods returns nil.
     
     - Parameters:
        - file: The last path component of the URL to the JSON file that returned nil on an attempt to decode it.
     */
    
    static func printAlertForCorruptJSON(for file: String)
}


extension JSONAccess{
    /**
     A method that decodes an instance of a generic decoder service type from a single JSON file.
     
     The method is designed to be used where a project resource directory contains a JSON file identifiable by name that is known to be valid for a decoder service type belonging to the target. The file can be decoded even where the directory contains multiple JSON files that require different service types.
     
     - Note
     The service type `T` used to decode the JSON file is inferred using the `self` keyword.  `self` refers to the variable that the return value of the method is assigned.
    
     - Important
     The method will only attempt to decode a JSON file that has the same name as passed to the parameter `resourceName`.
     
     - Parameters:
        - bundle: The bundle used to access the JSON file that requires decoding.
        - subdirectory: The name of an optional subdirectory in the main bundle containing the JSON file to be decoded.
        - resourceName: The name of the JSON file to be decoded (excluding the `.json` extension).
     
     - Returns: The specific decoder service instance decoded from the given JSON data or nil if there are no valid JSON files that can be decoded by the service type `T`.
     */
    static func decoderServiceFromBundle<T: Decodable>(_ bundle: Bundle, inSubdirectory subdirectory:String?, forResourceName resourceName:String) -> T?{
        let decoder = JSONDecoder()
        
        if let url = bundle.url(forResource: resourceName, withExtension: "json", subdirectory: subdirectory){
            do {
                let data = try Data(contentsOf: url)
                let managerService = try decoder.decode(T.self, from: data)
                return managerService
            } catch  {
                printAlertForCorruptJSON(for: url.lastPathComponent)
                return nil
            }
        }else{
            return nil
        }
    }
    
    /**
     A method that decodes an array of instances of a generic decoder service type from multiple JSON files.
     
     The method is designed to be used where a project resource directory contains multiple JSON files some of which are known to be valid for a decoder service type belonging to the target.
     
     Valid JSON files can be decoded if other files contained in the directory that require a different service type are known by name. The names of the files that require a different service type must be added to the optional `excludedFiles` array parameter argument. The method will then not attempt to decode any JSON file named in the array.
     
     - Note
     It is not necessary for the files of the service type to be decoded to be known by name.
     
     The service type `T` used to decode the JSON files is inferred using the `self` keyword.  `self` refers to the variable that the return value of the method is assigned.

     The return value is not an optional and will simply return an empty array if there are no valid JSON files in the bundle.
     
     The `excludedFiles` array can also be used to name specific JSON files of the required service type to prevent them from being decoded.
     
     - Parameters:
        - bundle: The bundle used to access the JSON files that require decoding.
        - subdirectory: The name of an optional subdirectory in the main bundle containing the JSON files to be decoded.
        - excludedFiles: An optional array of strings of the names of JSON files to exclude from being decoded ( including the `.json` extension)
     
     - Returns: An array of decoder service instances decoded from the given JSON data or an empty array if there are no valid JSON files that can be decoded by the service type `T`.
     */
    static func decoderServicesFromBundle<T: Decodable>(_ bundle: Bundle, inSubdirectory subdirectory:String, excludingFiles excludedFiles: [String]? = nil) -> [T] {

        let decoder = JSONDecoder()
        let urlsArray = bundle.urls(forResourcesWithExtension: "json", subdirectory: subdirectory)
        var logsArray = [T]()
        var goForDecode = true
        
        for url in urlsArray!{
            //1
            let tmp = url.lastPathComponent
            if let excludedFiles = excludedFiles{
                goForDecode = !excludedFiles.contains(tmp)
            }
            if goForDecode {
                do {
                    let data = try Data(contentsOf: url)
                    let log = try decoder.decode(T.self, from: data)
                    logsArray.append(log)
                } catch  {
                    printAlertForCorruptJSON(for: url.lastPathComponent)
                }
            }else{
                goForDecode = true
            }
        }
        return logsArray as [T]
    }
}


