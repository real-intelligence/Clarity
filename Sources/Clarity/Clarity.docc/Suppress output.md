# Suppress output

Suppress all output of Clarity print statements.

## Overview

``Clarity`` provides a range of settings that can be used to customise console output from print statements. Edit the <doc:Settings> JSON file to suppress all Clarity print statement output in the console. 

Use this setting as a convenient alternative to editing the source code directly where it is possible to temporarily deactivate Clarity altogether by providing the value `false` to the activation parameter `inPrintMode`.

#### Settings JSON

```json
{
    "suppressAllClarityLogs":true,
    ...
}
``` 

