# Function type

An enum used by the non public structure `EntityLogService` to model the function 'type' of an <doc:EntityLogService> entity function object.

## Overview
The function type value is used to decide how the output of a Function name node type print statement should be formatted. You set the value of the <doc:EntityLogService> JSON file `function_type` key for each function.

Important: the value assigned to `function_type` must be selected from one of the values specified in the table below. However, the exact use of this key is discretional: any value (from the prescribed list) can be used for any ‘type’ of function, mapped to signify an alternative ‘type’ or the default value “f” (custom function) can be used for all functions.

Note that ‘type’ does not refer to the defined Swift type for the function but to a grouping based on general task area.

The purpose of grouping functions according to general task area is to provide an additional visual cue that can make it easier to identify anomalies or unexpected paths taken in the control flow. The list of function groups available provides a range of possibilities and is not intended to be exhaustive or the representation of an ideal demarcation.


### Function values and output descriptions

The function type value is used to assign both the function name <doc:Node-type> symbol and the function type character symbol (see <doc:Formatting>) in the print statement output column for function name node types.

| Value | Name                      | Output Description                                           |
| ----- | ------------------------- | ------------------------------------------------------------ |
| i     | InitialiserFunction name  | An initialiser                                               |
| f     | Custom function           | A custom function.                                           |
| o     | Override                  | A custom override of an Apple API method.                    |
| a     | Action method             | An action method.                                            |
| g     | Delegate method           | A custom override of an Apple API delegate method.           |
| d     | Datasource method         | A custom override of an Apple API datasource method.         |
| v     | Computed variable         | The name of a computed variable.                             |
| e     | Protocol extension method | A method whose implementation resides in a Protocol extension. |






 
