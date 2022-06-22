# Node type

An enum used by the non public structure `EntityLogService` to model the node type of a print statement.

## Overview

A print statement node type is used by ``Clarity`` to decide whether to display its output and if so, how its output should be formatted. Set the value of the <doc:EntityLogService> JSON file `node_type` key for each associated print statement.

Node types are divided into one of three groups:
- Function name
- Control flow
- Reporter 

### Node type values and output descriptions

| Value | Name          | Output Description |
| ----- | ------------- | ------------------ |
| 0     | Function name | A function name.   |

A print statement output will include the function name if the `#function` macro is supplied as argument to the optional `functionName` parameter of the ``print(_:functionName:settings:)`` version of the overload.

If no argument is supplied to a print statement that has its associated `node_type` key value set to 0 the output will simply display the entity code, the function type symbols and the function number.

| Value | Name                               | Output Description                                           |
| ----- | ---------------------------------- | ------------------------------------------------------------ |
| 1     | If true condition                  | A conditional `if` statement resolved successfully in the control flow. |
| 2     | Else condition                     | A conditional `if` statement failed to resolve successfully and reached a paired `else` clause in the control flow. |
| 3     | If true condition negative outcome | A conditional `if` statement resolved successfully that has a negative or undesired outcome in the control flow. |
| 4     | Else condition positive outcome    | A conditional `if` statement failed to resolve successfully and reached a paired `else` clause that has a positive or desired outcome in the control flow. |
| 5     | Case true positive outcome         | The successful match of a conditional `switch` statement case that has a positive or desired outcome in the control flow. |
| 6     | Case true negative outcome         | The successful match of a conditional `switch` statement case that has a negative or undesired outcome in the control flow. |
| 7     | Guard pass                         | A conditional `guard` statement resolved successfully in the control flow. |
| 8     | Guard fail                         | A conditional guard statement failed to resolve successfully and reached its associated else clause in the control flow. |
| 9     | Do try pass                        | The execution of the `do` block of a `do-catch` statement after successfully attempting `try` on a function that throws an error in the control flow. |
| 10    | Catch try fail                     | The execution of the `catch` block of a `do-catch` statement after unsuccessfully attempting `try` on a function that throws an error in the control flow. |

 

| Value | Name           | Output Description        |
| ----- | -------------- | ------------------------- |
| 11    | Value reporter | A value or comment report. |

A print statement output will be displayed as a value report if a value argument is supplied to the optional `values` parameter of the ``print(_:values:settings:)`` version of the overload. 

If a value argument is supplied any value or values are displayed on subsequent lines in the console after the report description.

If no argument is supplied to the print statement the output will simply display the report `event_description` as a comment.

 

| Value | Error          | Output Description |
| ----- | -------------- | ------------------ |
| 12    | Value reporter | An error report.    |

A print statement output will be displayed as an error report if the value argument supplied to the optional `values` parameter of the ``print(_:values:settings:)`` version of the overload  conforms to the 'Error' protocol.

If an error argument is supplied the error is displayed on the following line in the console after the error report `event_description`.

If the error conforms to `LocalizedError` the error will be displayed as a `NSLocalizedString` written for the specific custom error case. Otherwise the error will be described as the type name of the `Error` supplied to the `values` parameter.

If no argument is supplied to the print statement the output will simply display the error report `event_description` as a comment without actual error information.



## Topics

### Output Content

- ``print(_:functionName:settings:)``
- ``print(_:values:settings:)``
