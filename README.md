![](Resources/clarity-logocr2.png)

![Swift](https://img.shields.io/badge/Swift-5-orange)<img src="https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-333333.svg" alt="Supported Platforms: iOS, macOS, tvOS, watchOS" />[![License: MIT](https://img.shields.io/badge/License-MIT-darkgrey.svg)](https://opensource.org/licenses/MIT)[![PayPal](https://img.shields.io/badge/paypal-donate-blue.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=9ZGWNK5FEZFF6&source=url)

**Clarity** is a logging framework that prints log data referenced from JSON to the console and displays the output using semantic formatting.  

This site contains the full framework documentation for contributors to its development. For the **DocC** documentation of the public API for the use of Clarity see [Documentation](https://realint.org/clarity/licence/)  and [Tutorials](https://realint.org/clarity/licence/) .

## Overview


Clarity assumes three main ‘nodes’ of interest in an application control flow: function call points, the resolution of conditional statements and the reporting of specific values including errors. Clarity print statements are designed to be placed at such node points in the client application source code.

All message data relating to each print statement is placed entirely in associated JSON files referenced by a unique number (print number). This enables the printing of an unlimited amount of information to the console with negligible impact on the source code.

The customisable formatting of console log output is designed to emphasise nodes of interest in a clear narrative of the control flow. The output includes symbol strings that relate to the functionality and purpose of the code such that it is human readable and understandable at first sight.

Customisable settings enable the isolation of specific nodes and referenced data.

The minimal API consists of two overload analogues of the Swift print function –  `print(_:functionName:settings:)` and `print(_:values:settings:)` these functions reference associated JSON data via the print number passed to the first unlabelled parameter.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/donate?hosted_button_id=2TUDLD6PMKUDN)

## License

Clarity is released under the MIT license. [See LICENSE](https://realint.org/clarity/licence/) for details.

Copyright (c) 2021-2022 Lawrence Heyfron https://realint.org/
