//
//  ClarityActivatorTests.swift
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

class ClarityActivatorTests: XCTestCase {
    
    var line1 = ""
    var line2 = ""
    var line3 = ""
    var line4 = ""
    var line5 = ""
    var line6 = ""
    var line7 = ""
    var line8 = ""
    var line9 = ""
    

    let characterLineBreak = 2 // next character + next line break
    let characterDoubleLineBreak = 3 // next character + next line double break
    
    // MARK: - Test correct directoryState enum case evaluation for  all missing ClarityJSON folder and file combinations
    func test_SettingsFalse_FormattingFalse_EntityLogsFalse_ReturnDirectoryState_NoDirectoryOrEmptyDirectory() throws {
        
        var directoryState = ClarityActivator.ClarityJSONDirectoryState.allFilesPresent
        
        let isSettingsFile = false
        let isFormattingFile = false
        let isEntityLogFiles = false
        
        ClarityActivator.verifyClarityFiles(isSettingsFile, isFormattingFile, isEntityLogFiles, &directoryState)
        
        XCTAssertEqual(directoryState, .noDirectoryOrEmptyDirectory)
    }
    
    func test_SettingsTrue_FormattingTrue_EntityLogsFalse_ReturnDirectoryState_NoEntityLogs() throws {
        
        var directoryState = ClarityActivator.ClarityJSONDirectoryState.allFilesPresent
        
        let isSettingsFile = true
        let isFormattingFile = true
        let isEntityLogFiles = false
        
        ClarityActivator.verifyClarityFiles(isSettingsFile, isFormattingFile, isEntityLogFiles, &directoryState)
        
        XCTAssertEqual(directoryState, .noEntityLogs)
    }
    
    func test_SettingsFalse_FormattingTrue_EntityLogsTrue_ReturnDirectoryState_MissingPrefFileSettings() throws {
        
        var directoryState = ClarityActivator.ClarityJSONDirectoryState.allFilesPresent
        
        let isSettingsFile = false
        let isFormattingFile = true
        let isEntityLogFiles = true
        
        ClarityActivator.verifyClarityFiles(isSettingsFile, isFormattingFile, isEntityLogFiles, &directoryState)
        
        XCTAssertEqual(directoryState, .missingPreferenceFile(missingFileType: "Settings"))
    }
    
    func test_SettingsTrue_FormattingFalse_EntityLogsTrue_ReturnDirectoryState_MissingPrefFileFormatting() throws {
        
        var directoryState = ClarityActivator.ClarityJSONDirectoryState.allFilesPresent
        
        let isSettingsFile = true
        let isFormattingFile = false
        let isEntityLogFiles = true
        
        ClarityActivator.verifyClarityFiles(isSettingsFile, isFormattingFile, isEntityLogFiles, &directoryState)
        
        XCTAssertEqual(directoryState, .missingPreferenceFile(missingFileType: "Formatting"))
    }
    
    func test_SettingsFalse_FormattingFalse_EntityLogsTrue_ReturnDirectoryState_MissingPrefFiles() throws {
        
        var directoryState = ClarityActivator.ClarityJSONDirectoryState.allFilesPresent
        
        let isSettingsFile = false
        let isFormattingFile = false
        let isEntityLogFiles = true
        
        ClarityActivator.verifyClarityFiles(isSettingsFile, isFormattingFile, isEntityLogFiles, &directoryState)
        
        XCTAssertEqual(directoryState, .missingPreferenceFiles)
    }
    
    
    func test_SettingsFalse_FormattingTrue_EntityLogsFalse_ReturnDirectoryState_NoEntityLogsMissingPrefFileSettings() throws {
        
        var directoryState = ClarityActivator.ClarityJSONDirectoryState.allFilesPresent
        
        let isSettingsFile = false
        let isFormattingFile = true
        let isEntityLogFiles = false
        
        ClarityActivator.verifyClarityFiles(isSettingsFile, isFormattingFile, isEntityLogFiles, &directoryState)
        
        XCTAssertEqual(directoryState, .noEntityLogsMissingPreferenceFile(missingFileType: "Settings"))
    }
    
