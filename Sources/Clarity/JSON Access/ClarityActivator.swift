//
//  ClarityActivator.swift
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
A public class initialised as a single instance conforming to `JSONAccess` that is used by the ``Clarity`` framework to access client application ClarityJSON files.
 */
public class ClarityActivator: JSONAccess {

    /**
     The client application main bundle.
     
     This is the bundle property used by ClarityActivator to access the client application ClarityJSON directory. It is set by the client application calling the custom ClarityActivator initialiser that acts as the framework activator.
     
     - Note
     This variable remains nil when the Clarity framework is not embedded in a client. When this variable is nil the framework uses its own bundle to access its own ClarityJSON directory for the purposes of testing a simulated environment.
     */
    static var externalBundle: Bundle? = nil {
        didSet {
            if ClarityDeveloperAlerts.isClarityDeveloperInternalPrinting{
                Swift.print("CLAV                    ✅  - Bundle is external - client app called via custom initializer")
                Swift.print("                              Effect: feed client bundle to managerServiceFromBundle when comp vars accessed")
            }
        }
    }

    /**
     A constant that stores the bundle that ClarityActivator uses to access the ClarityJSON directory.
     
     The constant is assigned the variable `externalBundle` when embedded in a client as the active scheme or assigned the Clarity framework bundle when Clarity framework is running unit tests as the active scheme.
        */
    static let jsonBundle = externalBundle ?? Bundle(for: ClarityActivator.self)

    
    

    /**
     A constant that stores the result of a closure that computes whether the client application is in DEBUG mode. The functionality of this constant will only work as intended if Clarity is installed as an embedded framework.
     
     See Docc extensions folder for details.
     */
    @available(*, deprecated, message: "Set `inPrintMode` manually.")
    static public let isClientInDebugMode = { 
        _isDebugAssertConfiguration()
    }()
    
    /**
     A Bool that signifies whether the ClarityActivator initialiser parameter `inPrintMode:` is set manually to `true` rather than via the closure constant `isClientInDebugMode`.
          
     If the value of the parameter `inPrintMode:` is set to `true` Clarity will print messages to the console when a client application is in RELEASE build mode overriding the usual behaviour of disabling Clarity print statements.
     */
    static var isClientOverrideRelease = false
    
    /**
     A Bool that signifies whether the ClarityActivator initialiser parameter `inPrintMode:` is set manually to `false` rather than via the closure constant `isClientInDebugMode`.
          
     If the value of the parameter `inPrintMode:` is set to `false` Clarity will disable Clarity print statements when a client application is in DEBUG build mode overriding the usual behaviour of printing messages to the console.
     */
    static var isClientOverrideDebug = false

    /**
     A static variable that lazily stores the result of a closure that returns an array of EntityLogService instances decoded from JSON files in the ClarityJSON folder.
     
     The closure returns the result of calling `decoderServicesFromBundle<T: Decodable>(_: inSubDirectory:excludingFiles:) -> [T]`.

     - Important
     The variable is not an optional unlike the other decoder service type variables.
     
     In the event that a client application contains Clarity print statements but the referenced EntityLogService JSON files are missing from the ClarityJSON folder (orphaned print numbers) MessageCollator will hand an empty dictionary of messages to the print logic. The print logic will then simply ignore any Clarity print calls rather than crash.
     
     The referenced EntityLogService JSON files can then be restored to the ClarityJSON folder and any print statements contained in a client application will print logs to the console as before. An alert will be printed to the console for every orphaned print number if the setting
     `alertOrphanedPrintNumbersDetected` is true.
     
     This behaviour means that Clarity print statements with their index arguments can remain in place without defaulting to `Swift.print()` for as long as the Clarity framework remains embedded and referenced with an `import` statement.
     
     The closure is also the point where internal print setting warning checks are made if Clarity printing is active in the client application. Internal printing is for Clarity framework development print logs and is included because it would be inadvisable to use a compiled version of Clarity itself to print logs to the console. This alert is a reminder to reset internal printing to false so that unnecessary logs are not printed in a client application.
     */
    static var entityLogServiceArray: [EntityLogService] = {
        if (isClientInDebugMode && isClientOverrideDebug == false)  || isClientOverrideRelease{
            ClarityDeveloperAlerts.verifyReleaseCompatibleSettingsStateForClarityFrameworkDeveloper()
        }
 
        if ClarityDeveloperAlerts.isClarityDeveloperInternalPrinting{
            if externalBundle==nil{
                Swift.print("CLAV                    ✅  - Bundle NOT external - Framework called")
                Swift.print("                              Effect: use frameworkBundle to decode default JSON")
            }
        }
        return decoderServicesFromBundle(jsonBundle, inSubdirectory: "ClarityJSON", excludingFiles: ["Settings.json","Formatting.json"])
    }()
    
