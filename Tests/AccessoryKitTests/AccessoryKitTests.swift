import XCTest
@testable import AccessoryKit

final class AccessoryKitTests: XCTestCase {
    
    func testInit() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let view = KeyboardAccessoryView()
        XCTAssert(view != nil)
    }

    static var allTests = [
        ("testInit", testInit),
    ]
}
