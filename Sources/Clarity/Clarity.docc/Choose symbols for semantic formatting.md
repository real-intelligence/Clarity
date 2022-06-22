# Choose symbols for semantic formatting

Clarity provides the ability to customise all symbols used by its semantic formatting system.

## Overview

The output of ``Clarity`` print statements incorporates a range of symbols that help to convey the meaning of outcomes and information related to each print statement. 

Edit the <doc:Formatting> JSON file to customise any of the symbols used. There are three JSON objects that represent symbol content of specific column output in the console and a fourth that represents distances between column blocks. 

### Outcome symbols
Edit the parameters of the `outcome_symbols` object to customise any of the symbols that are displayed in the conditional outcome column. Note that this column can also include error or other 'reporter' symbols.  

#### Formatting JSON: (default)

```json
{
    "outcome_symbols":
    {
        "if_true_condition":"✅",
        "else_condition":"🔴",
        "if_true_condition_negative_outcome":"⚠️",
        "else_condition_positive_outcome":"✅",
        "case_true_positive_outcome":"✅",
        "case_true_negative_outcome":"⚠️",
        "guard_pass":"☑️",
        "guard_fail":"⚔️",
        "do_try_pass":"✅",
        "catch_try_fail":"🎣",
        "value_reporter":"📋",
        "error_reporter":"☎️"
    },
    ...
}
``` 
#### Console output: (default)
```markdown
MYENTITY        1    N-12   ✅  - An if true condition event occurred
                                  Effect: this should happen next
```
#### Formatting JSON: edited
```json
{
    "outcome_symbols":
    {
        "if_true_condition":"😃",
    ...
    }
}
```
#### Console output: edited
```markdown
MYENTITY        1    N-12   😃  - An if true condition event occurred
                                  Effect: this should happen next
```


### Control flow node-type symbols
Edit the parameters of the `controlflow_node_type_symbols` object to customise any of the symbols that are displayed in the control flow node-type column. Note that this column groups node types regardless of outcome and can also include error or 'reporter' symbols. The default implementation utilises string characters for symbols. 

#### Formatting JSON: (default)

```json
{
    ...
    "controlflow_node_type_symbols":
    {
        "if_else_conditional":"N",
        "switch_case":"C",
        "guard":"G",
        "do_catch_try":"T",
        "value_reporter":"R",
        "error_reporter":"E"
    },
    ...
}
``` 
#### Console output: (default)
```markdown
MYENTITY        1    N-12   ✅  - An if true condition event occurred
                                  Effect: this should happen next
```
#### Formatting JSON: edited
```json
{
    ...
    "controlflow_node_type_symbols":
    {
        "if_else_conditional":"D",
    ...
    }
    ...
}
```
#### Console output: edited
```markdown
MYENTITY        1    D-12   ✅  - An if true condition event occurred
                                  Effect: this should happen next
```
### Function-type symbols
Edit the parameters of the `function_type_symbols` object to customise any of the symbols that are displayed in the function-type column. 
     
The purpose of grouping functions according to general task area is to provide an additional visual cue that can make it easier to identify anomalies or unexpected paths taken in the control flow. The list of function groups available provides a range of possibilities and is not intended to be exhaustive or the representation of an ideal demarcation.

Although key names cannot be edited or key/values added you can 'map' any of the keys available to represent an alternative grouping of your choice.


#### Formatting JSON: (default)

```json
{
    ...
    "function_type_symbols":
    {
        "initialiser":"♻️",
        "custom_function":"🏓",
        "system_method_override":"🍏",
        "action_method":"🎯",
        "delegate_method":"🔮",
        "datasource_method":"📀",
        "computed_variable":"💻",
        "protocol_extension_method":"🧩"
    },
    ...
}
``` 
#### Console output: (default)
```markdown
MYENTITY 🏓f   52    myFunction()
```
#### Formatting JSON: edited
```json
{
    ...
    "function_type_symbols":
    {
        ...
        "custom_function":"🐸",
        ...
    },
    ...
}
```
#### Console output: edited
```markdown
MYENTITY 🐸f   52    myFunction()
```


### Custom spacers
Edit the parameters of the `spacers` object to customise the distance between column blocks displayed in the console. 

The custom spacers are positioned within each console message line as follows:
     
- `spacer1` is positioned before the entity code.
- `spacer2` is positioned between the function symbol group and the function number. 
- `spacer3` is positioned between the function number and function name or node symbol group. 
- `spacer4` is positioned between the node symbol group and the outcome symbol.

All print statement output is adjusted so that columns align regardless of content, <doc:Node-type> or output line type.


#### Spacer positions
```markdown

`spacer1`MYENTITY   🏓f `spacer2` 52`spacer3`    myFunction()
`spacer1`MYENTITY       `spacer2`  1`spacer3`    N-12`spacer4`   ✅  - An if true condition event occurred
`spacer1`               `spacer2`   `spacer3`        `spacer4`         Effect: this should happen next
```



#### Formatting JSON: (default)

```json
{
    ...
    "spacers":
    {
        "spacer1":0,
        "spacer2":0,
        "spacer3":0,
        "spacer4":0
    }
}
``` 
#### Console output: (default)
```markdown
MYENTITY 🏓f   52    myFunction()
MYENTITY        1    N-12   ✅  - An if true condition event occurred
                                  Effect: this should happen next
```
#### Formatting JSON: edited
```json
{
    ...
    "spacers":
    {
        "spacer1":2,
        "spacer2":4,
        "spacer3":3,
        "spacer4":1
    }
}
```
#### Console output: edited
```markdown
  MYENTITY     🏓f   52       myFunction()
  MYENTITY            1       N-12    ✅  - An if true condition event occurred
                                            Effect: this should happen next
```


## Topics

### JSON Reference

- <doc:Formatting>
