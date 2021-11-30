## Formatting JSON reference

### Top level keys

| Key                           | Type                                                         | Description                                                  |
| ----------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| outcome_symbols               | JSON object: see in [dedicated table](#outcome_symbols key JSON object) | A JSON object that contains key value pairs for the outcome symbols associated with control flow nodes, reporter and error nodes.<br /><br />An outcome symbol is embedded in the first line of output between the node number and the event description.<br /><br />Note: the outcome symbols associated with reporter and error nodes have fixed meaning as opposed to the dynamic semantically assigned control flow nodes. |
| controlflow_node_type_symbols | JSON object: see in [dedicated table](#controlflow_node_type_symbols key JSON object) | A JSON object that contains key value pairs for the node type symbols associated with control flow, reporter and error nodes.<br/><br/>A control flow node type symbol is embedded in the first line of output between the function number and the node number.<br/><br/>Important: Although the value of `controlflow_node_type_symbols` can be assigned to any string it must be the same length for all keys. For readability it is recommended to assign a single character to the symbols.<br /><br />Note: an exclamation mark will be automatically inserted directly before the control flow node type symbol if the node type is the converse clause of another node (if else ), the catch block of a do-catch statement or the else clause of a guard statement.<br/><br/>The exclamation mark currently acts as an additional visual cue but also serves as the partial implementation of a future feature where nodes in converse clauses can be optionally represented by a single node number. |
| function_type_symbols         | JSON object: see in [dedicated table](#function_type_symbols key JSON object) | A JSON object that contains key value pairs for the symbols associated with the function ‘type’ of a function name node type.<br/><br/>A function ‘type’ symbol is embedded in the first line of output between the entity code and the function number.<br/><br/>Note: a character equal to the value assigned to `function_type` as specified in its associated EntityLogService JSON file will be automatically inserted directly after the (custom) function ‘type’ symbol. |
| spacers                       | JSON object: see in [dedicated table](#spacers key JSON object) | A JSON object that contains key value pairs for custom spacer values.<br/><br/>**Custom spacer 1** is embedded in all lines of output directly before the equivalent position of the entity code.<br/>**Custom spacer 2** is embedded in all lines of output directly before the equivalent position of the function number.<br/>**Custom spacer 3** is embedded in all lines of output directly before the equivalent position of the control flow symbol (including exclamation mark / placeholder).<br/>**Custom spacer 4** is embedded in all lines of output directly before the equivalent position of the outcome symbol.<br/><br/>Custom spacers are used to add additional space as required between information blocks in the console according to screen width and developer preference. <br/><br/>The default value is zero (space characters) and the key value has no upper limit.<br/>One integer is equivalent to one character space in the console. |

 

### outcome_symbols JSON object keys

| Key                                | Type   | Default value |
| ---------------------------------- | ------ | ------------- |
| if_true_condition                  | String | ✅             |
| else_condition                     | String | 🔴             |
| if_true_condition_negative_outcome | String | ⚠️             |
| else_condition_positive_outcome    | String | ✅             |
| case_true_positive_outcome         | String | ✅             |
| case_true_negative_outcome         | String | ⚠️             |
| guard_pass                         | String | ☑️             |
| guard_fail                         | String | ⚔️             |
| do_try_pass                        | String | ✅             |
| catch_try_fail                     | String | 🎣             |
| value_reporter                     | String | 📋             |
| error_reporter                     | String | ☎️             |



### controlflow_node_type_symbols JSON object keys

| Key                 | Type   | Default value |
| ------------------- | ------ | ------------- |
| if_else_conditional | String | N             |
| switch_case         | String | C             |
| guard               | String | G             |
| do_catch_try        | String | T             |
| value_reporter      | String | R             |
| error_reporter      | String | E             |



### function_type_symbols JSON object keys

| Key                       | Type   | Default value |
| ------------------------- | ------ | ------------- |
| initialiser               | String | ♻️             |
| custom_function           | String | 🏓             |
| system_method_override    | String | 🍏             |
| action_method             | String | 🎯             |
| delegate_method           | String | 🔮             |
| datasource_method         | String | 📀             |
| computed_variable         | String | 💻             |
| protocol_extension_method | String | 🧩             |



### spacers JSON object keys

| Key     | Type | Default value |
| ------- | ---- | ------------- |
| spacer1 | Int  | 0             |
| spacer2 | Int  | 0             |
| spacer3 | Int  | 0             |
| spacer4 | Int  | 0             |

