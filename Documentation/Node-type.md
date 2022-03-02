## Node type reference

### EntityLogService JSON > entity_functions  > function_nodes > [node_type](EntityLogService.md#node_type ) key

| Value | Name                               | Functionality – renders the print statement output as signifying: |
| ----- | ---------------------------------- | ------------------------------------------------------------ |
| 0     | Function name                      | a function name.<br/><br/>The message will include the function name if the `#function` macro is supplied as argument to the optional `functionName` parameter of the `print(_:functionName:settings:)` overload.<br/><br/>If there is no argument supplied the print statement output will simply display the entity code, function symbol and function number. |
| 1     | If true condition                  | a conditional `if` statement resolved successfully in the control flow. |
| 2     | Else condition                     | a conditional `if` statement failed to resolve successfully and reached a paired `else` clause in the control flow. |
| 3     | If true condition negative outcome | a conditional `if` statement resolved successfully that has a negative or undesired outcome in the control flow. |
| 4     | Else condition positive outcome    | a conditional `if` statement failed to resolve successfully and reached a paired `else` clause that has a positive or desired outcome in the control flow. |
| 5     | Case true positive outcome         | the successful match of a conditional `switch` statement case that has a positive or desired outcome in the control flow. |
| 6     | Case true negative outcome         | the successful match of a conditional `switch` statement case that has a negative or undesired outcome in the control flow. |
| 7     | Guard pass                         | a conditional `guard` statement resolved successfully in the control flow. |
| 8     | Guard fail                         | a conditional guard statement failed to resolve successfully and reached its associated else clause in the control flow. |
| 9     | Do try pass                        | the execution of the `do` block of a `do-catch` statement after successfully attempting `try` on a function that throws an error in the control flow. |
| 10    | Catch try fail                     | the execution of the `catch` block of a `do-catch` statement after unsuccessfully attempting `try` on a function that throws an error in the control flow. |
| 11    | Value reporter                     | a value or comment report.<br /><br />The message will be displayed as a value report if a value argument is supplied to the optional `values` parameter of the `print(_:values:settings:)` overload.<br /><br />If there is no argument supplied the print statement output will simply display the report `event_description` as a comment.<br /><br />If a value argument is supplied any value or values are displayed on subsequent lines in the console after the report description. |
| 12    | Error reporter                     | an error report.<br /><br />The message will be displayed as an error report if the value argument supplied to the optional `values` parameter of the `print(_:values:settings:)` overload conforms to the 'Error' protocol.<br /><br />If an error argument is supplied the error is displayed on the following line in the console after the error report `event_description`.<br /><br />If the error conforms to LocalizedError the error will be displayed as a NSLocalizedString written for the specific custom error case. Otherwise the error will be described as the type name of the `Error` supplied to the `values` parameter.<br /><br />If there is no argument supplied the print statement output will simply display the error report `event_description` as a comment without actual error information. |

