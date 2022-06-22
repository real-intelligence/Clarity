# Relative numbering

Display print numbers and function numbers with relative numbering.

## Overview
``Clarity`` provides a range of settings that can be used to customise console output from print statements. Edit values in the <doc:Settings> JSON file to alter how the node numbering system is calculated. 

When the relative print numbers option is selected you can also display the node `print_number` value as an additional output column in the console. 

Use these settings to keep the displayed number values low and more readable. It is important to understand that the number sequence of relative node numbers is calculated from the JSON structure and not from the order of print statements within a function in the source code.

Note that node number and function number output will be duplicated for different functions and across different entities if relative numbering settings are selected. 

### Display relative function numbers
Set `calculateFunctionNumbersRelativeToEntity` to `true` to overwrite the `function_number` display to equal the index (plus 1) of the function object within the `entity_functions` JSON array.

#### Source code
```swift
    ...    
        // Print statements within various functions in the same entity.
        print(12)
        print(73)
        print(85)
        print(163)
        print(198)
...
```
#### EntityLogService JSON
```json
{
   "entity_code":"MYENTITY",
   "entity_functions" : [
       {
           "function_number":8,
           "function_number_always_custom":false,
           "function_type":"f",
           "function_nodes":[
               {
                   "print_number":12,
                   "node_type":1,  
                   "event_description":"An event occurred",
                   "effect_description":"this should happen next"
               },
                {
                    "print_number":73,
                    "node_type":2,  
                    "event_description":"Validation FAILED",
                    "effect_description":"this should happen next"
                }
           ]
       },
        {
            "function_number":52,
            "function_number_always_custom":false,
            "function_type":"f",
            "function_nodes":[
                {
                    "print_number":85,
                    "node_type":1,  
                    "event_description":"An event occurred",
                    "effect_description":"this should happen next"
                },
                {
                    "print_number":163,
                    "node_type":8,  
                    "event_description":"myInstance IS nil",
                    "effect_description":"this should happen next"
                },
                {
                    "print_number":198,
                    "node_type":5,  
                    "event_description":"A switch case resolved to true",
                    "effect_description":"this should happen next"
                }
            ]
        }
   ]
}
```
#### Console output (default setting)
```markdown
MYENTITY        8    N-12   ✅  - An event occurred
                                  Effect: this should happen next
MYENTITY        8   !N-73   🔴  - Validation FAILED
                                  Effect: this should happen next
MYENTITY       52    N-85   ✅  - An event occurred
                                  Effect: this should happen next
MYENTITY       52   !G-163  ⚔️  - myInstance IS nil
                                  Effect: this should happen next
MYENTITY       52    C-198  ✅  - A switch case resolved to true
                                  Effect: this should happen next
```
#### Settings JSON

```json
{
    ...
    "calculateFunctionNumbersRelativeToEntity":true,
    ...
}
``` 
#### Console output: relative function numbers
```markdown
MYENTITY        1    N-12   ✅  - An event occurred
                                  Effect: this should happen next
MYENTITY        1   !N-73   🔴  - Validation FAILED
                                  Effect: this should happen next
MYENTITY        2    N-85   ✅  - An event occurred
                                  Effect: this should happen next
MYENTITY        2   !G-163  ⚔️  - myInstance IS nil
                                  Effect: this should happen next
MYENTITY        2    C-198  ✅  - A switch case resolved to true
                                  Effect: this should happen next
```


### Display relative node (print) numbers
Set `calculateNodeNumbersRelativeToFunction` to `true` to overwrite the `print_number` display to equal the index (plus 1) of the  node object within the `function_nodes` JSON array.

#### Settings JSON

```json
{
    ...
    "calculateNodeNumbersRelativeToFunction":true,
    ...
}
``` 
#### Console output: relative node (print) numbers
```markdown
MYENTITY        8    N-1    ✅  - An event occurred
                                  Effect: this should happen next
MYENTITY        8   !N-2    🔴  - Validation FAILED
                                  Effect: this should happen next
MYENTITY       52    N-1    ✅  - An event occurred
                                  Effect: this should happen next
MYENTITY       52   !G-2    ⚔️  - myInstance IS nil
                                  Effect: this should happen next
MYENTITY       52    C-3    ✅  - A switch case resolved to true
                                  Effect: this should happen next
```
#### Settings JSON

```json
{
    ...
    "calculateFunctionNumbersRelativeToEntity":true,
    "calculateNodeNumbersRelativeToFunction":true,
    ...
}
``` 

#### Console output: relative function and relative node numbers
```markdown
MYENTITY        1    N-1    ✅  - An event occurred
                                  Effect: this should happen next
MYENTITY        1   !N-2    🔴  - Validation FAILED
                                  Effect: this should happen next
MYENTITY        2    N-1    ✅  - An event occurred
                                  Effect: this should happen next
MYENTITY        2   !G-2    ⚔️  - myInstance IS nil
                                  Effect: this should happen next
MYENTITY        2    C-3    ✅  - A switch case resolved to true
                                  Effect: this should happen next
```

### Display additional print number column
Set `displayNodePrintNumberWhenUsingRelativeNumbering` to `true` to also display the node `print_number`  (custom) value as an additional output column in the console. Note that you use this setting in combination with `calculateNodeNumbersRelativeToFunction` set to true.

This setting also allows print numbers to be displayed in a right justified format.

Note that the columns following the print number inevitably extend further to the right of the console. 


#### Settings JSON

```json
{
    ...
    "calculateNodeNumbersRelativeToFunction":true,
    "displayNodePrintNumberWhenUsingRelativeNumbering":true,
    ...
}
``` 

#### Console output: relative node numbers and print number
```markdown
MYENTITY        8    N-1         12  ✅  - An event occurred
                                           Effect: this should happen next
MYENTITY        8   !N-2         73  🔴  - Validation FAILED
                                           Effect: this should happen next
MYENTITY       52    N-1         85  ✅  - An event occurred
                                           Effect: this should happen next
MYENTITY       52   !G-2        163  ⚔️  - myInstance IS nil
                                           Effect: this should happen next
MYENTITY       52    C-3        198  ✅  - A switch case resolved to true
                                           Effect: this should happen next
```
#### Console output: with relative function numbers
```markdown
MYENTITY        1    N-1         12  ✅  - An event occurred
                                           Effect: this should happen next
MYENTITY        1   !N-2         73  🔴  - Validation FAILED
                                           Effect: this should happen next
MYENTITY        2    N-1         85  ✅  - An event occurred
                                           Effect: this should happen next
MYENTITY        2   !G-2        163  ⚔️  - myInstance IS nil
                                           Effect: this should happen next
MYENTITY        2    C-3        198  ✅  - A switch case resolved to true
                                           Effect: this should happen next
```


