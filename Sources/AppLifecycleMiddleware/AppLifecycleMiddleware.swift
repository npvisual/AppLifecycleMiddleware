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
    case didFinishLaunchingWithOption([UIApplication.LaunchOptionsKey: Any]?)
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

        case (_, .willFinishLaunchingWithOptions): return state
        case (_, .didFinishLaunchingWithOption): return state
        }
    }
}

// MARK: - PROTOCOL

// sourcery: AutoMockable
public protocol NotificationPublisher {
    func receiveContext(
        getState: @escaping GetState<AppLifecycleMiddleware.StateType>,
        output: AnyActionHandler<AppLifecycleMiddleware.OutputActionType>
    ) -> AnyCancellable
}

public protocol AppDelegateActionable: UIApplicationDelegate {
    var output: AnyActionHandler<AppLifecycleAction>? { get set }
}

// MARK: - MIDDLEWARE

public final class AppLifecycleMiddleware: Middleware {
    public typealias InputActionType = Never
    public typealias OutputActionType = AppLifecycleAction
    public typealias StateType = Void

    private let notificationPublisher: NotificationPublisher
    private weak var appDelegate: AppDelegateActionable?

    private var cancellable: AnyCancellable?

    public init(
        publisher: NotificationPublisher = NotificationCenter.default,
        delegate: AppDelegateActionable? = nil
    ) {
        notificationPublisher = publisher
        appDelegate = delegate
    }

    public func receiveContext(
        getState: @escaping GetState<StateType>,
        output: AnyActionHandler<OutputActionType>
    ) {
        appDelegate?.output = output
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
        return Publishers.Merge5(
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
                .map { _ in AppLifecycleAction.willEnterForeground },
            notificationCenter
                .publisher(for: UIApplication.didFinishLaunchingNotification)
                .map { notification in
                    AppLifecycleAction.didFinishLaunchingWithOption(
                        notification.userInfo as? [UIApplication.LaunchOptionsKey: Any]
                    )
                }
        )
        .sink { action in
            output.dispatch(action)
        }
    }
}

public final class AppLifecycleMiddlewareDelegate: NSObject, AppDelegateActionable {
    public var output: AnyActionHandler<AppLifecycleAction>?

    public func application(
        _: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        output?.dispatch(.didFinishLaunchingWithOption(launchOptions))
        // TODO: should we use inject a closure to return the boolean
        return true
    }

    public func application(
        _: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        output?.dispatch(.willFinishLaunchingWithOptions(launchOptions))
        // TODO: should we use inject a closure to return the boolean
        return true
    }
}
