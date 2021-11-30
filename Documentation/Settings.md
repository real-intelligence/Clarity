## Settings JSON reference

### Top level keys

| Key                                              | Type                                                         | Use description                                              |
| ------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| suppressAllClarityLogs                           | Bool                                                         | Suppress output of all Clarity print statements (overriding all other keys). |
| printAllClarityLogs                              | Bool                                                         | Override all key bool values relating to the conditional output of print numbers (other than for `suppressAllClarityLogs`) to print all Clarity print statements to the console. |
| logFunctionNamesOnly                             | Bool                                                         | Suppress all Clarity print statements other than those that output function names (node type 0). |
| suppressLogFunctionNames                         | Bool                                                         | Suppress all Clarity print statements that output function names. |
| logIsolatedPrintNumbersOnly                      | Bool                                                         | Suppress all Clarity print statements that have associated print numbers that are NOT included in the `isolatedPrintNumbers` Array |
| isolatedPrintNumbers                             | Array of Ints                                                | An array of Ints representing the print numbers for print statements that will continue to output to the console when `logIsolatedPrintNumbersOnly` is true |
| isolatedEntities                                 | Array of JSON objects: see in [dedicated table](#isolatedEntities key array) | An array of JSON objects representing entities (Class, Structure or Enum) that can have the print statements of nodes they contain output in isolation. |
| isolatedFunctions                                | Array of JSON objects: see in [dedicated table](#isolatedFunctions key array) | An array of JSON objects representing functions within specified entities that can have the print statements of nodes they contain output in isolation. |
| calculateFunctionNumbersRelativeToEntity         | Bool                                                         | Override the custom values allocated to the EntityLogService JSON file `entity_functions` array >` function_number` key with a number calculated according to the sequential position of an object as it is included in the `entity_functions` array. <br /><br />Advantage: setting the value of this key to true keeps the function number digits relatively low to aid readability and negates the requirement to set the `function_number` key.  <br /><br />Disadvantage: the function number may continually change as functions are added, deleted or moved.<br />Note: this setting can itself be selectively overridden for each function within the EntityLogService JSON `entity_functions` array using the `function_number_always_custom` key. |
| calculateNodeNumbersRelativeToFunction           | Bool                                                         | Override the values of the EntityLogService JSON file `function_nodes` array > `print_number` key as it appears in the console. It is replaced with a number calculated according to the sequential position of the node object as it is included in the `function_nodes` array.<br /><br />Advantage: setting the value of this key to true keeps the node number digits relatively low to aid readability and is dynamic – giving a rough indication where the node is located within a function (if print numbers are maintained sequentially within both code and JSON) .<br /><br />Note: combine this setting with `displayNodePrintNumberWhenUsingRelativeNumbering`  to include the display of the print statement print number associated with the node. |
| displayNodePrintNumberWhenUsingRelativeNumbering | Bool                                                         | Include the display of the print statement print number associated with the `function_nodes` array > `print_number` key  when `calculateNodeNumbersRelativeToFunction` is true.<br />Advantage: setting the value of this key to true enables the print number to be displayed right justified. It also gives the benefit of viewing both numbers. |
| displayNodeSequenceWithoutDescriptions           | Bool                                                         | Remove all control flow node descriptions and symbols from the display of the print statement output in the console.<br /><br />Advantage: setting the value of this key to true is useful for tracking paths through complex algorithms or tracing the source of intermittent errors by allowing for the physical printing of multiple run output onto transparencies.<br /><br />Note: combine this setting with `suppressLogFunctionNames` to further simplify the display of the path taken through a control flow by using numbers only. |
| listAllUsedPrintNumbers                          | Bool                                                         | Display all print numbers used in all EntityLogService JSON files in ascending order.<br /><br />This setting is useful when allocating print numbers to additional source code.<br /><br />The numbers are listed in the console at the beginning of an application run. |
| listAllUsedPrintNumbersByEntityCode              | Bool                                                         | Display all print numbers used in all EntityLogService JSON files in ascending order by entity code.<br /><br />This setting is useful when allocating print numbers to additional source code.<br /><br />The numbers and codes are listed in the console at the beginning of an application run. |
| listHighestUsedPrintNumber                       | Bool                                                         | Display the highest print number used in all EntityLogService JSON files.<br /><br />This setting is useful when allocating print numbers to additional source code.<br /><br />The number is listed in the console at the beginning of an application run. |
| alertOrphanedPrintNumbersDetected                | Bool                                                         | Display an alert whenever a print number is used as an argument to a Clarity print statement that has no correlating node in any EntityLog JSON file.<br /><br />Note: if an entire EntityLogService JSON file is accidentally deleted setting this value to true will print an alert for each print number used in that file. |



### isolatedEntities array keys 

| Key        | Type   | Use description                                              |
| ---------- | ------ | ------------------------------------------------------------ |
| entityCode | String | A string representing the entity (Class, Structure or Enum)  that can have the print statements of nodes it contains output to the console in isolation. |
| isolate    | Bool   | A bool that controls whether to 'isolate' the entity named using the `entityCode` key. <br /><br />If this value is set to true only the print statements of the nodes the entity contains will be output in isolation. These will be printed along with print statements in other entities that have the `isolatedEntities` JSON keys set to the same values. |



### isolatedFunctions array keys 

| Key                     | Type          | Use description                                              |
| ----------------------- | ------------- | ------------------------------------------------------------ |
| entityCode              | String        | A string representing the entity (Class, Structure or Enum) that can have the print statements of nodes it contains in functions specified in the `isolatedFunctionNumbers` array output to the console in isolation. |
| isolate                 | Bool          | A bool that controls whether to 'isolate' the function node print statements of the entity named using the `entityCode` key. <br /><br />If the value is set to true only the print statements of the nodes contained in functions specified in the `isolatedFunctionNumbers` array will be output to the console in isolation. These will be printed along with print statements of the nodes contained in functions in other entities that have the `isolatedFunctions` JSON keys set to the same values. |
| isolatedFunctionNumbers | Array of Ints | An array of Ints representing the function numbers contained in the entity represented by `entityCode` that will continue to output the print statements of its contained nodes to the console when the value of its associated `isolate` key is  set to true. |



## Dynamic Settings

Settings can be modified dynamically during the run time of an application – this can be useful in conjunction with unit testing.

1. Create an instance of `SettingsManagerService` (with placeholders for `IsolatedEntity` and `IsolatedFunction` instances)
1. Set parameter values for the  `SettingsManagerService` instance as required.
2. Pass the   `SettingsManagerService` instance as an argument to the optional `settings` parameter of the Clarity print overload functions and methods.

Important: All settings values derived from JSON will be overridden for any print function that provides a value argument to its `settings` parameter.

```swift
//1.    
    //Create isolated entities placeholder – edit, add more, remove as required
     var isolatedEntity1 = SettingsManagerService.IsolatedEntity(entityCode: "", isolate: false)
    
    //Create isolated functions placeholder – edit, add more, remove as required
     var isolatedFunction1 = SettingsManagerService.IsolatedFunction(entityCode: "", isolate: false, isolatedFunctionNumbers: [])

    //Create SettingsManagerService instance
     var dynamicSettings = SettingsManagerService(suppressAllClarityLogs: false,
                                              printAllClarityLogs: false,
                                     logFunctionNamesOnly: false,
                                     logIsolatedPrintNumbersOnly: false,
                                     isolatedPrintNumbers: [],
                                     suppressLogFunctionNames: false,
                                     isolatedEntities: [isolatedEntity1],
                                     isolatedFunctions: [isolatedFunctionEntity1],
                                     calculateFunctionNumbersRelativeToEntity: false,
                                     calculateNodeNumbersRelativeToFunction: false,
                                     displayNodePrintNumberWhenUsingRelativeNumbering: false,
                                     displayNodeSequenceWithoutDescriptions: false,
                                     listAllUsedPrintNumbers: false,
                                     listAllUsedPrintNumbersByEntityCode: false,
                                     listHighestUsedPrintNumber: false,
                                     alertOrphanedPrintNumbersDetected: false)


//2.
 // Modify SettingsManagerService values as required  
  dynamicSettings.calculateFunctionNumbersRelativeToEntity = true

//3.
// Pass SettingsManagerService instance to Clarity print statement settings argument
	print(52, settings:dynamicSettings)
```



