# ``Clarity``

**Clarity** is a logging framework that prints log data referenced from JSON to the console and displays the output using semantic formatting.    

## Overview

Clarity assumes three main ‘nodes’ of interest in an application control flow: function call points, the resolution of conditional statements and the reporting of specific values including errors. Clarity print statements are designed to be placed at such node points in the client application source code – see <doc:Node-type>.

All message data relating to each print statement is placed entirely in associated JSON files referenced by a unique number. This enables the printing of an unlimited amount of information to the console with negligible impact on the source code - see <doc:EntityLogService>.

The customisable formatting of console log output is designed to emphasise nodes of interest in a clear narrative of the control flow. The output includes symbols that relate to the functionality and purpose of the code such that it is human readable and understandable at first sight – see <doc:Formatting>. 

Customisable settings enable the isolation of specific elements and referenced data – see <doc:Settings>. 

The minimal API consists of two overload analogues of the Swift [`print(_:separator:terminator:)`](https://developer.apple.com/documentation/swift/1541053-print) function – these functions: ``print(_:functionName:settings:)`` and  ``print(_:values:settings:)`` reference associated JSON data via an index. 

New to Release are two functions for use when working with Combine publishers: ``print(_:valuesForPublisherType:settings:)`` and an extension overload of [`print(_:to:)`](https://developer.apple.com/documentation/combine/publishers/receiveon/print(_:to:)/).

Note that the term *print statements* used in this documentation always refers to **Clarity** print statements unless stated otherwise.

![The Clarity logo – the word Clarity in bright font on a black background illuminated by a torch ](clarity-logo.png)

## Topics

### Essentials
- <doc:/tutorials/Clarity>
- <doc:GettingStarted>

### Activating Clarity
- ``ClarityActivator``
- ``ClarityActivator/init(withBundle:inPrintMode:displayStatus:)``
 



### Output content
- <doc:Create-a-control-flow-narrative>
- <doc:Output-called-function-names>
- <doc:Output-values-and-errors>
- ``print(_:values:settings:)``
- ``print(_:functionName:settings:)``
- ``print(_:valuesForPublisherType:settings:)``


### Display Settings

- <doc:Filtered-output>
- <doc:Relative-numbering>
- <doc:Tag-only-display>
- <doc:Suppress-output>
- <doc:Dynamic-Settings>
- ``SettingsManagerService``

### Custom Formatting
- <doc:Choose-symbols-for-semantic-formatting>


### JSON Reference

- <doc:EntityLogService>
- <doc:Settings>
- <doc:Formatting>
- <doc:Node-type>
- <doc:Function-type>





