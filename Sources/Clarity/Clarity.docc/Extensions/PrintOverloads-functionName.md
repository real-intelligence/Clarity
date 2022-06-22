

# ``Clarity/print(_:functionName:settings:)``

Formatting and display output from the use of this function is controlled by user preferences in the associated <doc:Settings> and <doc:Formatting> JSON files.

- Conditional node details output to the console include: entity code, function number, node symbol, node number, outcome symbol and the event description: the effect description is output on the following line.

- Function name node details output to the console include: entity code, function symbol, function number and the function name. Note that there is only one line of output.

**Important:**
 All calls to this function must provide an argument to the `printNumber` parameter.


Example:
````
//EntityLogService JSON file
{
    "entity_code":"ENTCC",
    "entity_functions" : [
        {
            "function_number":15,
            "function_number_always_custom":false,
            "function_type":"f",
            "function_nodes":[
                {
                    "print_number":34,
                    "node_type":0,
                    "event_description":"N/A",
                    "effect_description":"N/A"
                },
                {
                    "print_number":35,
                    "node_type":1,
                    "event_description":"An expected event occurred",
                    "effect_description":"this should happen next"
                }
            ]
        }
    ]
}
//Source code:
func myFunction(){
    print(34, functionName: #function)
    print(35)
}

//Console output:
ENTCC 🏓f    15    myFunction()
ENTCC        15    N-35    ✅  - An expected event occurred
                                 Effect:this should happen next
````

## Overview
The Clarity framework assumes three main ‘nodes’ of interest in a control flow: function call points, the resolution of conditional statements and the reporting of specific values including descriptions of [`Error`]( https://developer.apple.com/documentation/swift/error) instances. This function is intended to be placed at such node points in the client application source code.

All message data relating to each print number is placed entirely in associated <doc:EntityLogService> JSON files that include a parameter for its specific <doc:Node-type>. This enables the printing of an unlimited amount of information to the console with negligible impact on the source code.

This function is defined outside a struct or class to enable clients to call it without having to specify a defining type – in the same manner as the Swift [`print(_:separator:terminator:)`](https://developer.apple.com/documentation/swift/1541053-print) function. A function call node and a value report node would never be associated with the same print number and therefore have separate overloads.

### SwiftUI extension versions
Note that there are equivalent versions of this function written in extensions on the SwiftUI protocols [`View`](https://developer.apple.com/documentation/swiftui/view) and [`ViewModifier`](https://developer.apple.com/documentation/swiftui/viewmodifier), the documentation for which cannot currently be displayed within [DocC](https://developer.apple.com/documentation/docc). These extension versions return an empty [`View`](https://developer.apple.com/documentation/swiftui/view) or [`ViewModifier`](https://developer.apple.com/documentation/swiftui/viewmodifier) that allows the function to be used within the [`body`](https://developer.apple.com/documentation/swiftui/view/body-swift.property)  variable of a [`View`](https://developer.apple.com/documentation/swiftui/view) or within a [`ViewModifier`](https://developer.apple.com/documentation/swiftui/viewmodifier). See the following links on the [realint.org ](https://realint.org/claritydevdocs/index.html) developer site for the documentation.



[print(_:functionName:settings:) -> View ](https://realint.org/claritydevdocs/Extensions/View.html#/s:7SwiftUI4ViewP7ClarityE5print_12functionName8settingsQrSi_SSSgAD22SettingsManagerServiceVSgtF)

[print(_:functionName:settings:) -> ViewModifier](https://realint.org/claritydevdocs/Extensions/ViewModifier.html#/s:7SwiftUI12ViewModifierP7ClarityE5print_12functionName8settingsQrSi_SSSgAD22SettingsManagerServiceVSgtF)


## Topics


### Related tutorials
- <doc:tutorials/Clarity/Add-print-statements>