    /**
     A static variable that lazily stores the result of a closure that returns an optional SettingsManagerService instance decoded from the JSON file named Settings.json in the ClarityJSON folder.
     
     The closure returns the result of calling
     `decoderServiceFromBundle<T: Decodable>(_: inSubdirectory:forResourceName:) -> T?`.
     
     - Note
     If the variable is set to nil the JSONAccess protocol extension method `printAlertForCorruptJSON(for: )`  or the method `verifyClarityJSONDirectory(forBundle:)-> Bool` will present an alert and take action depending on the circumstance.
     */
    static var settings: SettingsManagerService? = {
        return decoderServiceFromBundle(jsonBundle, inSubdirectory: "ClarityJSON", forResourceName: "Settings")
    }()
    
    /**
     A static variable that lazily stores the result of a closure that returns an optional FormattingManagerService instance decoded from the JSON file named Formatting.json in the ClarityJSON folder.
     
     The closure returns the result of calling
     `decoderServiceFromBundle<T: Decodable>(_: inSubdirectory:forResourceName:) -> T?`.
     
     If the variable is set to nil the JSONAccess protocol extension method `printAlertForCorruptJSON(for: )`  or the method `verifyClarityJSONDirectory(forBundle:)-> Bool` will present an alert and take action depending on the circumstance.
     */
    static var formatting: FormattingManagerService? = {
        return decoderServiceFromBundle(jsonBundle, inSubdirectory: "ClarityJSON", forResourceName: "Formatting")
    }()
    
    /**
     A custom failable initialiser for ``ClarityActivator`` that is used by client applications to activate ``Clarity`` with the given specifications.

        - Parameters:
            - externalBundle: The client application main bundle.
            - inPrintMode: The print mode status: usually set in accordance with the application DEBUG status. If set to `true` ``Clarity`` will be made active and print messages to the console.
            - displayStatus: A bool that determines whether or not to display the print mode and activation status of ``Clarity`` on initialisation. This parameter defaults to `true` –  its inclusion in the activation expression is only required when set to `false`.
         */
    @discardableResult
    public  init?(withBundle externalBundle: Bundle?, inPrintMode:Bool, displayStatus:Bool = true) {

        if inPrintMode == false {
            if ClarityActivator.isClientInDebugMode == true{
                ClarityActivator.isClientOverrideDebug = true
            }
        }else{
            if ClarityActivator.isClientInDebugMode == false {
                ClarityActivator.isClientOverrideRelease = true
            }
        }
        
        printCopyrightHeader()
        
        if displayStatus {
            self.printClarityActiveState(inPrintMode)
        }
        
        if externalBundle != nil {
            ClarityActivator.externalBundle = externalBundle
             ClarityActivator.verifyClarityJSONDirectory(forBundle: externalBundle!)
        }
    }
 
    

    
}




extension ClarityActivator {
    // Extension for grouping code dealing with file verification and copying back ups to desktop

    /**
     An enum for storing the state of the missing item status of the ClarityJSON directory.
     */
     enum ClarityJSONDirectoryState: Equatable{
        /// A ClarityJSON directory has been copied to the client application and contains all the required JSON files.
        case allFilesPresent
        /// A ClarityJSON directory has not been copied to the client application or has been copied but does not contain any required JSON file.
        case noDirectoryOrEmptyDirectory
        /// A ClarityJSON directory has been copied to the client application but does not contain any valid EntityLogService JSON file.
        case noEntityLogs
        /// A ClarityJSON directory has been copied to the client application but does not contain either of the user preference files.
        case missingPreferenceFiles
        /// A ClarityJSON directory has been copied to the client application but does not contain one of the user preference files.
        /// - missingFileType: the name of the missing preference file.
        case missingPreferenceFile(missingFileType:String)
        /// A ClarityJSON directory has been copied to the client application but does not contain any valid EntityLogService JSON file and is missing one of the user preference files.
        /// - missingFileType: the name of the missing preference file.
        case noEntityLogsMissingPreferenceFile(missingFileType:String)
        
        /**
        A computed variable that returns a string representation of the value of enum cases regarding missing preference files.
         
         This variable is required to allow a common evaluation of all three cases that would otherwise not be possible because two cases have associated types and one case does not.
         */
        var missingFileType: String{
            switch self {
            case .missingPreferenceFiles:
                return "both"
            case .missingPreferenceFile(missingFileType: let missingFileType):
                return missingFileType
            case .noEntityLogsMissingPreferenceFile(missingFileType: let missingFileType):
                return missingFileType
            default:
                return ""
            }
        }
        /**
        A computed variable that returns a string representation of the name of enum cases regarding missing preference files.
         
         This variable is required to allow a common description of all three cases that would otherwise not be possible because two cases have associated types and one case does not.
         */
        var description: String{
            switch self {
            case .missingPreferenceFiles:
                return "missingPreferenceFiles"
            case .missingPreferenceFile:
                return "missingPreferenceFile"
            case .noEntityLogsMissingPreferenceFile:
                return "noEntityLogsMissingPreferenceFile"
            default:
                return ""
            }
        }

    }
    
    
    /**
     An enum for storing the state of a successful file copy procedure.
     
     This enum is used by ClarityActivator to pass the outcome of a successful file copy procedure to the  `printAlertForMissingFile(_: forDirectoryState:withResult:) -> String`  method for printing an alert to the console.
     
     If the copy procedure involved renaming an existing file or folder it passes the new name as an associated value to the `replaceCopy` case.
     */
    enum FileCopySuccess{
        /// The item was successfully copied to desktop and has a unique name.
        case pristineCopy
        /// The item was successfully copied to desktop and replaced an existing item with the same name. The existing item has been renamed to `newName`.
        /// - newName: the new name given to the existing item replaced on the desktop.
        case replaceCopy(newName: String)
    }

