// Generated using Sourcery 1.0.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

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

}
