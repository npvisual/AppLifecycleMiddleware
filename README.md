# AppLifecycleMiddleware

This is a [SwiftRex Middleware](https://github.com/SwiftRex/SwiftRex#middleware) that specializes in transforming application lifecycle notification to Redux actions.

The original code was pulled from [@luizmb](https://github.com/luizmb)'s code and extracted to avoid copying it over and over. In addition the code was refactored to allow to mock some of the notifications provided by the [`NotificationCenter`](https://developer.apple.com/documentation/foundation/notificationcenter)` (via dependency injection).
