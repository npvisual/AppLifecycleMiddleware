import Foundation
import Combine
import SwiftRex
import UIKit

public enum AppLifecycleAction {
    case didEnterBackground
    case willEnterForeground
    case didBecomeActive
    case willBecomeInactive
}

public enum AppLifecycle: Equatable {
    case backgroundActive
    case backgroundInactive
    case foregroundActive
    case foregroundInactive
}

extension Reducer where ActionType == AppLifecycleAction, StateType == AppLifecycle {
    static let lifecycle = Reducer { action, state in
        switch (state, action) {
        case (.backgroundActive, .didEnterBackground): return state
        case (.backgroundInactive, .didEnterBackground): return state
        case (.foregroundActive, .didEnterBackground): return .backgroundActive
        case (.foregroundInactive, .didEnterBackground): return .backgroundInactive

        case (.backgroundActive, .willEnterForeground): return .foregroundActive
        case (.backgroundInactive, .willEnterForeground): return .foregroundInactive
        case (.foregroundActive, .willEnterForeground): return state
        case (.foregroundInactive, .willEnterForeground): return state

        case (.backgroundActive, .didBecomeActive): return state
        case (.backgroundInactive, .didBecomeActive): return .backgroundActive
        case (.foregroundActive, .didBecomeActive): return state
        case (.foregroundInactive, .didBecomeActive): return .foregroundActive

        case (.backgroundActive, .willBecomeInactive): return .backgroundInactive
        case (.backgroundInactive, .willBecomeInactive): return state
        case (.foregroundActive, .willBecomeInactive): return .foregroundInactive
        case (.foregroundInactive, .willBecomeInactive): return state
        }
    }
}

// sourcery: AutoMockable
public protocol NotificationPublisher {
    func receiveContext(
        getState: @escaping GetState<AppLifecycleMiddleware.StateType>,
        output: AnyActionHandler<AppLifecycleMiddleware.OutputActionType>) -> AnyCancellable
}

// TODO: Later change to upcoming (0.8) EffectMiddleware
public final class AppLifecycleMiddleware: Middleware {
    public typealias InputActionType = Never
    public typealias OutputActionType = AppLifecycleAction
    public typealias StateType = Void

    private let notificationPublisher: NotificationPublisher
    
    private var cancellable: AnyCancellable?

    init(publisher: NotificationPublisher = NotificationCenter.default) {
        self.notificationPublisher = publisher
    }
    
    public func receiveContext(getState: @escaping GetState<StateType>, output: AnyActionHandler<OutputActionType>) {
        cancellable = notificationPublisher.receiveContext(getState: getState, output: output)
    }

    public func handle(action: InputActionType, from dispatcher: ActionSource, afterReducer: inout AfterReducer) {
    }
}

extension NotificationCenter: NotificationPublisher {
    public func receiveContext(
        getState: @escaping GetState<AppLifecycleMiddleware.StateType>,
        output: AnyActionHandler<AppLifecycleMiddleware.OutputActionType>
    ) -> AnyCancellable {
        let notificationCenter = NotificationCenter.default
        return Publishers.Merge4(
            notificationCenter
                .publisher(for: UIApplication.didBecomeActiveNotification)
                .map { _ in AppLifecycleAction.didBecomeActive },
            notificationCenter
                .publisher(for: UIApplication.willResignActiveNotification)
                .map { _ in AppLifecycleAction.willBecomeInactive },
            notificationCenter
                .publisher(for: UIApplication.didEnterBackgroundNotification)
                .map { _ in AppLifecycleAction.didEnterBackground },
            notificationCenter
                .publisher(for: UIApplication.willEnterForegroundNotification)
                .map { _ in AppLifecycleAction.willEnterForeground }
        )
        .sink { action in
            output.dispatch(action)
        }
    }
}
