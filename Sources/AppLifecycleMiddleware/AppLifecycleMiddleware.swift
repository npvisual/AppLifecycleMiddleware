import Combine
import Foundation
import SwiftRex
import UIKit

// MARK: - ACTION

// sourcery: Prism
public enum AppLifecycleAction {
    case didEnterBackground
    case willEnterForeground
    case didBecomeActive
    case willBecomeInactive
    case didFinishLaunchingWithOptions([UIApplication.LaunchOptionsKey: Any]?)
    case willFinishLaunchingWithOptions([UIApplication.LaunchOptionsKey: Any]?)
}

// MARK: - STATE

public enum AppLifecycle: Equatable {
    case backgroundActive
    case backgroundInactive
    case foregroundActive
    case foregroundInactive
}

// MARK: - REDUCER

extension Reducer where ActionType == AppLifecycleAction, StateType == AppLifecycle {
    public static let lifecycle = Reducer { action, state in
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

        case (_, .didFinishLaunchingWithOptions): return state
        case (_, .willFinishLaunchingWithOptions): return state
        }
    }
}

// MARK: - PROTOCOL

// sourcery: AutoMockable, imports = ["Combine", "SwiftRex"]
public protocol NotificationPublisher {
    func receiveContext(
        getState: @escaping GetState<AppLifecycleMiddleware.StateType>,
        output: AnyActionHandler<AppLifecycleMiddleware.OutputActionType>
    ) -> AnyCancellable
}

// MARK: - MIDDLEWARE

public final class AppLifecycleMiddleware: Middleware {
    public typealias InputActionType = Never
    public typealias OutputActionType = AppLifecycleAction
    public typealias StateType = Void

    private let notificationPublisher: NotificationPublisher

    private var cancellable: AnyCancellable?

    public init(publisher: NotificationPublisher = NotificationCenter.default) {
        notificationPublisher = publisher
    }

    public func receiveContext(
        getState: @escaping GetState<StateType>,
        output: AnyActionHandler<OutputActionType>
    ) {
        cancellable = notificationPublisher.receiveContext(getState: getState, output: output)
    }

    public func handle(
        action _: InputActionType,
        from _: ActionSource,
        afterReducer _: inout AfterReducer
    ) {}
}

extension NotificationCenter: NotificationPublisher {
    public func receiveContext(
        getState _: @escaping GetState<AppLifecycleMiddleware.StateType>,
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
