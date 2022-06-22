# EntityLogService

The intermediate service model used by the non public structure `EntityLogService` to decode JSON data from `EntityLogService` JSON files in the ClarityJSON folder.
     

## Overview

All console output data relating to each print statement is written entirely in associated `EntityLogService` JSON files and referenced by a unique print number.

The model matches the structure of the JSON exactly with the intention of being used to service an internal `EntityLog` instance that models the JSON differently.
     
The structure of `EntityLogService` JSON is designed for developer convenience: function object parameters are positioned at a higher level than the print number within the JSON hierarchy to model the placement of print statements within functions in source code.
     

### Keys and descriptions: top level JSON object
 

| Key         | Type   | Description                                                  |
| ----------- | ------ | ------------------------------------------------------------ |
| entity_code | String | A unique string of any length to describe the custom type (entity) – class, struct or enum that contains ``Clarity`` print statements referenced by an EntityLogService JSON file. |



Multiple entities can assign `entity_code` values with different lengths.

The `entity_code` value string can include Apple symbols (for example to represent entities from particular modules). 

Entity codes are always displayed as the first item in the first line of any ``Clarity`` print statement.

Note that the `EntityLogService` JSON object for a particular entity can be distributed across multiple JSON files. In this case you assign an identical `entity_code` value but each file would need a unique name to reside in the single ClarityJSON folder.


| Key              | Type  | Description                                                  |
| ---------------- | ----- | ------------------------------------------------------------ |
| entity_functions | Array | An array of JSON objects that represent the functions contained in the entity. |




### Keys and descriptions: entity_functions array


| Key             | Type | Description                                                  |
| --------------- | ---- | ------------------------------------------------------------ |
| function_number | Int  | A custom number used to identify the function in the console. |



The number assigned to `function_number` should be unique to the entity but can remain the default value `0` if `calculateFunctionNumbersRelativeToEntity` is assigned to true in <doc:Settings>.

The number is displayed in ``Clarity`` print statement output for function name nodes and in the first line of all other nodes.

The number will be overwritten and replaced with the (1-based) index of the function object within the `entity_functions` array if `calculateFunctionNumbersRelativeToEntity` is assigned to true.



| Key                           | Type | Description                                                  |
| ----------------------------- | ---- | ------------------------------------------------------------ |
| function_number_always_custom | Bool | A bool that can be used to override the value of `calculateFunctionNumbersRelativeToEntity` if it is assigned to true for the particular function. |



If `function_number_always_custom` is assigned to true the value assigned to `function_number` will be displayed in the console to represent the function in all occurrences.

Use this parameter where certain function numbers need to remain constant and clearly identifiable when using the relative numbering system. Note that in this circumstance it is advisable to assign a considerably larger custom value than the count of functions within an entity to avoid duplication.        

| Key           | Type   | Description                                                  |
| ------------- | ------ | ------------------------------------------------------------ |
| function_type | String | A string character used as a descriptor for the function 'task area' category or grouping.|


Important: the value assigned to `function_type` must be selected from a range of values specified in the <doc:Function-type> enum reference. However, the exact use of this key is discretional: any value (from the prescribed list) can be used for any 'type' of function, mapped to signify an alternative 'type' or the default value "f" (custom function) can be used for all functions.

Note that ‘type’ does not refer to the defined (Swift) type for the function but to a grouping based on general task area. 

The purpose of grouping functions according to general task area is to provide an additional visual cue that can make it easier to identify anomalies or unexpected paths taken in the control flow. The list of function groups available provides a range of possibilities and is not intended to be exhaustive or the representation of an ideal demarcation.

This key affects the output of two different symbols in the console that together comprise the function symbol group: the customisable function symbol (see `function_type_symbols` in <doc:Formatting> ) and the constant symbol that matches the value assigned to `function_type`.







| Key            | Type  | Description                                                  |
| -------------- | ----- | ------------------------------------------------------------ |
| function_nodes | Array | An array of JSON objects that represent 'nodes' associated with specific print statements in the source code: each of these print statements is contained within the implementation body of the function represented by `function_number`. |

It is a good convention to reserve the first item in the function nodes array for a function name print statement – see <doc:Output-called-function-names> .


### Keys and descriptions: function_nodes array
| Key          | Type | Description                                                  |
| ------------ | ---- | ------------------------------------------------------------ |
| print_number | Int  | A unique number that is used to reference a specific print statement in the source code. |

The template JSON default placeholder value of zero assigned to `print_number` is ignored by ``Clarity``.

Important: the print number must be unique within each client application.

| Key       | Type | Description                                                  |
| --------- | ---- | ------------------------------------------------------------ |
| node_type | Int  | A number that is used to define the ‘node type’ of the node referenced by `print_number`. |

There are currently three groupings of node type:

- Function name: node type 0
- Control flow: node types 1-10
- Reporter: node types 11-12

The output rendered for all node types is described in the <doc:Node-type> reference.


| Key               | Type   | Description                                                  |
| ----------------- | ------ | ------------------------------------------------------------ |
| event_description | String | A string used in the first line of output from a print statement to describe outcomes or reports. |


There are four types of content that can be assigned to `event_description` depending on the node type.

- Control flow: a string used to describe the event that occurred at the decision point in the source code that caused the control flow node to resolve to its specified node type.
- Value Reporter: a string used to name the variable or/and describe the purpose of the variable that has its value(s) automatically listed on subsequent lines in the console.
- Comment Reporter:  a string used to provide a comment about the source code at or near the line that contains the print statement for `print_number`.
- Error Reporter: a string used to name or provide a custom description of the instance returning the Error automatically described on the subsequent line in the console.

Note that this key is not used in conjunction with the Function name node type.

| Key                | Type   | Description                                                  |
| ------------------ | ------ | ------------------------------------------------------------ |
| effect_description | String | A string used in the second line of output from a print statement to describe the effect expected to occur as a result of the event described in `event_description`. |

The effect string is automatically prefixed with the label 'Effect:'

If this value is not required it should remain assigned to the placeholder empty string: the second line output for control flow node types will then be empty other than the inclusion of the ‘Effect:’ label.


Note that this key is not used in conjunction with the Function name node type or any of the Reporter node types.





