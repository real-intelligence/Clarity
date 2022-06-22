# ``Clarity/ClarityActivator/init(withBundle:inPrintMode:displayStatus:)``

The ``Clarity`` activation initialiser should only be called once in an application.

The main bundle is used to access the user Clarity JSON files stored in the ClarityJSON folder: these files are used to calculate, format and output to the console information that correlates to the print number of Clarity print statements.

This initialiser is not required by the Clarity framework test target during internal testing of the functionality of the framework. The JSON data derived properties are set lazily by calling JSONAccess protocol generic decoding methods.

 The initialiser is set  `@discardableResult` as a convenience for the client application activation API.

## Overview
The main internal tasks of this initialiser are to:
- detect if the value assigned to `inPrintMode` does not concur with the client application DEBUG status. This is only relevant if ``Clarity`` is installed as an embedded framework. Note that this functionality will be deprecated (see ``isClientInDebugMode``).
- detect and assign the client application main bundle so that ``Clarity`` can access the client `ClarityJSON` files.
- if a client bundle exists – verify that the necessary JSON files exist in the bundle. The detection of corrupt or invalid JSON is handled by the `JSONAccess` decoder methods.

## Activation example
*App Lifecycle*
```
import Clarity
//...
@main
struct MyProjectApp: App {
    init() {
         ClarityActivator(withBundle: Bundle.main, 
                         inPrintMode: true, 
                       displayStatus:false)
    }
//...
```


## Framework as a client

Framework applications that have a **single** entry point method should activate ``Clarity`` in that entry point method implementation (as shown above for App Lifecycle).

Framework applications that do not have a single entry point will need to implement a class that includes a static variable that lazily stores the result of a closure containing the activation initialiser.  This closure will then need to be accessed by all classes, structs or enums that contain Clarity print statements. This technique will ensure that Clarity is activated only once and that any failure to activate Clarity will not adversely affect the client framework.

Framework applications will need to call the Bundle initialiser `init(for:) ` and supply the implementing class as argument to the `aClass` parameter to access the correct Bundle for the framework.

*Framework as a client – multiple entry points*

```
// Activation
import Clarity

class ClarityServiceExample {

 static let clarityActivation: ClarityActivator? = {
     return ClarityActivator(withBundle: Bundle(for: ClarityServiceExample.self), 
                            inPrintMode: true
                          displayStatus:false)
    }()
}


// Accessing the activation
import Clarity

class MyClass {

    public init(parameterName:Type) {

        // Other initialiser tasks here …

         guard let _ = ClarityService.clarityActivation else{
             print("Clarity activation failed")
             return
         }
         // Place Clarity print statements for the initialiser from here if required.
        // Any other initialiser tasks here …
        }
        // Clarity print statements can now be placed anywhere in the class.
    }
 //...

```

## Topics


### Related tutorials
- <doc:tutorials/Clarity/Activate-for-App-Lifecycle>
- <doc:tutorials/Clarity/Activate-for-App-Delegate>
- <doc:tutorials/Clarity/Activate-as-Framework-Client>
