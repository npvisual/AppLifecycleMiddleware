import Combine
import Foundation
import SwiftRex
import UIKit

// MARK: - ACTION

// sourcery: Prism
public enum AppLifecycleAction {
    case start
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
    public static let lifecycle = Reducer.reduce { action, state in
        switch (state, action) {
        case (_, .start):
            return

        case (.backgroundActive, .didEnterBackground),
             (.backgroundInactive, .didEnterBackground):
            return
        case (.foregroundActive, .didEnterBackground):
            state = .backgroundActive
        case (.foregroundInactive, .didEnterBackground):
            state = .backgroundInactive

        case (.backgroundActive, .willEnterForeground):
            state = .foregroundActive
        case (.backgroundInactive, .willEnterForeground):
            state = .foregroundInactive
        case (.foregroundActive, .willEnterForeground),
             (.foregroundInactive, .willEnterForeground):
            return

        case (.backgroundActive, .didBecomeActive):
            return
        case (.backgroundInactive, .didBecomeActive):
            state = .backgroundActive
        case (.foregroundActive, .didBecomeActive):
            return
        case (.foregroundInactive, .didBecomeActive):
            state = .foregroundActive

        case (.backgroundActive, .willBecomeInactive):
            state = .backgroundInactive
        case (.backgroundInactive, .willBecomeInactive):
            return
        case (.foregroundActive, .willBecomeInactive):
            state = .foregroundInactive
        case (.foregroundInactive, .willBecomeInactive):
            return

        case (_, .didFinishLaunchingWithOptions),
             (_, .willFinishLaunchingWithOptions):
            return
        }
    }
}

// MARK: - PROTOCOL

// sourcery: AutoMockable, imports = ["Combine", "SwiftRex"]
public protocol NotificationPublisher {
    func start(
        state: @escaping GetState<AppLifecycleMiddleware.StateType>,
        output: AnyActionHandler<AppLifecycleMiddleware.OutputActionType>
    ) -> AnyCancellable
}

// MARK: - MIDDLEWARE

public final class AppLifecycleMiddleware: MiddlewareProtocol {
    public typealias InputActionType = AppLifecycleAction
    public typealias OutputActionType = AppLifecycleAction
    public typealias StateType = Void

    private let notificationPublisher: NotificationPublisher

    private var cancellable: AnyCancellable?

    public init(publisher: NotificationPublisher = NotificationCenter.default) {
        notificationPublisher = publisher
    }

    public func handle(action: AppLifecycleAction, from dispatcher: ActionSource, state: @escaping GetState<Void>) -> IO<AppLifecycleAction> {
        guard case .start = action else { return .identity }

        return IO { [weak self] output in
            guard let self = self else { return }
            self.cancellable = self.notificationPublisher.start(state: state, output: output)
        }
    }
}

extension NotificationCenter: NotificationPublisher {
    public func start(
        state _: @escaping GetState<AppLifecycleMiddleware.StateType>,
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