    func test_SettingsFalse_FormattingTrue_EntityLogsFalse_ReturnDirectoryState_NoEntityLogsMissingPrefFileFormatting() throws {
        
        var directoryState = ClarityActivator.ClarityJSONDirectoryState.allFilesPresent
        
        let isSettingsFile = true
        let isFormattingFile = false
        let isEntityLogFiles = false
        
        ClarityActivator.verifyClarityFiles(isSettingsFile, isFormattingFile, isEntityLogFiles, &directoryState)
        
        XCTAssertEqual(directoryState, .noEntityLogsMissingPreferenceFile(missingFileType: "Formatting"))
    }
    
    
    // MARK: - Test conditional string compilation for all missing ClarityJSON folder and file combinations
    // Each conducted for all three possible copy default folder/file outcomes
    // Note: Future version – the alert system could change to take message strings from internal JSON making testing much more efficient and flexible – though it wouldn't solve the XCTAssert_ rendering line breaks issue
    
    
    func test_printAlertForMissingFile_AllFilesPresent_ReturnsEmptyString() throws{
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.allFilesPresent
        let missingFileName = ""
        let backupComponent = ""
        
        let printString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.replaceCopy(newName: backupComponent)))
        print(printString)
        XCTAssertEqual(printString, "")
    }
    
    // Alert string tests...
    //Necessary to break into separate lines - seemingly impossible to represent the \n line break gaps returned by the XCTAssertEqual as a single string

    //Uses extension on String to index/subscript into strings for substrings with an integer range instead of more cumbersome String.Index range
    // lineBeginIndex –  (index start) indexing in +1 character to skip first line break character
    // takes into account skipping the first line break character hence adding 1 for the line breaks minus 1 for the line lengths
    // lineEndIndex == new line  index end (line length) always minus 1 because of the start skip
    //OutputString count should equal final e count  + 1 for the skippied line break (character 0) + 1 for the line break after final line
    //This check required to ensure no missing/additional lines
    
    // lineBeginIndex shortened to 'b' for subsequent tests
    // lineEndIndex shortened to 'e' for subsequent tests
    // (easier to read)
    
    func test_printNoDirectoryOrEmptyDirectoryPristineCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.noDirectoryOrEmptyDirectory
        let missingFileName = ""
       
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.pristineCopy))
        
        var lineBeginIndex = 1
        var lineEndIndex = 64
    
        line1 = outputString[lineBeginIndex...lineEndIndex]
        lineBeginIndex = lineEndIndex+characterLineBreak
        lineEndIndex = lineBeginIndex+89
        line2 = outputString[lineBeginIndex...lineEndIndex]
        lineBeginIndex = lineEndIndex+characterDoubleLineBreak
        lineEndIndex = lineBeginIndex+87
        line3 = outputString[lineBeginIndex...lineEndIndex]
        lineBeginIndex = lineEndIndex+characterLineBreak
        lineEndIndex = lineBeginIndex+79
        line4 = outputString[lineBeginIndex...lineEndIndex]
        lineBeginIndex = lineEndIndex+characterLineBreak
        lineEndIndex = lineBeginIndex+61
        line5 = outputString[lineBeginIndex...lineEndIndex]
        lineBeginIndex = lineEndIndex+characterDoubleLineBreak
        lineEndIndex = lineBeginIndex+90
        line6 = outputString[lineBeginIndex...lineEndIndex]
        lineBeginIndex = lineEndIndex+characterLineBreak
        lineEndIndex = lineBeginIndex+87
        line7 = outputString[lineBeginIndex...lineEndIndex]
        lineBeginIndex = lineEndIndex+characterDoubleLineBreak
        lineEndIndex = lineBeginIndex+89
        line8 = outputString[lineBeginIndex...lineEndIndex]
        
        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required directory ClarityJSON was NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the ClarityJSON folder to the desktop.")
        XCTAssertEqual(line4, "If this is the first run of an application after embedding the Clarity framework")
        XCTAssertEqual(line5, "the ClarityJSON folder will need to be copied to your project.")
        XCTAssertEqual(line6, "Otherwise please relocate the original ClarityJSON folder and copy it back into the project")
        XCTAssertEqual(line7, "or copy the default version as a replacement if the original has been lost or corrupted.")
        XCTAssertEqual(line8, "...A default version of the ClarityJSON folder has been successfully copied to the desktop")
   
        XCTAssertEqual(outputCharacterCount, lineEndIndex+2)
    }
    
    
    
    func test_printNoDirectoryOrEmptyDirectoryReplaceCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.noDirectoryOrEmptyDirectory
        let missingFileName = ""
        let backupComponent = "newname"
        
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.replaceCopy(newName: backupComponent)))
        
        var b = 1
        var e = 64
         
        line1 = outputString[b...e]
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        b = e+characterDoubleLineBreak
        e = b+87
        line3 = outputString[b...e]
        b = e+characterLineBreak
        e = b+79
        line4 = outputString[b...e]
        b = e+characterLineBreak
        e = b+61
        line5 = outputString[b...e]
        b = e+characterDoubleLineBreak
        e = b+90
        line6 = outputString[b...e]
        b = e+characterLineBreak
        e = b+87
        line7 = outputString[b...e]
        b = e+characterDoubleLineBreak
        e = b+89
        line8 = outputString[b...e]
        b = e+characterDoubleLineBreak
        e = b+100
        line9 = outputString[b...e]
        
        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required directory ClarityJSON was NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the ClarityJSON folder to the desktop.")
        XCTAssertEqual(line4, "If this is the first run of an application after embedding the Clarity framework")
        XCTAssertEqual(line5, "the ClarityJSON folder will need to be copied to your project.")
        XCTAssertEqual(line6, "Otherwise please relocate the original ClarityJSON folder and copy it back into the project")
        XCTAssertEqual(line7, "or copy the default version as a replacement if the original has been lost or corrupted.")
        XCTAssertEqual(line8, "...A default version of the ClarityJSON folder has been successfully copied to the desktop")
        XCTAssertEqual(line9, "❕An item named ClarityJSON folder was already located on the desktop – it has been renamed to newname")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printNoDirectoryOrEmptyDirectoryFailureToCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        
        let error: Error = NSError(domain:"", code: 401, userInfo: [NSLocalizedDescriptionKey: " copy fail"])
        
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.noDirectoryOrEmptyDirectory
        let missingFileName = ""
        
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .failure(error))
        
        var b = 1
        var e = 64
         
        line1 = outputString[b...e]
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        b = e+characterDoubleLineBreak
        e = b+87
        line3 = outputString[b...e]
        b = e+characterLineBreak
        e = b+79
        line4 = outputString[b...e]
        b = e+characterLineBreak
        e = b+61
        line5 = outputString[b...e]
        b = e+characterDoubleLineBreak
        e = b+90
        line6 = outputString[b...e]
        b = e+characterLineBreak
        e = b+87
        line7 = outputString[b...e]
        b = e+characterDoubleLineBreak
        e = b+85 //  minus 2 to skip line break at beginning of line
        line8 = outputString[b...e]
        b = e+characterLineBreak
        e = b+20
        line9 = outputString[b...e]

        
        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required directory ClarityJSON was NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the ClarityJSON folder to the desktop.")
        XCTAssertEqual(line4, "If this is the first run of an application after embedding the Clarity framework")
        XCTAssertEqual(line5, "the ClarityJSON folder will need to be copied to your project.")
        XCTAssertEqual(line6, "Otherwise please relocate the original ClarityJSON folder and copy it back into the project")
        XCTAssertEqual(line7, "or copy the default version as a replacement if the original has been lost or corrupted.")
        XCTAssertEqual(line8, "❗️An attempt to copy a default version of the ClarityJSON folder to the desktop failed ")
        XCTAssertEqual(line9, "with error  copy fail")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printNoEntityLogsPristineCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        
        
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.noEntityLogs
        let missingFileName = ""
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.pristineCopy))
        
        var b = 1
        var e = 64
        
        line1 = outputString[b...e]
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+128
        line3 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+83 //+1 to skip line break at beginning of line
        line4 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+99
        line5 = outputString[b...e]
        b = e+characterDoubleLineBreak
        e = b+130
        line6 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required EntityLog JSON files were NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the template EntityLog JSON files in a folder named ClarityJSON to the desktop.")
        XCTAssertEqual(line4, "Please relocate your custom EntityLog JSON files and copy them back into the project")
        XCTAssertEqual(line5, "or copy the default template versions as a replacement if the originals have been lost or corrupted.")
        XCTAssertEqual(line6, "...A default version of the template EntityLog JSON files in a folder named ClarityJSON has been successfully copied to the desktop")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printNoEntityLogsReplaceCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        
        
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.noEntityLogs
        let missingFileName = ""
        let backupComponent = "newname"
        
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.replaceCopy(newName: backupComponent)))
        
        var b = 1
        var e = 64
         
        line1 = outputString[b...e]
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+128
        line3 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+83 //+1 to skip line break at beginning of line
        line4 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+99
        line5 = outputString[b...e]
        b = e+characterDoubleLineBreak
        e = b+130
        line6 = outputString[b...e]
        b = e+characterDoubleLineBreak
        e = b+100
        line7 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required EntityLog JSON files were NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the template EntityLog JSON files in a folder named ClarityJSON to the desktop.")
        XCTAssertEqual(line4, "Please relocate your custom EntityLog JSON files and copy them back into the project")
        XCTAssertEqual(line5, "or copy the default template versions as a replacement if the originals have been lost or corrupted.")
        XCTAssertEqual(line6, "...A default version of the template EntityLog JSON files in a folder named ClarityJSON has been successfully copied to the desktop")
        XCTAssertEqual(line7, "❕An item named ClarityJSON folder was already located on the desktop – it has been renamed to newname")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    
    
    func test_printNoEntityLogsFailureToCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        
        
        let error: Error = NSError(domain:"", code: 401, userInfo: [NSLocalizedDescriptionKey: " copy fail"])
        
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.noEntityLogs
        let missingFileName = ""
        
        
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .failure(error))
        
        var b = 1
        var e = 64
         
        line1 = outputString[b...e]
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+128
        line3 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+83//+1 to skip line break at beginning of line
        line4 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+99
        line5 = outputString[b...e]
        b = e+characterDoubleLineBreak
        e = b+126 //minus 2 to skip line break at beginning of line
        line6 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+20
        line7 = outputString[b...e]


        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required EntityLog JSON files were NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the template EntityLog JSON files in a folder named ClarityJSON to the desktop.")
        XCTAssertEqual(line4, "Please relocate your custom EntityLog JSON files and copy them back into the project")
        XCTAssertEqual(line5, "or copy the default template versions as a replacement if the originals have been lost or corrupted.")
        XCTAssertEqual(line6, "❗️An attempt to copy a default version of the template EntityLog JSON files in a folder named ClarityJSON to the desktop failed ")
        XCTAssertEqual(line7, "with error  copy fail")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printMissingPreferenceFilesPristineCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        
        
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.missingPreferenceFiles
        let missingFileName = ""
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.pristineCopy))
        

        var b = 1
        var e = 94
         
        line1 = outputString[b...e]
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+115
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+105
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+90
        line5 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+117
        line6 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required Settings.json and Formatting.json preference files were NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the preference files in a folder named ClarityJSON to the desktop.")
        XCTAssertEqual(line4, "Please relocate your custom preference files and place them back in the ClarityJSON folder in your project")
        XCTAssertEqual(line5, "or copy the default versions as a replacement if the originals have been lost or corrupted.")
        XCTAssertEqual(line6, "...A default version of the preference files in a folder named ClarityJSON has been successfully copied to the desktop")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printMissingPreferenceFilesReplaceCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = ""
        let backupComponent = "newname"
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.missingPreferenceFiles
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.replaceCopy(newName: backupComponent)))
        
        var b = 1
        var e = 94
       
        line1 = outputString[b...e]
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+115
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+105
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+90
        line5 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+117
        line6 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+100
        line7 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required Settings.json and Formatting.json preference files were NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the preference files in a folder named ClarityJSON to the desktop.")
        XCTAssertEqual(line4, "Please relocate your custom preference files and place them back in the ClarityJSON folder in your project")
        XCTAssertEqual(line5, "or copy the default versions as a replacement if the originals have been lost or corrupted.")
        XCTAssertEqual(line6, "...A default version of the preference files in a folder named ClarityJSON has been successfully copied to the desktop")
        XCTAssertEqual(line7, "❕An item named ClarityJSON folder was already located on the desktop – it has been renamed to newname")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printMissingPreferenceFilesFailureToCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = ""
        let error: Error = NSError(domain:"", code: 401, userInfo: [NSLocalizedDescriptionKey: " copy fail"])
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.missingPreferenceFiles
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .failure(error))
        
        var b = 1
        var e = 94
        line1 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+115
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+105
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+90
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+113
        line6 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+20
        line7 = outputString[b...e]


        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required Settings.json and Formatting.json preference files were NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the preference files in a folder named ClarityJSON to the desktop.")
        XCTAssertEqual(line4, "Please relocate your custom preference files and place them back in the ClarityJSON folder in your project")
        XCTAssertEqual(line5, "or copy the default versions as a replacement if the originals have been lost or corrupted.")
        XCTAssertEqual(line6, "❗️An attempt to copy a default version of the preference files in a folder named ClarityJSON to the desktop failed ")
        XCTAssertEqual(line7, "with error  copy fail")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    //😐😐😐😐😐😐😐😐😐😐😐😐😐😐😐😐
    

    func test_printMissingPreferenceFileSettingsPristineCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        
        let missingFileName = "Settings"
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.missingPreferenceFile(missingFileType: missingFileName)
       
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.pristineCopy))
        
        var b = 1
        var e = 61
        line1 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+87
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+100
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+93
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+89
        line6 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required file Settings.json was NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the Settings.json file to the desktop.")
        XCTAssertEqual(line4, "Please relocate your Settings.json file and place it back into the ClarityJSON folder in your project")
        XCTAssertEqual(line5, "or copy the default Settings.json as a replacement if the original has been lost or corrupted.")
        XCTAssertEqual(line6, "...A default version of the Settings.json file has been successfully copied to the desktop")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printMissingPreferenceFileSettingsReplaceCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = "Settings"
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.missingPreferenceFile(missingFileType: missingFileName)

        let backupComponent = "newname"
        
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.replaceCopy(newName: backupComponent)))
        
        var b = 1
        var e = 61
        line1 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+87
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+100
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+93
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+89
        line6 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+100
        line7 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required file Settings.json was NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the Settings.json file to the desktop.")
        XCTAssertEqual(line4, "Please relocate your Settings.json file and place it back into the ClarityJSON folder in your project")
        XCTAssertEqual(line5, "or copy the default Settings.json as a replacement if the original has been lost or corrupted.")
        XCTAssertEqual(line6, "...A default version of the Settings.json file has been successfully copied to the desktop")
        XCTAssertEqual(line7, "❕An item named Settings.json file was already located on the desktop – it has been renamed to newname")

        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printMissingPreferenceFileSettingsFailureToCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = "Settings"
        
        let error: Error = NSError(domain:"", code: 401, userInfo: [NSLocalizedDescriptionKey: " copy fail"])
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.missingPreferenceFile(missingFileType: missingFileName)
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .failure(error))
        
        var b = 1
        var e = 61
        //raw Int = new line  index end (minus 1)
        line1 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+87
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+100
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+93
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+85
        line6 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+20
        line7 = outputString[b...e]


        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required file Settings.json was NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the Settings.json file to the desktop.")
        XCTAssertEqual(line4, "Please relocate your Settings.json file and place it back into the ClarityJSON folder in your project")
        XCTAssertEqual(line5, "or copy the default Settings.json as a replacement if the original has been lost or corrupted.")
        XCTAssertEqual(line6, "❗️An attempt to copy a default version of the Settings.json file to the desktop failed ")
        XCTAssertEqual(line7, "with error  copy fail")

        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    //😐😐😐😐😐😐😐😐😐😐😐😐😐😐😐😐
    func test_printMissingPreferenceFileFormattingPristineCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = "Formatting"
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.missingPreferenceFile(missingFileType: missingFileName)
       
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.pristineCopy))
        
        var b = 1
        var e = 63
         
        line1 = outputString[b...e]
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+89
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+102
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+95
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+91
        line6 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required file Formatting.json was NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the Formatting.json file to the desktop.")
        XCTAssertEqual(line4, "Please relocate your Formatting.json file and place it back into the ClarityJSON folder in your project")
        XCTAssertEqual(line5, "or copy the default Formatting.json as a replacement if the original has been lost or corrupted.")
        XCTAssertEqual(line6, "...A default version of the Formatting.json file has been successfully copied to the desktop")

        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printMissingPreferenceFileFormattingReplaceCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = "Formatting"
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.missingPreferenceFile(missingFileType: missingFileName)

        let backupComponent = "newname"
        
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.replaceCopy(newName: backupComponent)))
        
        var b = 1
        var e = 63
        line1 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+89
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+102
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+95
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+91
        line6 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+102
        line7 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required file Formatting.json was NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the Formatting.json file to the desktop.")
        XCTAssertEqual(line4, "Please relocate your Formatting.json file and place it back into the ClarityJSON folder in your project")
        XCTAssertEqual(line5, "or copy the default Formatting.json as a replacement if the original has been lost or corrupted.")
        XCTAssertEqual(line6, "...A default version of the Formatting.json file has been successfully copied to the desktop")
        XCTAssertEqual(line7, "❕An item named Formatting.json file was already located on the desktop – it has been renamed to newname")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printMissingPreferenceFileFormattingFailureToCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = "Formatting"
        
        let error: Error = NSError(domain:"", code: 401, userInfo: [NSLocalizedDescriptionKey: " copy fail"])
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.missingPreferenceFile(missingFileType: missingFileName)
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .failure(error))
        
        var b = 1
        var e = 63
        line1 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+89
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+102
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+95
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+87
        line6 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+20
        line7 = outputString[b...e]


        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required file Formatting.json was NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the Formatting.json file to the desktop.")
        XCTAssertEqual(line4, "Please relocate your Formatting.json file and place it back into the ClarityJSON folder in your project")
        XCTAssertEqual(line5, "or copy the default Formatting.json as a replacement if the original has been lost or corrupted.")
        XCTAssertEqual(line6, "❗️An attempt to copy a default version of the Formatting.json file to the desktop failed ")
        XCTAssertEqual(line7, "with error  copy fail")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    
    
    //😐😐😐😐😐😐😐😐😐😐😐😐😐😐😐😐
    func test_printNoEntityLogsMissingPreferenceFileSettingsPristineCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = "Settings"
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.noEntityLogsMissingPreferenceFile(missingFileType: missingFileName)
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.pristineCopy))
        
        var b = 1
        var e = 96
        line1 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+116
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+68
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+90
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+118
        line6 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required EntityLog JSON files and required Settings.json file were NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the ClarityJSON folder containing the missing items to the desktop.")
        XCTAssertEqual(line4, "Please relocate your custom files and copy them back into the project")
        XCTAssertEqual(line5, "or copy the default versions as a replacement if the originals have been lost or corrupted.")
        XCTAssertEqual(line6, "...A default version of the ClarityJSON folder containing the missing items has been successfully copied to the desktop")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printNoEntityLogsMissingPreferenceFileSettingsReplaceCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = "Settings"
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.noEntityLogsMissingPreferenceFile(missingFileType: missingFileName)
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.replaceCopy(newName: "ClarityJSON")))
        
        var b = 1
        var e = 96
        line1 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+116
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+68
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+90
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+118
        line6 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+104
        line7 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required EntityLog JSON files and required Settings.json file were NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the ClarityJSON folder containing the missing items to the desktop.")
        XCTAssertEqual(line4, "Please relocate your custom files and copy them back into the project")
        XCTAssertEqual(line5, "or copy the default versions as a replacement if the originals have been lost or corrupted.")
        XCTAssertEqual(line6, "...A default version of the ClarityJSON folder containing the missing items has been successfully copied to the desktop")
        XCTAssertEqual(line7, "❕An item named ClarityJSON folder was already located on the desktop – it has been renamed to ClarityJSON")

        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printNoEntityLogsMissingPreferenceFileSettingsFailureToCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = "Settings"
        let error: Error = NSError(domain:"", code: 401, userInfo: [NSLocalizedDescriptionKey: " copy fail"])
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.noEntityLogsMissingPreferenceFile(missingFileType: missingFileName)
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .failure(error))
        
        var b = 1
        var e = 96
        line1 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+116
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+68
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+90
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+114
        line6 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+20
        line7 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required EntityLog JSON files and required Settings.json file were NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the ClarityJSON folder containing the missing items to the desktop.")
        XCTAssertEqual(line4, "Please relocate your custom files and copy them back into the project")
        XCTAssertEqual(line5, "or copy the default versions as a replacement if the originals have been lost or corrupted.")
        XCTAssertEqual(line6, "❗️An attempt to copy a default version of the ClarityJSON folder containing the missing items to the desktop failed ")
        XCTAssertEqual(line7, "with error  copy fail")

        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    //😐😐😐😐😐😐😐😐😐😐😐😐😐😐😐😐
    

    func test_printNoEntityLogsMissingPreferenceFileFormattingPristineCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = "Formatting"
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.noEntityLogsMissingPreferenceFile(missingFileType: missingFileName)
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.pristineCopy))
        
        var b = 1
        var e = 98
        line1 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+116
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+68
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+90
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+118
        line6 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required EntityLog JSON files and required Formatting.json file were NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the ClarityJSON folder containing the missing items to the desktop.")
        XCTAssertEqual(line4, "Please relocate your custom files and copy them back into the project")
        XCTAssertEqual(line5, "or copy the default versions as a replacement if the originals have been lost or corrupted.")
        XCTAssertEqual(line6, "...A default version of the ClarityJSON folder containing the missing items has been successfully copied to the desktop")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printNoEntityLogsMissingPreferenceFileFormattingReplaceCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = "Formatting"
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.noEntityLogsMissingPreferenceFile(missingFileType: missingFileName)
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .success(.replaceCopy(newName: "ClarityJSON")))
        
        var b = 1
        var e = 98
        line1 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+116
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+68
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+90
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+118
        line6 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+104
        line7 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required EntityLog JSON files and required Formatting.json file were NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the ClarityJSON folder containing the missing items to the desktop.")
        XCTAssertEqual(line4, "Please relocate your custom files and copy them back into the project")
        XCTAssertEqual(line5, "or copy the default versions as a replacement if the originals have been lost or corrupted.")
        XCTAssertEqual(line6, "...A default version of the ClarityJSON folder containing the missing items has been successfully copied to the desktop")
        XCTAssertEqual(line7, "❕An item named ClarityJSON folder was already located on the desktop – it has been renamed to ClarityJSON")
        
        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
    func test_printNoEntityLogsMissingPreferenceFileFormattingFailureToCopy_UsesCorrectPlaceholdersToReturnCorrectString() throws{
        let missingFileName = "Formatting"
        let error: Error = NSError(domain:"", code: 401, userInfo: [NSLocalizedDescriptionKey: " copy fail"])
        let directoryState = ClarityActivator.ClarityJSONDirectoryState.noEntityLogsMissingPreferenceFile(missingFileType: missingFileName)
        let outputString = ClarityActivator.printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .failure(error))
        
        var b = 1
        var e = 98
        line1 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+89
        line2 = outputString[b...e]
        
        b = e+characterDoubleLineBreak
        e = b+116
        line3 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+68
        line4 = outputString[b...e]

        b = e+characterLineBreak
        e = b+90
        line5 = outputString[b...e]

        b = e+characterDoubleLineBreak
        e = b+114
        line6 = outputString[b...e]
        
        b = e+characterLineBreak
        e = b+20
        line7 = outputString[b...e]

        let outputCharacterCount = outputString.count
        
        XCTAssertEqual(line1, "⚠️ Required EntityLog JSON files and required Formatting.json file were NOT found in your project ⚠️")
        XCTAssertEqual(line2, "Any existing Clarity print statements in your project files will NOT print logs to console")
        XCTAssertEqual(line3, "Clarity will attempt to copy a default version of the ClarityJSON folder containing the missing items to the desktop.")
        XCTAssertEqual(line4, "Please relocate your custom files and copy them back into the project")
        XCTAssertEqual(line5, "or copy the default versions as a replacement if the originals have been lost or corrupted.")
        XCTAssertEqual(line6, "❗️An attempt to copy a default version of the ClarityJSON folder containing the missing items to the desktop failed ")
        XCTAssertEqual(line7, "with error  copy fail")

        XCTAssertEqual(outputCharacterCount, e+2)
    }
    
}
