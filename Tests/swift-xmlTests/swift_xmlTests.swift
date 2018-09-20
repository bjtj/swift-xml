import XCTest
@testable import swift_xml

final class swift_xmlTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_xml().text, "Hello, World!")
        parse(xmlString: "<html><body><h1>hello</h1><img src=\"img.jpg\" /></body></html>")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
