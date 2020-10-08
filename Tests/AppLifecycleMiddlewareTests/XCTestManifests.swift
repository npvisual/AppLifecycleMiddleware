import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(AppLifecycleMiddlewareTests.allTests),
        ]
    }
#endif
