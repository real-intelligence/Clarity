# Tag only display

Condense the display of console output to only include the 'tags' associated with each print statement – entity code, function number and node (print) number.

## Overview

``Clarity`` provides a range of settings that can be used to customise console output from print statements. Edit the <doc:Settings> JSON file to remove all control flow node descriptions and symbols from the display of the print statement output in the console.

Use this setting to easily track paths through complex algorithms or to physically print the condensed output of multiple runs onto transparencies to help locate the source of difficult to trace intermittent anomalies.

Combine this setting with `suppressLogFunctionNames` to further condense the display of the path taken through a control flow.

Note that when using tag only display the node number will always render as the print number regardless of the value of `calculateNodeNumbersRelativeToFunction`: on the other hand, Function numbers can still be displayed using relative numbering.

#### Source code
```swift
    ...    
        // Print statements within various functions.
        print(12)
        print(73)
        print(92)
        print(163)
        print(198)
...
```

#### Console output (default setting)
```markdown
MYENTITY 🏓f    8    myFunction8()
MYENTITY        8    N-12   ✅  - An event occurred
                                  Effect: this should happen next
MYENTITY        8   !N-73   🔴  - Validation FAILED
                                  Effect: this should happen next
MYENTITY 🏓f   17    myFunction17()
ENTITY2        17    N-92   ✅  - An event occurred in another entity
                                  Effect: this should happen next
MYENTITY 🏓f   52    myFunction52()
MYENTITY       52   !G-163  ⚔️  - myInstance IS nil
                                  Effect: this should happen next
MYENTITY       52    C-198  ✅  - A switch case resolved to true
                                  Effect: this should happen next
```
#### Settings JSON

```json
{
    ...
    "displayNodeSequenceWithoutDescriptions":true,
    ...
}
``` 
#### Console output: Tag only display
```markdown
MYENTITY 🏓f    8    myFunction8()
MYENTITY        8       12
MYENTITY        8       73
MYENTITY 🏓f   17    myFunction17()
ENTITY2        17       92
MYENTITY 🏓f   52    myFunction52()
MYENTITY       52      163
MYENTITY       52      198

```

#### Settings JSON

```json
{
    ...
    "suppressLogFunctionNames":true,
    ...
    "displayNodeSequenceWithoutDescriptions":true,
    ...
}
``` 

#### Console output: Tag only display & suppress function names
```markdown
MYENTITY        8       12
MYENTITY        8       73
ENTITY2        17       92
MYENTITY       52      163
MYENTITY       52      198

```




