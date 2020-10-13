// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all
extension AppLifecycleAction {
    public var didEnterBackground: Void? {
        guard case .didEnterBackground = self else { return nil }
        return ()
    }

    public var isDidEnterBackground: Bool {
        didEnterBackground != nil
    }

    public var willEnterForeground: Void? {
        guard case .willEnterForeground = self else { return nil }
        return ()
    }

    public var isWillEnterForeground: Bool {
        willEnterForeground != nil
    }

    public var didBecomeActive: Void? {
        guard case .didBecomeActive = self else { return nil }
        return ()
    }

    public var isDidBecomeActive: Bool {
        didBecomeActive != nil
    }

    public var willBecomeInactive: Void? {
        guard case .willBecomeInactive = self else { return nil }
        return ()
    }

    public var isWillBecomeInactive: Bool {
        willBecomeInactive != nil
    }

    public var didFinishLaunchingWithOption: [UIApplication.LaunchOptionsKey: Any]?? {
        get {
            guard case let .didFinishLaunchingWithOption(associatedValue0) = self else { return nil }
            return (associatedValue0)
        }
        set {
            guard case .didFinishLaunchingWithOption = self, let newValue = newValue else { return }
            self = .didFinishLaunchingWithOption(newValue)
        }
    }

    public var isDidFinishLaunchingWithOption: Bool {
        didFinishLaunchingWithOption != nil
    }

    public var willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?? {
        get {
            guard case let .willFinishLaunchingWithOptions(associatedValue0) = self else { return nil }
            return (associatedValue0)
        }
        set {
            guard case .willFinishLaunchingWithOptions = self, let newValue = newValue else { return }
            self = .willFinishLaunchingWithOptions(newValue)
        }
    }

    public var isWillFinishLaunchingWithOptions: Bool {
        willFinishLaunchingWithOptions != nil
    }
}
