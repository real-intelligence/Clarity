# Getting Started with Clarity

Activate Clarity, associate a custom entity with an EntityLogService JSON file and log output from a Clarity print statement.

## Overview
``Clarity`` requires its activation initialiser ``ClarityActivator/init(withBundle:inPrintMode:displayStatus:)`` to be added at the entry point of a client application. Once activated you create an <doc:EntityLogService> JSON file for each custom type (entity) that contains ``Clarity`` print statements. Each print statement ``print(_:functionName:settings:)`` or ``print(_:values:settings:)`` is bound to information written in the associated <doc:EntityLogService> JSON file and referenced by a unique print number.

``Clarity`` print statements can include optional parameters that have the following effect: 

- output additional values from the source code
- output a function name only
- modify display settings specific to the print statement


### Activate Clarity

To activate ``Clarity`` in a SwiftUI app, you first create a custom initialiser for the type that acts as the entry point of the application. Within this initialiser, you then initialise an instance of the  ``ClarityActivator`` class, supply the application main Bundle and set the `inPrintMode` parameter to `true`, as the following code shows:


```swift
import Clarity
   
@main
struct ClientSwiftUIApp: App {

  init() {

   ClarityActivator(withBundle: Bundle.main, inPrintMode:true, displayStatus:false)

   ...
 }
```

### Create a Clarity EntityLogService JSON file
After adding the ``Clarity`` activator run the client application in any Xcode device simulator. A folder named ClarityJSON that contains template <doc:EntityLogService> as well as default <doc:Settings> and <doc:Formatting> JSON files will be copied to the desktop.

Drag the folder from the desktop into the Project Navigator under (as a child of) the client project name icon: ensure that you select 'copy as a folder reference' and that the folder appears coloured blue in the Xcode navigator.
![The ClarityJSON folder as it appears after being dragged into the Xcode navigator ](gettingstarted–1–drag-json-folder.png)

Delete the included `ExampleEntityLog.json` file and then duplicate the `TemplateEntityLogStructure.json` file. Associate this file with a custom type – class, struct or enum (entity) in the client project: rename the file and assign the JSON key `entity_code` with a string value to represent the entity in console output.  

- Add an **entity function** object for each function that will contain ``Clarity`` print statements.
  Allocate a number to each function that is unique to the entity and assign a value for its <doc:Function-type>.

- Add a **function node** object to the entity function object for each print statement contained in the function. 

- Assign values to the prescribed parameters of each function node object (logging information specific to each print statement) including a print number unique to the application and a <doc:Node-type>. 
  Note that the information is bound by the unique print number: it is therefore the responsibility of the developer to ensure that print numbers are grouped within the intended entity function object and <doc:EntityLogService> JSON file. 



```json
{
   "entity_code":"MYENTITY",
   "entity_functions" : [
       {
           "function_number":52,
           "function_number_always_custom":false,
           "function_type":"f",
           "function_nodes":[
               {
                   "print_number":1,
                   "node_type":0,  
                   "event_description":"",
                   "effect_description":""
               },
               {
                   "print_number":2,
                   "node_type":1,
                   "event_description":"An event occurred",
                   "effect_description":"this should happen next"
               }
           ]
       }
   ]
}
```
### Log output from a Clarity print statement
Place print statements wherever they are required in the control flow of your application.

``Clarity`` print statements behave as an analogue overload of the familiar Swift [`print(_:separator:terminator:)`](https://developer.apple.com/documentation/swift/1541053-print) function and can be called directly: this makes it intuitive to write ``Clarity`` print statements and helps to keep the code source uncluttered. 




```swift
import Clarity

struct MyEntity{ // associated with "MYENTITY"

    func myFunction(){
        print(1, functionName: #function)
    ...    
    /// some event occurs
        print(2)
    }
}
```

The console output will appear approximately as follows:

```markdown
MYENTITY 🏓f   52    myFunction()
MYENTITY       52    N-2    ✅  - An event occurred
                                  Effect: this should happen next
```


## Topics


### Output content
- <doc:Create-a-control-flow-narrative>
