# Output called function names

Use Clarity to output called function names to the console.

## Overview

The print function overload analogue ``print(_:functionName:settings:)`` includes an optional `functionName` parameter to provide the name of the enclosing function. Provide an argument for this parameter in a print statement to automatically format the output as a function name.    


### Provide a function name argument to a print statement
Use the `#function` macro to automatically provide the name of the enclosing function as a string to the `functionName` parameter. Note that a valid print number must also be provided to the print statement.
#### Source code

```swift
    func myFunction(){
        print(310, functionName: #function)
        ...
    }
```

### Provide a dedicated node for the print statement
Add a function nodes JSON object array item for the print statement to the entity functions object array item associated with the specific function (identifiable by its function number) – in this instance myFunction(). Then assign a print number and keep the <doc:Node-type> value assigned to 0 for your reference only – the node type is set automatically if an argument is provided to the `functionName` parameter. Both the event and effect description should remain assigned to empty strings. 

It is a good convention to associate the first item in the function nodes array with a function name print statement for all functions that contain Clarity print statements. This practice makes it easy to quickly locate functions by function number in the JSON for editing and adding function nodes.

#### EntityLogService JSON
```json
{
   "entity_code":"MYENTITY",
   "entity_functions" : [
       {
           "function_number":52,
           "function_number_always_custom":false,
           "function_type":"f",
           "function_nodes":[
               {
                   "print_number":310,
                   "node_type":0,  
                   "event_description":"",
                   "effect_description":""
               }
           ]
       }
   ]
}
```

#### Console output
Note that only the function number (not the print number) is displayed in the console approximately as follows:
```markdown
MYENTITY 🏓f   52    myFunction()
```
### Using other node types as function name nodes
Note that this practice is NOT recommended.

As stated above, if you provide an argument value to the `functionName` parameter Clarity will override the existing node type. It is therefore possible to reuse the print number of any existing node within the function nodes object array for printing the function name of the enclosing function.  
#### Source code
```swift
    func myFunction(){
        //This will print as a called function name (for function number 52)
        print(12, functionName: #function)
        ...
        //This will print as a control flow node (for print number 12)
        print(12)

    }
```
#### EntityLogService JSON
```json
{
   "entity_code":"MYENTITY",
   "entity_functions" : [
       {
           "function_number":52,
           "function_number_always_custom":false,
           "function_type":"f",
           "function_nodes":[
               {
                   "print_number":12,
                   "node_type":1,  
                   "event_description":"An event occurred",
                   "effect_description":"this should happen next"
               }
           ]
       }
   ]
}
```
#### Console output
```markdown
MYENTITY 🏓f   52    myFunction()
MYENTITY       52    N-12   ✅  - An event occurred
                                  Effect: this should happen next
```

## Topics


### Related tutorials
- <doc:tutorials/Clarity/Add-print-statements>
