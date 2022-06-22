# ``Clarity/ClarityActivator/isClientInDebugMode)``

## Release 1. documention
Setting `isClientInDebugMode` as the argument to `inPrintMode` will disable Clarity print statements when the client application is in RELEASE mode. If printing Clarity logs is required in RELEASE mode simply pass `true`. Conversely if disabling Clarity print statements is required in DEBUG mode simply pass `false`.

Client application DEBUG mode status must be accessed using the `ClarityActivator` computed var `isClientInDebugMode` and NOT via the `DEBUG` macro nor calling `_isDebugAssertConfiguration()` directly within the framework in order to provide the correct value for the client application.

Setting `isClientInDebugMode` as the argument to `inPrintMode` functions as described only when using the Clarity project source code and the client application within the same Workspace during development. In all other cases it is currently impossible for a framework to detect the build configuration of a client and therefore necessary to set  `inPrintMode` manually to either `true` or `false` as required. For maximum efficiency ensure that Clarity remains embedded and that `inPrintMode` is set manually to `false` when archiving for release.

The closure calls `_isDebugAssertConfiguration()` –  this function must be called from within the client to return the correct value for the client application.

The `isClientInDebugMode` constant is lazily set when first accessed on assignment to the parameter  `inPrintMode` of the ClarityActivator initialiser by the client application.

When accessed by the Clarity framework test target the constant will return the DEBUG build mode state of the framework test target. Evaluating the build mode state of the test target is necessary for the correct operation of certain unit tests including testing the operation of ` verifyClarityJSONDirectory(forBundle:)` .


The functionality of this constant will only work as intended if Clarity is installed as an **embedded framework**.

