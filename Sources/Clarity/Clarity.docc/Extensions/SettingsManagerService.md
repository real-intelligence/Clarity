# ``Clarity/SettingsManagerService``




## Overview

The `SettingsManagerService` struct matches the structure of the <doc:Settings> JSON exactly and is not currently used to service a struct that models the JSON differently. It embeds nested structs that represent arrays in the JSON data: ``IsolatedEntity`` and ``IsolatedFunction``.

This struct names its properties to have the same name as the keys in the <doc:Settings> JSON (unlike the other JSON service structs in the framework) and therefore avoids the requirement for [CodingKey](https://developer.apple.com/documentation/swift/codingkey) enums. The simplicity of the <doc:Settings> JSON structure allows the struct to take advantage of the [Codable](https://developer.apple.com/documentation/swift/codable) protocol automatic key generation feature.

All of its properties are declared as variable so that settings can be changed programmatically during the run of a client application – this feature is designed specifically for use during unit testing.





## Topics


### JSON Reference
- <doc:Settings>
