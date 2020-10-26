// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all
public extension AppLifecycleAction {
    var didEnterBackground: Void? {
        guard case .didEnterBackground = self else { return nil }
        return ()
    }

    var isDidEnterBackground: Bool {
        didEnterBackground != nil
    }

    var willEnterForeground: Void? {
        guard case .willEnterForeground = self else { return nil }
        return ()
    }

    var isWillEnterForeground: Bool {
        willEnterForeground != nil
    }

    var didBecomeActive: Void? {
        guard case .didBecomeActive = self else { return nil }
        return ()
    }

    var isDidBecomeActive: Bool {
        didBecomeActive != nil
    }

    var willBecomeInactive: Void? {
        guard case .willBecomeInactive = self else { return nil }
        return ()
    }

    var isWillBecomeInactive: Bool {
        willBecomeInactive != nil
    }

    var didFinishLaunchingWithOption: [UIApplication.LaunchOptionsKey: Any]?? {
        get {
            guard case let .didFinishLaunchingWithOption(associatedValue0) = self else { return nil }
            return (associatedValue0)
        }
        set {
            guard case .didFinishLaunchingWithOption = self, let newValue = newValue else { return }
            self = .didFinishLaunchingWithOption(newValue)
        }
    }

    var isDidFinishLaunchingWithOption: Bool {
        didFinishLaunchingWithOption != nil
    }

    var willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?? {
        get {
            guard case let .willFinishLaunchingWithOptions(associatedValue0) = self else { return nil }
            return (associatedValue0)
        }
        set {
            guard case .willFinishLaunchingWithOptions = self, let newValue = newValue else { return }
            self = .willFinishLaunchingWithOptions(newValue)
        }
    }

    var isWillFinishLaunchingWithOptions: Bool {
        willFinishLaunchingWithOptions != nil
    }
}
