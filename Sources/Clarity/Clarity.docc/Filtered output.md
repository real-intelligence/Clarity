# Filtered output

Filter console output to display specific print statements.

## Overview
``Clarity`` provides a range of settings that can be combined to customise console output: this includes the ability to filter output to display specific print statements.

Edit values in the <doc:Settings> JSON file to log output from specific print statements. Note that different display settings can be combined to create subsets allowing granular isolation of project areas of specific concern.  


### Display output from specified print numbers only
Provide a list of the print numbers required for print statement console output to the `isolatedPrintNumbers` array and set `logIsolatedPrintNumbersOnly` to `true`.  

```json
{
    ...
    "logIsolatedPrintNumbersOnly":true,
    "isolatedPrintNumbers":[
            4, 52, 78
    ],
    ... 
}
``` 

### Display output from specified functions only
Add an object to the `isolatedFunctions` array for each entity that contains functions that are required to be isolated. Then add a list of function numbers for the functions to each `isolatedFunctionNumbers` array. Finally assign each `entityCode` value and set `isolate` to `true`.  

```json
{
    ...
    "isolatedFunctions":[
        {
            "entityCode":"MyEntity",
            "isolate":true,
            "isolatedFunctionNumbers":[
                52, 48
            ]
        },
        {
            "entityCode":"MyOtherEntity",
            "isolate":true,
            "isolatedFunctionNumbers":[
                101, 71
            ]
        }
    ],

}
``` 

### Display output from specified entity codes only
Add an object to the `isolatedEntities` array for each entity that contains print statements that are required to be isolated. Then assign each `entityCode` value and set `isolate` to `true`.  

```json
{
    ...
    "isolatedEntities":[
        {
            "entityCode":"MyEntity",
            "isolate":true
        },
        {
            "entityCode":"MyOtherEntity",
            "isolate":true
        }
    ],
    ...
}
``` 

### Suppress output of called function names
Set `suppressLogFunctionNames` to `true` to suppress the output of print statements that include an argument for called function names.

```json
{
    ...
    "suppressLogFunctionNames":true,
    ...
}
``` 

### Display output from called function names only
Set `logFunctionNamesOnly` to `true` to only display the output of print statements that include an argument for called function names.

```json
{
    ...
    "logFunctionNamesOnly":true,
    ...
}
``` 
### Override filter settings
Easily override all existing filter settings using `printAllClarityLogs` to display the output from all print numbers. 

```json
{
    ...
    "printAllClarityLogs":true,
    ...
}
``` 
Alternatively, override all existing filter settings using `suppressAllClarityLogs` to suppress the output from all print numbers. 
Note that `suppressAllClarityLogs` overrides `printAllClarityLogs`.
```json
{
    ...
    "suppressAllClarityLogs":true,
    ...
}
``` 


## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
