# ``Clarity/print(_:values:settings:)``



Formatting and display output from the use of this function is controlled by user preferences in the associated <doc:Settings> and <doc:Formatting> JSON files.

- Conditional node details output to the console include: entity code, function number, node symbol, node number, outcome symbol and the event description: the effect description is output on the following line.

- Value report node details output to the console include: entity code, function number, report node symbol, node number, report symbol and the variable/value name/descriptor or error custom description: the value(s) is/are output on the following line(s). If the value is an instance conforming to the [`Error`]( https://developer.apple.com/documentation/swift/error) protocol the error description is output on the following line.

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
                    "print_number":5,
                    "node_type":11,
                    "event_description":"in myArray",
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

//Source code
func myFunction(){

    let myArray = [1,2]
    print(35)
    print(5, values: myArray)
}

//Console output:
ENTCC        15    N-35    ✅  - An expected event occurred
                                 Effect:this should happen next
ENTCC        15    R-5     📋  - Values for variables in myArray are:
                                 1
                                 2
````

## Overview
The Clarity framework assumes three main ‘nodes’ of interest in a control flow: function call points, the resolution of conditional statements and the reporting of specific values including descriptions of [`Error`]( https://developer.apple.com/documentation/swift/error) instances. This function is intended to be placed at such node points in the client application source code.

All message data relating to each print number is placed entirely in associated <doc:EntityLogService> JSON files that include a parameter for its specific <doc:Node-type>. This enables the printing of an unlimited amount of information to the console with negligible impact on the source code.

This function is defined outside a struct or class to enable clients to call it without having to specify a defining type – in the same manner as the Swift [`print(_:separator:terminator:)`](https://developer.apple.com/documentation/swift/1541053-print) function. A function call node and a value report node would never be associated with the same print number and therefore have separate overloads.

### SwiftUI extension versions
Note that there are equivalent versions of this function written in extensions on the SwiftUI protocols [`View`](https://developer.apple.com/documentation/swiftui/view) and [`ViewModifier`](https://developer.apple.com/documentation/swiftui/viewmodifier), the documentation for which cannot currently be displayed within [DocC](https://developer.apple.com/documentation/docc). These extension versions return an empty [`View`](https://developer.apple.com/documentation/swiftui/view) or [`ViewModifier`](https://developer.apple.com/documentation/swiftui/viewmodifier) that allows the function to be used within the [`body`](https://developer.apple.com/documentation/swiftui/view/body-swift.property)  variable of a [`View`](https://developer.apple.com/documentation/swiftui/view) or within a [`ViewModifier`](https://developer.apple.com/documentation/swiftui/viewmodifier). See the following links on the [realint.org ](https://realint.org/claritydevdocs/index.html) developer site for the documentation.



[print(_:values:settings:) -> View ](https://realint.org/claritydevdocs/Extensions/View.html#/s:7SwiftUI4ViewP7ClarityE5print_6values8settingsQrSi_ypSgAD22SettingsManagerServiceVSgtF)

[print(_:values:settings:) -> ViewModifier](https://realint.org/claritydevdocs/Extensions/ViewModifier.html#/s:7SwiftUI12ViewModifierP7ClarityE5print_6values8settingsQrSi_ypSgAD22SettingsManagerServiceVSgtF)


### Publishers.ReceiveOn extension version
New to Release 2 there is a version of Clarity print statement written as an overload on the default [`print(_:to:)`](https://developer.apple.com/documentation/combine/publishers/receiveon/print(_:to:)/) structure in an extension for the [`Publishers.ReceiveOn`](https://developer.apple.com/documentation/combine/publishers/receiveon/) structure. Use this function in the same manner as [`print(_:to:)`](https://developer.apple.com/documentation/combine/publishers/receiveon/print(_:to:)/) but provide a print number for the first parameter. The method will then compile Clarity formatted log information and pass it to the `prefix` parameter of the Swift version of the method that will be called in turn. 


Example:
````
...
    .receive(on: DispatchQueue.main).print(printMe(600), to: nil)
````

Also new in Release 2 there is a related function ``print(_:valuesForPublisherType:settings:)`` that takes a generic publisher type and outputs the Output and Failure type for the specific publisher in the form of a `Dictionary<String:String>` value formatted as a value reporter.

Example:
````
    print(2, valuesForPublisherType: URLSession.DataTaskPublisher.self)
````


## Topics


### Related tutorials
- <doc:tutorials/Clarity/Add-print-statements>




