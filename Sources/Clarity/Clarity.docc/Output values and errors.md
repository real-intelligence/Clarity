# Output values and errors

Use Clarity to output values and errors to the console.

## Overview

The print function overload analogue  ``print(_:values:settings:)`` includes an optional `values` parameter to provide values or errors for display below the node information presented in the console. Provide an argument for this parameter in a print statement to automatically format the output to include values and errors.


### Provide a value argument to a print statement
Provide a value argument to the `values` parameter of a print statement: this can be a single value of any type, a collection of any type or an instance conforming to the [`Error`]( https://developer.apple.com/documentation/swift/error) protocol. Note that a valid print number must also be provided to the print statement.

#### Source code
```swift
    func myFunction(){
        let myValue = 5
        print(205, values: myValue)
        ...
    }
```
### Provide a node for the print statement
Add a function nodes JSON object array item for the print statement to the entity functions object array item associated with the specific function (identifiable by its function number) – in this instance myFunction(). Then assign a print number and set the <doc:Node-type> value to 11 (the node type for a 'value reporter'). Optionally add the variable name and/or a description of the value to the `event_description` key. Note that the effect description should remain set to an empty string.   

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
                   "print_number":205,
                   "node_type":11,  
                   "event_description":"myValue (describe the purpose here)",
                   "effect_description":""
               }
           ]
       }
   ]
}
```

#### Console output
The console output will appear approximately as follows:
```markdown
MYENTITY       52    N-205  📋  - Value for variable myValue (describe the purpose here) is:
                                  5
```

### Provide an error argument to a print statement
Provide an instance conforming to `Error` as argument to the `values` parameter of a print statement. 

#### Source code

```swift
    func myFunction(){
        do {
            _ = try errorThrowingFunction()
        } catch {
            print(228, values: error)
        }
    }

    func errorThrowingFunction() throws {
        if a specific event happens {
            throw MyLocalisedErrorEnum.myErrorCase
        }
    }
```

### Provide a node for the print statement
Add a function nodes JSON object array item for the print statement to the entity functions object array item associated with the specific function (identifiable by its function number) – in this instance myFunction(). Then assign a print number and set the <doc:Node-type> value to 12 (the node type for an Error reporter). Optionally add a heading or title for the error to the `event_description` key (this will be displayed in the top line of the output for the print statement). Note that the effect description should remain set to an empty string.   

If the error conforms to [`LocalizedError`]( https://developer.apple.com/documentation/foundation/localizederror) the error will be displayed as a [`NSLocalizedString`]( https://developer.apple.com/documentation/foundation/nslocalizedstring) written for the specific custom error case; otherwise the error will be described as the type name of the [`Error`]( https://developer.apple.com/documentation/swift/error) supplied to the values parameter. Both outcomes are displayed in the following line of the output. 

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
                   "print_number":228,
                   "node_type":12,  
                   "event_description":"MyErrorHeading/Title",
                   "effect_description":""
               }
           ]
       }
   ]
}
```

#### Console output
```markdown
MYENTITY       52    N-228  📋  - Error for MyErrorHeading/Title is:
                                  The string value assigned to myErrorCase of the MyLocalisedErrorEnum
```

### Use value reporters to log comments
To log a comment to the console set the <doc:Node-type> value to 11 (value reporter) but omit the `values` parameter for the print statement. Then assign the required comment to the event description.

#### Source code

```swift
    func myFunction(){
        print(301)
        ...
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
                   "print_number":301,
                   "node_type":11,  
                   "event_description":"This is a 'value reporter' without a value to log a comment to the console",
                   "effect_description":""
               }
           ]
       }
   ]
}
```
#### Console output
```markdown
MYENTITY       52    N-301  📋  - This is a 'value reporter' without a value to log a comment to the console

```




## Topics


### Related tutorials
- <doc:tutorials/Clarity/Add-print-statements>
