import XCTest
@testable import AppLifecycleMiddleware

final class AppLifecycleMiddlewareTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AppLifecycleMiddleware().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
