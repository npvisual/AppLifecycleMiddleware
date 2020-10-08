@testable import AppLifecycleMiddleware
import XCTest

final class AppLifecycleMiddlewareTests: XCTestCase {
    func testAppLifecycleActions() {
        let sut = AppLifecycleMiddleware()
        var getStateCount = 0
        var dispatchActionCount = 0

        sut.receiveContext(
            getState: { getStateCount += 1 },
            output: .init { _, _ in
                dispatchActionCount += 1
            }
        )

        //        XCTAssertEqual(AppLifecycleMiddleware().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testAppLifecycleActions),
    ]
}
