# AppLifecycleMiddleware

This is a [SwiftRex Middleware](https://github.com/SwiftRex/SwiftRex#middleware) that specializes in transforming application lifecycle notification to Redux actions.

The original code was pulled from [@luizmb](https://github.com/luizmb)'s code and extracted to avoid copying it over and over. In addition the code was refactored to allow to mock some of the notifications provided by the [`NotificationCenter`](https://developer.apple.com/documentation/foundation/notificationcenter) (via dependency injection).

## Current features

We currently support the following notifications : 

- [`didBecomeActiveNotification`](https://developer.apple.com/documentation/uikit/uiapplication/1622953-didbecomeactivenotification)
- [`willResignActiveNotification`](https://developer.apple.com/documentation/uikit/uiapplication/1622973-willresignactivenotification)
- [`didEnterBackgroundNotification`](https://developer.apple.com/documentation/uikit/uiapplication/1623071-didenterbackgroundnotification)
- [`willEnterForegroundNotification`](https://developer.apple.com/documentation/uikit/uiapplication/1622944-willenterforegroundnotification)

## Future enhancements

Looking at supporting those additional notifications : 

- [`willTerminateNotification`](https://developer.apple.com/documentation/uikit/uiapplication/1623061-willterminatenotification)
