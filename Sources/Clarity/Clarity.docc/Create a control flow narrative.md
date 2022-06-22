# Create a control flow narrative

Use Clarity to output a single print statement as a two line ‘event-effect pair'. 

## Overview

``Clarity`` makes it easy to read a narrative of an application call flow in the console by expanding the output of specific print statements into two lines: the first line describes the event that occurred at the node point, the second line describes the expected consequence of the event. The first line of the event-effect pair is tagged with the **entity code**, **function number** and **print number** of the print statement. 

You write this information in the <doc:EntityLogService> JSON file object associated with the print statement. 
 


### Assign an event-effect pair to a print statement

Add a ``Clarity`` print statement to a function in the source code that references a unique print number. 

#### Source code
```swift
// A struct associated with the entity code "MYENTITY"
struct MyEntity{ 

    func myFunction(){
    ...    
    /// An event occurs 
        print(12)
    }
}
```

#### EntityLogService JSON for the type `MyEntity`
Add a **function nodes** JSON object array item for the print statement to the **entity functions** object array item associated with `myFunction()`. 

Assign the print statement print number, a <doc:Node-type> number and write description strings for the event-effect pair. Note that either the event or effect description can be omitted by assigning an empty string: in this case all other node information for the print statement will continue to be logged to the console. 

Use the node type to describe what kind of event is referenced by the print statement – this value affects the output of the formatting.

The print number must be unique to the application.


```json
...
        "function_nodes":[
            {
                "print_number":12,
                "node_type":1,  
                "event_description":"An event occurred with node type 'true'",
                "effect_description":"this should happen next"
            }

        ]
...
```

#### Console output
The console output for the print statement will appear approximately as follows – after all other necessary JSON parameter values have been assigned as shown in the sample *Entire EntityLogService JSON object for the type MyEntity* below.
```markdown
MYENTITY       52    N-12   ✅  - An event occurred with node type 'true'
                                  Effect: this should happen next
```


### Add an additional node for another print statement

#### Source code
```swift
struct MyEntity{ 

    func myFunction(){
    ...    
    /// An event occurs 
        print(12)
    /// Another event occurs within the same function
        print(45)
    }
}
```
#### EntityLogService JSON for the type `MyEntity`
```json
...
        "function_nodes":[
            {
                "print_number":12,
                "node_type":1,  
                "event_description":"An event occurred with node type 'true'",
                "effect_description":"this should happen next"
            },
            {
                "print_number":45,
                "node_type":1,  
                "event_description":"Another event occurred",
                "effect_description":"this should happen next"
            }
        ]
...
```
#### Console output
```markdown
MYENTITY       52    N-12   ✅  - An event occurred with node type 'true'
                                  Effect: this should happen next
MYENTITY       52    N-45   ✅  - Another event occurred
                                  Effect: this should happen next
```
### Assign function information
Assign a function number and a <doc:Function-type> string character to each **entity functions** object array item. Use the function type to describe what kind of function is referenced by the print statement in the source code – this value affects the output of the formatting.

The function number need only be unique to the <doc:EntityLogService> JSON file object for the custom type `MyEntity` .

Note that function numbers are written in the JSON file and **not** in source code. Each print statement is bound to the associated JSON by its **print number** argument alone – function numbers are derived from the print numbers that an **entity functions** object array item contains. 

```json
...

   "entity_functions" : [
       {
           "function_number":52,
           "function_number_always_custom":false,
           "function_type":"f",
           "function_nodes":[
               {
                   "print_number":12,
                   "node_type":1,  
                   "event_description":"An event occurred with node type 'true'",
                   "effect_description":"this should happen next"
               }
           ]
       }
   ]

...
```
### Add an additional function object for a different function
#### Source code

```swift
// A struct associated with the entity code "MYENTITY"
struct MyEntity{ 

    // Function number 52 
    func myFunction(){
    ...    
    /// An event occurs 
        print(12)
    }

    // Function number 76 
    func myOtherFunction(){
    ...    
    /// An event occurs 
        print(23)

        if something happens{
            //do this
        }else{
            /// An else condition reached
            print(34)
        }
    }
}
```
#### EntityLogService JSON for the type `MyEntity`
```json
...

   "entity_functions" : [
       {
           "function_number":52,
           "function_number_always_custom":false,
           "function_type":"f",
           "function_nodes":[
               {
                   "print_number":12,
                   "node_type":1,  
                   "event_description":"An event occurred with node type 'true'",
                   "effect_description":"this should happen next"
               }
           ]
       },
        {
            "function_number":76,
            "function_number_always_custom":false,
            "function_type":"f",
            "function_nodes":[
                {
                    "print_number":23,
                    "node_type":1,  
                    "event_description":"An event occurred",
                    "effect_description":"this should happen next"
                },
                {
                    "print_number":34,
                    "node_type":2,  
                    "event_description":"An else condition was reached",
                    "effect_description":"this should happen next"
                }
            ]
        }
   ]

...
```
#### Console output
```markdown
MYENTITY       52    N-12   ✅  - An event occurred with node type 'true'
                                  Effect: this should happen next
MYENTITY       76    N-23   ✅  - An event occurred
                                  Effect: this should happen next
MYENTITY       76    N-34   🔴  - An else condition was reached
                                  Effect: this should happen next
```

### Assign an entity code to the top level JSON object
The entity code should be a unique string of any length to describe the entity (class, structure or enum). You can assign `entity_code` values of different length to separate entities. Note that the JSON object for a particular entity can be distributed across multiple JSON files. In this case you assign an identical `entity_code` value but each file would need a unique name to reside in the single `ClarityJSON` folder. 

#### Entire EntityLogService JSON object for the type `MyEntity`
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
                   "print_number":12,
                   "node_type":1,  
                   "event_description":"An event occurred with node type 'true'",
                   "effect_description":"this should happen next"
               }
           ]
       }
   ]
}
```


## Topics


### Related tutorials
- <doc:tutorials/Clarity/Add-print-statements>