    /**
     A method that verifies whether the client application contains the ClarityJSON directory and JSON files required by the Clarity framework.
     
     If this method detects any required file is missing it will print an alert to the console and copy a default version of the missing item or items to the developer machine desktop. These items can then be copied back into the client project in Xcode.
     
     This method also acts as a utility to copy the necessary JSON files to the desktop in a folder named ClarityJSON on the first run of a client application after the framework has been embedded. This folder can then be dragged into the client project as a copied folder reference.
        
     - Important
     This method will only attempt to verify the ClarityJSON directory, copy missing items to the desktop and print an alert when the value of `inPrintMode` resolves to true.
     
     - Note
     There is no system level API that can directly identify whether a named subdirectory exists in a bundle. Therefore this method checks for the content expected in the subdirectory `ClarityJSON` to verify that the subdirectory itself exists.
     
     The actions taken as a consequence of running this method are:
     - if there is no directory or it is empty: a full copy is made of the ClarityJSON template folder including template and example entity log JSON files.
     - if there are no entity log JSON files: a copy is made of the ClarityJSON template folder containing template and example entity log JSON files.
     - if there are no entity log JSON files and either of the user preference JSON files are missing: a copy is made of the ClarityJSON template folder containing default versions of the user preference JSON file that is missing and template and example entity log JSON files.
     - if either or both of the user preference JSON files are missing and there is a valid entity log JSON file: a copy is made of the ClarityJSON template folder containing default versions of the missing user preference JSON file(s).

     - Parameters:
        - externalBundle: The client application main bundle
     
     - Returns: A Bool signifying whether the ClarityJSON has been verified successfully. The return is a `@discardableResult`
     */
    @discardableResult
     static func verifyClarityJSONDirectory(forBundle externalBundle: Bundle)-> Bool{
         
         
         
        if (isClientInDebugMode && isClientOverrideDebug == false) || isClientOverrideRelease{
            
            let isSettingsFile = externalBundle.url(forResource: "Settings", withExtension: "json", subdirectory: "ClarityJSON") != nil
            let isFormattingFile = externalBundle.url(forResource: "Formatting", withExtension: "json", subdirectory: "ClarityJSON") != nil
            let isEntityLogFiles = entityLogServiceArray.count  != 0
            
            var directoryState = ClarityJSONDirectoryState.allFilesPresent
            
            verifyClarityFiles(isSettingsFile, isFormattingFile, isEntityLogFiles, &directoryState)
            
            guard directoryState == .allFilesPresent else {
                copyReplacementJSONToDesktop(forDirectoryState:directoryState)
                return false
            }
            //Verification done ( inPrintMode true)
            
            return true
        }
        //Verification not done (inPrintMode false)
        return false
    }
    /**
        A helper method used by `verifyClarityJSONDirectory(forBundle:)` to set the state of the `directoryState` ClarityJSONDirectoryState enum.
     
        This method sets the `directoryState` enum according to the client application required ClarityJSON directory JSON missing file status.
     
         - Parameters:
            - settingsFilePresent: The file present status of Settings.json
            - formattingFilePresent: The file present status of Formatting.json
            - entityLogFilePresent: The file present status of EntityLogService JSON files: there must be at least one file containing JSON that can be decoded by EntityLogService for `isEntityLogFiles` to be set to `true`.
            - directoryState: An inout parameter that sets and returns a ClarityJSONDirectoryState enum with the correct case calculated from the other parameters passed into this method including any associated values.
     */
    
