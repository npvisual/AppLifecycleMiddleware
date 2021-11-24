// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif



import Combine
import SwiftRex

open class NotificationPublisherMock: NotificationPublisher {
    //MARK: - start

    open var startStateOutputCallsCount = 0
    open var startStateOutputCalled: Bool {
        return startStateOutputCallsCount > 0
    }
    open var startStateOutputReceivedArguments: (state: GetState<AppLifecycleMiddleware.StateType>, output: AnyActionHandler<AppLifecycleMiddleware.OutputActionType>)?
    open var startStateOutputReturnValue: AnyCancellable!
    open var startStateOutputClosure: ((@escaping GetState<AppLifecycleMiddleware.StateType>, AnyActionHandler<AppLifecycleMiddleware.OutputActionType>) -> AnyCancellable)?

    open func start(state: @escaping GetState<AppLifecycleMiddleware.StateType>, output: AnyActionHandler<AppLifecycleMiddleware.OutputActionType>    ) -> AnyCancellable {
        startStateOutputCallsCount += 1
        startStateOutputReceivedArguments = (state: state, output: output)
        return startStateOutputClosure.map({ $0(state, output) }) ?? startStateOutputReturnValue
    }

}
