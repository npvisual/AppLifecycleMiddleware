// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

open class NotificationPublisherMock: NotificationPublisher {
    // MARK: - receiveContext

    open var receiveContextGetStateOutputCallsCount = 0
    open var receiveContextGetStateOutputCalled: Bool {
        receiveContextGetStateOutputCallsCount > 0
    }

    open var receiveContextGetStateOutputReceivedArguments: (getState: GetState<AppLifecycleMiddleware.StateType>, output: AnyActionHandler<AppLifecycleMiddleware.OutputActionType>)?
    open var receiveContextGetStateOutputReturnValue: AnyCancellable!
    open var receiveContextGetStateOutputClosure: ((@escaping GetState<AppLifecycleMiddleware.StateType>, AnyActionHandler<AppLifecycleMiddleware.OutputActionType>) -> AnyCancellable)?

    open func receiveContext(getState: @escaping GetState<AppLifecycleMiddleware.StateType>, output: AnyActionHandler<AppLifecycleMiddleware.OutputActionType>) -> AnyCancellable {
        receiveContextGetStateOutputCallsCount += 1
        receiveContextGetStateOutputReceivedArguments = (getState: getState, output: output)
        return receiveContextGetStateOutputClosure.map { $0(getState, output) } ?? receiveContextGetStateOutputReturnValue
    }
}
