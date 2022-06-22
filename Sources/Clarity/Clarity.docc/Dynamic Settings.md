# Dynamic Settings

Create bespoke settings for individual print statements.

## Overview
``Clarity`` provides a range of settings that can be used to customise console output from print statements. 

Provide a value to the `settings` parameter of a print statement to bypass the global <doc:Settings> file and modify settings dynamically during the run time of an application.

This ability has been specifically designed to be useful in conjunction with unit testing. 

Important: All settings values derived from JSON will be overridden for each print statement that provides an argument for its `settings` parameter. Note that subsequent calls using the same print number without custom settings will revert to accessing the global settings file and that the global parameter values will remain unchanged.

### Provide bespoke settings to a print statement 

1. Create an instance of ``SettingsManagerService`` with placeholder instances for ``SettingsManagerService/IsolatedEntity`` and ``SettingsManagerService/IsolatedFunction`` 
2. Set bespoke parameter values for the instances as required.
3. Pass the ``SettingsManagerService`` instance as an argument to the optional `settings` parameter of a print statement either  ``print(_:functionName:settings:)`` or ``print(_:values:settings:)``.

#### Source code
```swift
var isolatedEntity1 = SettingsManagerService.IsolatedEntity(entityCode: "", 
                                                                  isolate: false)
    

var isolatedFunction1 = SettingsManagerService.IsolatedFunction(entityCode: "", 
                                          isolate: false, isolatedFunctionNumbers: [])


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
                              displayNodePrintNumberWhenUsingRelativeNumbering:false,
                              displayNodeSequenceWithoutDescriptions: false,
                              listAllUsedPrintNumbers: false,
                              listAllUsedPrintNumbersByEntityCode: false,
                              listHighestUsedPrintNumber: false,
                              alertOrphanedPrintNumbersDetected: false)

// Assumptions:
// - this value is set to false in the Settings file
// - print number 12 is included in a node for function number 8
// - function number 8 is the first function in its entity log JSON file
dynamicSettings.calculateFunctionNumbersRelativeToEntity = true

print(12)
print(12, settings:dynamicSettings)
print(12)
```

#### Console output
```markdown
// Global settings version
MYENTITY        8    N-12   ✅  - An event for print number 12 occurred
                                  Effect: this should happen next

// Dynamic settings version 
MYENTITY        1    N-12   ✅  - An event for print number 12 occurred
                                  Effect: this should happen next

// Global settings version (unchanged)
MYENTITY        8    N-12   ✅  - An event for print number 12 occurred
                                  Effect: this should happen next
```
 

## Topics

### Output content

- ``print(_:values:settings:)``
- ``print(_:functionName:settings:)``

### JSON Reference
- <doc:Settings>







