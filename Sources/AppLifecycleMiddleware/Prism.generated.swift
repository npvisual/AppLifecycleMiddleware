// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all
extension AppLifecycleAction {
    public var didEnterBackground: Void? {
        get {
            guard case .didEnterBackground = self else { return nil }
            return ()
        }
    }

    public var isDidEnterBackground: Bool {
        self.didEnterBackground != nil
    }

    public var willEnterForeground: Void? {
        get {
            guard case .willEnterForeground = self else { return nil }
            return ()
        }
    }

    public var isWillEnterForeground: Bool {
        self.willEnterForeground != nil
    }

    public var didBecomeActive: Void? {
        get {
            guard case .didBecomeActive = self else { return nil }
            return ()
        }
    }

    public var isDidBecomeActive: Bool {
        self.didBecomeActive != nil
    }

    public var willBecomeInactive: Void? {
        get {
            guard case .willBecomeInactive = self else { return nil }
            return ()
        }
    }

    public var isWillBecomeInactive: Bool {
        self.willBecomeInactive != nil
    }

    public var didFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey: Any]?? {
        get {
            guard case let .didFinishLaunchingWithOptions(associatedValue0) = self else { return nil }
            return (associatedValue0)
        }
        set {
            guard case .didFinishLaunchingWithOptions = self, let newValue = newValue else { return }
            self = .didFinishLaunchingWithOptions(newValue)
        }
    }

    public var isDidFinishLaunchingWithOptions: Bool {
        self.didFinishLaunchingWithOptions != nil
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
        self.willFinishLaunchingWithOptions != nil
    }

}
