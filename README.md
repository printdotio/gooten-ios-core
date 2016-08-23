# Gooten Core iOS SDK

## Overview
Gooten Core is SDK with basic set of functionalities for dealing with Gooten platform, which allows you to manage orders for printing, manufacturing, and related resources within the Gooten cloud.

## Integration
Currently CocoaPods doesn't support embedded binaries, and frameworks written in Swift, so only way to integrate this framework is to follow next steps (applies to Swift and Objective C projects):

1. Download ```GootenCore.framework``` from here, and drag it to Xcode project
2. Select desired Target -> General -> scroll to the bottom
3. Add ```GootenCore.framework``` to ```Embedded binaries``` and ```Linked Frameworks and Libraries```
4. If project is written in Objective C, under Target -> Build Settings -> Embedded Content Contains Swift set to ```YES```

## Documentation
Gooten Core [documentation and user guide](https://github.com/printdotio/gooten-ios-core/blob/master/docs/gooten_core_sdk.md).