    static func verifyClarityFiles(_ settingsFilePresent: Bool, _ formattingFilePresent: Bool, _ entityLogFilePresent: Bool, _ directoryState: inout ClarityActivator.ClarityJSONDirectoryState) {
       if settingsFilePresent == false &&  formattingFilePresent == false && entityLogFilePresent == false{
           directoryState = .noDirectoryOrEmptyDirectory
       }else
       if settingsFilePresent == true &&  formattingFilePresent == true &&  entityLogFilePresent == false{
           directoryState = .noEntityLogs
       }else
       if settingsFilePresent == false &&  formattingFilePresent == false && entityLogFilePresent == true{
           directoryState = .missingPreferenceFiles
       }else
       if (settingsFilePresent == false ||  formattingFilePresent == false) && entityLogFilePresent == true{
           directoryState = .missingPreferenceFile(missingFileType:!settingsFilePresent ? "Settings": "Formatting")
           
       }else
       if (settingsFilePresent == false ||  formattingFilePresent == false) && entityLogFilePresent == false{
           directoryState = .noEntityLogsMissingPreferenceFile(missingFileType:!settingsFilePresent ? "Settings": "Formatting")
       }
   }
   
    
    /**
        An intermediary method called by `copyReplacementJSONToDesktop(forDirectoryState:)` that is necessary to print the correct combination of messages to the console in the event of a file copy error.
     
        The method first calls `printAlertForMissingFile(_:forDirectoryState:withResult:)` passing on its parameter arguments before evaluating the error.
     
        If the error is the unauthorised permission error code 513 it will then call `printManualTemplateCopyInstructionsScript()`.
     
         - Parameters:
            - missingfile: The name of the missing preference file.
            - directoryState: A ClarityJSONDirectoryState enum containing the correct case for the client application missing file status.
            - error: The Error caught and thrown by the failed copy file attempt.
     */
    fileprivate static func printAlertsForCopyFileError(_ missingFileName: String, _ directoryState: ClarityActivator.ClarityJSONDirectoryState, _ error: Error) {
        Swift.print(printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: .failure(error)))
        let code = error.code
        if code == 513{
            printManualTemplateCopyInstructionsScript()
        }
    }
    
    
    /**
        A method used by `copyReplacementJSONToDesktop(forDirectoryState:)` to select and call the correct helper method to use to remove default files that are not required for replacing missing files from the default ClarityJSON directory copied to the desktop.
     
        It calls a specific helper method depending on the value of the ClarityJSONDirectoryState enum and then calls appropriate print alert methods passing the required parameter arguments in each case.
     
         - Parameters:
            - directoryState: A ClarityJSONDirectoryState enum containing the correct case for the client application missing file status.
            - newFileURL: The URL to the default ClarityJSON directory copied to the desktop.
            - fileManager: The shared file manager object.
            - missingFileName: The name of the missing preference file.
            - result: A `Result` enum where `Success` is of type `ClarityActivator.FileCopySuccess` and is used to pass the result of the file copy attempt.
     */
    
    fileprivate static func removeRedundantFiles(_ directoryState: ClarityActivator.ClarityJSONDirectoryState, _ newFileURL: URL, _ fileManager: FileManager, _ missingFileName: String, _ result: Result<ClarityActivator.FileCopySuccess, Error>) throws {
        if directoryState == .noEntityLogs  {
            try removePreferenceFiles(newFileURL, fileManager)
        }
        if directoryState.description == "noEntityLogsMissingPreferenceFile"{
            try removePreferenceFiles(newFileURL, fileManager, missingFileName)
        }
        if directoryState == .missingPreferenceFiles{
            try removeEntityLogFiles(newFileURL, fileManager)
        }
        Swift.print(printAlertForMissingFile(missingFileName, forDirectoryState: directoryState, withResult: result))
        if directoryState == .noDirectoryOrEmptyDirectory{
            printInstructionsScript()
        }
    }
    
    /**
     A method that copies a default version of the ClarityJSON directory and / or any of its required JSON files to the developer desktop if they are missing from the client application.
                 
     This method takes a ClarityJSONDirectoryState enum and uses it to identify missing items. It then attempts to copy any missing JSON file from the TemplateJSON folder resource into a new folder on the desktop that it names ClarityJSON.

     If any item already exists on the desktop with the same name as a missing item the existing item will be renamed.
              
     An alert is then printed to the console that describes the action taken and the steps required to copy any missing item(s) back into the project.

     If only a single preference file is missing from the client ClarityJSON directory then a default copy of that file will be made and placed on the desktop (and not placed in an enclosing folder).
          
     - Important
     Copying the TemplateJSON folder to the desktop will currently work when running client applications in device simulators. The copy attempt is likely to fail with a permission error when running macOS applications. If the attempt fails instructions on how to copy the TemplateJSON folder from derived data are printed to the console.
              
     - Note
     The variable `sourceDirectoryURL` is assigned via a relative path of the TemplateJSON to the file location as an alternative path if the path cannot be derived from the bundle. The alternative path can only be created if the framework and client reside in the same workspace. If both paths return nil the URL remains initialised from an empty string and the method will catch the copy file error and print manual copy instructions to the console.  It is currently not possible to access the developer machine home directory path programmatically when the framework code is run from within a client application. `NSHomeDirectory` resolves to the home directory of the device or simulated device instead of the developer machine.

     There are six main task phases to the method:
      1. Get the source url TemplateJSON folder (from derived data path or relative to the file location)
      2. Get the destination URLs for specific files/folder to be copied on to the desktop).
      3. Create backup name URL for any pre-existing ClarityJSON folder on the desktop.
      4. Switch on the ClarityJSONDirectoryState and assign final source and destination URLs and     components depending on what item(s|) are missing.
      5. Assign a pre-existing file enquiry path: either for a missing preference file or for the ClarityJSON folder
      6. Attempt to copy missing items, removing and renaming any pre existing items.

      - Parameters:
         - directoryState: A ClarityJSONDirectoryState enum containing the correct case for the client application missing file status.
     */
    fileprivate static func copyReplacementJSONToDesktop(forDirectoryState directoryState: ClarityJSONDirectoryState) {
        print("copyReplacementJSONToDesktop called")
        //Filemanager
        let fileManager = FileManager.default
        var isDir: ObjCBool = false

        //Source URL:
        let sourceDirectoryName = "TemplateJSON"
        
        var sourceURL = URL(fileURLWithPath: "")
        let frameworkBundle = Bundle(for: ClarityActivator.self)
        
        if let sourceDirectoryPath = frameworkBundle.path(forResource: sourceDirectoryName, ofType: nil){
            //via Bundle
            sourceURL = URL(fileURLWithPath:sourceDirectoryPath)
        }else{
            //via relative to file
            sourceURL = URL(fileURLWithPath: #file.replacingOccurrences(of: "/Clarity/Sources/Clarity/JSON Access/ClarityActivator.swift", with: "/Clarity/"+sourceDirectoryName))
        }
        

        //Destination URL
        let desktopPath = "/Users/home/Desktop"
        let desktopURL = URL(fileURLWithPath: desktopPath)
        
        let pathToReplacementClarityJSONDirectory = desktopPath+"/ClarityJSON"
        let urlToReplacementClarityJSONDirectory = URL(fileURLWithPath: pathToReplacementClarityJSONDirectory)
        
        //Destination URL placeholders
        var newPreferenceFilePath = ""
        var newFileURL = URL(fileURLWithPath: "")
        var backUpURL = URL(fileURLWithPath: "")
        
        //Destination URL – Replaced item backup name
        let dateString = String.makeSimpleTimeStamp()
        let replacedDirectoryBackupComponent = "ClarityJSON"+dateString
        let replacedDirectoryBackUpURL = desktopURL.appendingPathComponent(replacedDirectoryBackupComponent)
        
        //missingFileName
        var missingFileName = ""
        var backupComponent = ""
        
        //Scenario check
        switch directoryState {
        case .allFilesPresent:
            // This should never occur (this method would not have been called)
            return
            
        case .noDirectoryOrEmptyDirectory , .noEntityLogs, .missingPreferenceFiles:
            //Copy entire template >  outcome 1
            //Copy entire template  removing both preferences >  outcome 2
            //Copy entire template with only both preferences (removing EntityLogService JSON) >  outcome 3
            
            newFileURL = urlToReplacementClarityJSONDirectory
            backUpURL = replacedDirectoryBackUpURL
             
            
        case .missingPreferenceFile(let missingFileTypeName):
            //Copy missing preferences file to desktop only  >  outcome 4
            
            //Necessary to copy incoming let to the predefined var
            missingFileName = missingFileTypeName
            
            //Re-assign the source path from the template folder to individual file within it
            if let sourceFilePath = frameworkBundle.path(forResource: missingFileName, ofType: "json", inDirectory: sourceDirectoryName){
                sourceURL = URL(fileURLWithPath:sourceFilePath)
            }else{
                sourceURL = URL(fileURLWithPath: #file.replacingOccurrences(of: "/Clarity/Sources/Clarity/JSON Access/ClarityActivator.swift", with: "/Clarity/"+sourceDirectoryName+"/"+missingFileName+".json"))
            }
            newPreferenceFilePath = desktopPath+"/"+missingFileName+".json"
            newFileURL =  URL(fileURLWithPath: newPreferenceFilePath)
            backupComponent = missingFileName+dateString+".json"
            backUpURL = desktopURL.appendingPathComponent(missingFileName+dateString+".json")
            
        case .noEntityLogsMissingPreferenceFile(let missingFileTypeName):
            //Copy entire template removing the non missing preference file  >  outcome 5
            //NB! Cannot bind the associated value in a grouped case (case 1 where this scenario belongs) therefore must live in its own case with repeat of the case 1 assignments + associated value assignment (for removal of non missing file)
            missingFileName = missingFileTypeName
            
            newFileURL = urlToReplacementClarityJSONDirectory
            backUpURL = replacedDirectoryBackUpURL
        }
        // Assign path name to check for a pre-existing file: either missing preference file or the ClarityJSON folder
        let filePath = directoryState.description == "missingPreferenceFile" ? newPreferenceFilePath : pathToReplacementClarityJSONDirectory
        
        if fileManager.fileExists(atPath: filePath, isDirectory: &isDir) {
            do {
                try fileManager.copyItem(at: newFileURL, to: backUpURL)
                try fileManager.removeItem(at: newFileURL)
                try fileManager.copyItem(at: sourceURL, to: newFileURL)
                
                let result: Result<ClarityActivator.FileCopySuccess, Error> = .success(.replaceCopy(newName: backupComponent == "" ? replacedDirectoryBackupComponent : backupComponent))
                try removeRedundantFiles(directoryState, newFileURL, fileManager, missingFileName, result)
            } catch  {
                printAlertsForCopyFileError(missingFileName, directoryState, error)
            }
        }else{
            do {
                try fileManager.copyItem(at: sourceURL, to: newFileURL)
                
                let result: Result<ClarityActivator.FileCopySuccess, Error> = .success(.pristineCopy)
                try removeRedundantFiles(directoryState, newFileURL, fileManager, missingFileName, result)
            } catch  {
                printAlertsForCopyFileError(missingFileName, directoryState, error)
            }
        }
    }
    /**
        A helper method used by `copyReplacementJSONToDesktop(forDirectoryState:)` to remove default preference files that are not required for replacing missing files from the default ClarityJSON directory copied to the desktop.
     
         This method reads the name of any missing preference file and then removes any non-missing preference file contained in the default directory. If the `missingFileName` parameter is omitted both preference files are removed.
     
         - Parameters:
            - newFileURL: The URL to the default ClarityJSON directory copied to the desktop
            - fileManager: The shared file manager object
            - missingFileName: The name of the missing preference file
     
         - Note
         This method propagates any error thrown by `removeItem(at:)`
     */
    fileprivate static func removePreferenceFiles( _ newFileURL: URL, _ fileManager: FileManager, _ missingFileName: String = "") throws {
        
        let settingsURL = newFileURL.appendingPathComponent("Settings.json")
        let formattingURL = newFileURL.appendingPathComponent("Formatting.json")
        
        if missingFileName != "Settings" {
            try fileManager.removeItem(at: settingsURL)
        }
        if missingFileName != "Formatting"{
            try fileManager.removeItem(at: formattingURL)
        }
    }
    
    /**
        A helper method used by `copyReplacementJSONToDesktop(forDirectoryState:)` to remove template and example EntityLogService JSON files from the default ClarityJSON directory copied to the desktop (when they do not require replacing). The default ClarityJSON directory will then only contain preference files that are missing and need replacing.
     
         - Parameters:
            - newFileURL: The URL to the default ClarityJSON directory copied to the desktop
            - fileManager: The shared file manager object
     
         - Note
         This method propagates any error thrown by `removeItem(at:)`
     */
    fileprivate static func removeEntityLogFiles( _ newFileURL: URL,  _ fileManager: FileManager) throws {
        
        let exampleEntityLog = newFileURL.appendingPathComponent("ExampleEntityLog.json")
        let templateEntityLogConvenience = newFileURL.appendingPathComponent("TemplateEntityLogConvenience.json")
        let templateEntityLogStructure = newFileURL.appendingPathComponent("TemplateEntityLogStructure.json")
        try fileManager.removeItem(at: exampleEntityLog)
        try fileManager.removeItem(at: templateEntityLogConvenience)
        try fileManager.removeItem(at: templateEntityLogStructure)
    }
    
    

}


extension ClarityActivator {
    // Extension for grouping code dealing with printing alerts to console
    
    /**
        An implementation of the JSONAccess protocol method that prints an alert to the console if an attempt to decode a JSON file returns nil.
     
        - Parameters:
            - missingFile: The last path component of the URL to the JSON file that returned nil on an attempt to decode it.
     */
    static internal func printAlertForCorruptJSON(for missingFile: String) {
        
        Swift.print("⚠️ Required file \(missingFile) exists in your project but is written to an incorrect format or is corrupted" )
        Swift.print("NO CLARITY PRINT STATEMENTS WILL BE PRINTED TO CONSOLE" )
        Swift.print("If the error in the file can not be discerned simply delete the file from your project and Clarity will copy a default version to the desktop on the next run of the client application" )
    }
    
    
    
    /// A method that prints copyright information about the Clarity framework to console on launch of a client application.
    private func printCopyrightHeader() {
        print("☀️ CLARITY LOGGING FRAMEWORK ☀️ Copyright © 2021 Lawrence Heyfron - github.com/real-intelligence - www.realint.org")
    }
    
    
    
    /**
     A method that compiles an alert and advice message that displays the active state of the Clarity framework.
     
     The method compiles a message that outlines the reasons for the current activation state derived from the client application build configuration DEBUG status and the state of `inPrintMode`.
     
     The method also provides an explanation of the steps to take to toggle the activation state.
     
        - Parameters:
            - inPrintMode: The state resolved by the initialiser parameter `inPrintMode`.
     */
    private func printClarityActiveState(_ inPrintMode:Bool){

            var activation = "To activate"
            var active = "active"
            var buildConfiguration  = ""
            var inverseBuildConfiguration = ""
            var activationAdvice = ""
            
            if ClarityActivator.isClientInDebugMode {
                buildConfiguration = "DEBUG"
                inverseBuildConfiguration = "RELEASE"
            }else{
                buildConfiguration = "RELEASE"
                inverseBuildConfiguration = "DEBUG"
            }
            
            var warning =   ""
            let printModeAdvice = "set inPrintMode to ClarityActivator.isClientInDebugMode"
            
            let toggleBuildConfigurationAutoAdvice =  "set Client application to \(inverseBuildConfiguration) mode and set inPrintMode to ClarityActivator.isClientInDebugMode"
            let toggleBuildmodeManualAdvice =  " or set Client application to either RELEASE or DEBUG mode and set inPrintMode to \(!inPrintMode)"
            if ClarityActivator.isClientOverrideDebug {
                warning =   "⚠️ WARNING! "
                active = "NOT active"
                activationAdvice = printModeAdvice + " or " + toggleBuildConfigurationAutoAdvice + toggleBuildmodeManualAdvice
            }else
            if inPrintMode == false && ClarityActivator.isClientInDebugMode == false{
                active = "NOT active"
                activationAdvice = toggleBuildConfigurationAutoAdvice + toggleBuildmodeManualAdvice
                
            }
            if ClarityActivator.isClientOverrideRelease {
                warning =   "⚠️ WARNING! "
                activation = "To deactivate"
                activationAdvice = printModeAdvice + " or " + toggleBuildConfigurationAutoAdvice + toggleBuildmodeManualAdvice
                
            }else
            if inPrintMode && ClarityActivator.isClientInDebugMode{
                activation = "To deactivate"
                activationAdvice = toggleBuildConfigurationAutoAdvice + toggleBuildmodeManualAdvice
            }
            
            Swift.print("\(warning)Client build configuration is \(buildConfiguration): ClarityActivator inPrintMode is \(inPrintMode) - Clarity is \(active).\n\(activation) Clarity print statements \(activationAdvice).")
                Swift.print("To suppress display of this advice set ClarityActivator initialiser parameter 'displayStatus' argument to false.")
        }
    
    
    
    
    /**
      A method that compiles an alert and advice message when either the ClarityJSON directory or any of its contained JSON files required by the Clarity framework has been detected as being missing.
     
         This method composes and returns a single message string for all combinations of missing file or directory and file copy success or fail outcome.
         
         - Parameters:
            - missingfile: The name of the missing preference file.
            - directoryState: A ClarityJSONDirectoryState enum containing the correct case for the client application missing file status.
            - result: A Result enum that uses a custom `FileCopySuccess` enum for its `.success` case associated value and an `Error` type for its `.failure` case associated value.
         
         - Note
         The `FileCopySuccess` enum `replaceCopy(newName:)` used in the Result type returns an associated string value containing the new name of any file that already existed on the desktop with the same name as a replaced missing item.
     */
     static func printAlertForMissingFile(_ missingfile:String, forDirectoryState directoryState: ClarityJSONDirectoryState, withResult result: Result<FileCopySuccess, Error>) -> String{
        
        guard directoryState != .allFilesPresent else {
            //Should never reach here
            return ""
        }
        
        var outputString = ""
        var copySuccessScript = ""
        let directoryName = "ClarityJSON"
        var possession = "it"
        var firstRunScript = ""
        var otherwise = ""
        var version = "version"
        var original = "original has"
        
        var missingItem = missingfile == "" ?  "the \(directoryName) folder" : "the \(missingfile).json file"
        var missingItemPastTense = missingfile == "" ? "directory \(directoryName) was NOT" : "file \(missingfile).json was NOT"
        var missingItemArticled = missingfile == "" ? "An item named \(directoryName) folder" : "An item named \(missingfile).json file"
        var placement = "place \(possession) in the ClarityJSON folder"
        
        if directoryState.description == "missingPreferenceFile" {
            otherwise = "Please relocate your \(missingfile).json file"
            version = "\(missingfile).json"
            original = "original has"
            placement = "place it back into the ClarityJSON folder in your project"
        }
        
        if directoryState.description == "missingPreferenceFiles" {
            missingItemPastTense = "Settings.json and Formatting.json preference files were NOT"
            missingItem = "the preference files in a folder named \(directoryName)"
            possession = "them"
            otherwise = "Please relocate your custom preference files"
            version = "versions"
            original = "originals have"
            placement = "place them back in the ClarityJSON folder in your project"
        }
        
        if directoryState == .noEntityLogs{
            missingItemPastTense = "EntityLog JSON files were NOT"
            missingItem = "the template EntityLog JSON files in a folder named \(directoryName)"
            possession = "them"
            placement = "copy them back into the project"
            otherwise = "Please relocate your custom EntityLog JSON files"
            version = "template versions"
            original = "originals have"
        }
        
        if directoryState == .noDirectoryOrEmptyDirectory{
            firstRunScript = "If this is the first run of an application after embedding the Clarity framework\n\(missingItem) will need to be copied to your project.\n"
            placement = "copy it back into the project"
            otherwise = "Otherwise please relocate the original \(directoryName) folder"
        }
        
        if directoryState.description == "noEntityLogsMissingPreferenceFile" {
            
            missingItemPastTense =  "EntityLog JSON files and required \(missingfile).json file were NOT"
            otherwise = "Please relocate your custom files"
            placement = "copy them back into the project"
            version = "versions"
            original = "originals have"
            missingItem = "the \(directoryName) folder containing the missing items"
            missingItemArticled = "An item named \(directoryName) folder"
             
        }
        let copyAttemptScript = "Clarity will attempt to copy a default version of \(missingItem) to the desktop.\n"
        
        outputString = "\n⚠️ Required \(missingItemPastTense) found in your project ⚠️\nAny existing Clarity print statements in your project files will NOT print logs to console\n\n"
        
        let relocateInstruction = "\n\(otherwise) and \(placement)\nor copy the default \(version) as a replacement if the \(original) been lost or corrupted."
        
        outputString+=copyAttemptScript+firstRunScript+relocateInstruction
        
        copySuccessScript = "\n\n...A default version of \(missingItem) has been successfully copied to the desktop\n"
        
        //Copy result
        switch result {
        case .failure(let error):
             
            outputString+="\n\n❗️An attempt to copy a default version of \(missingItem) to the desktop failed \nwith error \(error.localizedDescription)\n"

            
        case .success(.pristineCopy):
            outputString+=copySuccessScript
        case .success(.replaceCopy(let newname)):
            outputString+=copySuccessScript+"\n❕\(missingItemArticled) was already located on the desktop – it has been renamed to \(newname)\n"
        }
        return outputString
    }
    /**
     A method that prints to the console the instructions for adding the ClarityJSON folder and JSON files to the client project. It also explains behaviours relating to missing files and their replacement.
     */
     static func printInstructionsScript() {
        Swift.print("📒 INSTRUCTIONS for copying the ClarityJSON folder and JSON files to your project \n")
        Swift.print("NOTE – these instruction are printed to console only when the ClarityJSON folder or \nits entire contents are missing from your project.\n")
        Swift.print("1. (All platforms except watchOS) Drag the folder named ClarityJSON from the desktop into: Xcode > Project Navigator > under (as a child of) the ProjectName icon\n")
        Swift.print("1B (for watchOS only). Drag the folder named ClarityJSON from the desktop into: Xcode > Project Navigator > under (as a child of) the ProjectName Watchkit Extension folder\n")
        
        Swift.print("2. Check Destination: 'Copy items if needed', select 'Create folder reference' and check 'Add to targets:' > 'ProjectName'")
        Swift.print("   - Xcode should place the directory at the TOP level of your project in the same directory containing the .xcodeproj file\n   - the folder should be coloured blue. If it is coloured gold then the option 'Create folder reference' was not checked\n   – remove>delete and repeat step 2\n")
        Swift.print("3. Copy and rename the EntityLog.json template files for each entity (Struct, Class or Enum) where Clarity print() functions are required")
        Swift.print("   - add more EntityLog.json files at any time as required\n")
        Swift.print("4. Copy or move ExampleEntityLog.json to a separate location for reference and delete it from the ClarityJSON folder")
        Swift.print("   - the template files do not need to be deleted\n")
        Swift.print("❗️Important\n•The Settings.json and Formatting.json files must NOT be renamed, \ndeleted or have keys altered – (key values can be edited)")
        Swift.print("•EntityLog JSON files MUST be uniquely named, \nthe JSON object structure must be maintained but arrays can contain unlimited items")
        Swift.print("•The ClarityJSON directory must NOT be renamed\n")
        Swift.print("NOTES:\n•If either Settings.json and Formatting.json have their keys corrupted, \nare deleted, renamed or the whole ClarityJSON directory is deleted \neither the single affected file or a default directory containing missing  \nfiles will be copied to the desktop on the next run or test of the application\nwith these instructions printed to console\n")
        Swift.print("•If an item with the same name already exists on the desktop it will be\n duplicated to desktop and renamed to include the current timestamp\n")
        Swift.print("•Neither the default ClarityJSON directory nor any JSON file will be \ncopied to desktop when the client application is in RELEASE mode\n")
        Swift.print("•The Clarity JSON file(s)/folder copied to the desktop can be deleted after being added to your project\n")
    }
    
    /**
     A method that prints to the console the instructions for manually copying and renaming the TemplateJSON folder. This will be printed in the event that a permissions issue prevented Clarity from copying it to the developer desktop automatically.
     */
    static func printManualTemplateCopyInstructionsScript() {
        
        Swift.print("📒 INSTRUCTIONS for manually copying the TemplateJSON folder\n")
        Swift.print("Clarity was unable to copy the TemplateJSON folder to your desktop because of a denied permissions issue.")
        Swift.print("You will therefore need to copy the TemplateJSON folder to your desktop manually.\nEither copy the folder from the Clarity GitHub repository or from DerivedData using the following instructions:\n")
        Swift.print("Ensure the application target (not just the test target) has built and run at least once")
        Swift.print("Then locate as follows:")
        Swift.print("Project navigator > ProjectName > Products (folder) > (right click) ProjectName.app  > Show in Finder...\n")
        Swift.print("In the Finder ... (right click) ProjectName  > Show Package Contents...\n")
        Swift.print("Contents > Frameworks > Clarity.framework > Resources > TemplateJSON")
        Swift.print("select the TemplateJSON folder and copy it (cmd c)")
        Swift.print("Paste the TemplateJSON folder onto the Desktop (cmd v))\n")
        Swift.print("Either way the TemplateJSON folder is copied – rename it to ClarityJSON\n")
        Swift.print("Follow the remaining instructions to copy to your project.\n")
        
        printInstructionsScript()
        
    }
    
}





extension Error {
    /**
     A computed variable added to the Error protocol as an extension that returns itself cast as a NSError error code.
     
     This variable is required to allow `printAlertsForCopyFileError(_:_:_:)` to identify file copy errors.
     */
    var code: Int { return (self as NSError).code }
    /**
     A computed variable added to the Error protocol as an extension that returns itself cast as a NSError error domain.
     */
    var domain: String { return (self as NSError).domain }
}

