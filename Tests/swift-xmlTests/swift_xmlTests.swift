import XCTest
@testable import swift_xml

final class swift_xmlTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_xml().text, "Hello, World!")
        let node = parse(xmlString: "<html><body><h1>hello</h1><img src=\"img.jpg\" /></body></html>")

        XCTAssertEqual("html", node.name)
    }

    func testParseTag() {
        let xml = "<u:node attr1=\"a1\" attr2=\"a2\" />"
        let node = parseTag(text: xml)
        XCTAssertEqual("node", node.name)
        XCTAssertEqual("u", node.namespace)
        XCTAssertEqual("attr1", node.attributes![0].name)
        XCTAssertEqual("a1", node.attributes![0].value)
        XCTAssertEqual("attr2", node.attributes![1].name)
        XCTAssertEqual("a2", node.attributes![1].value)
    }

    static var allTests = [
      ("testExample", testExample),
      ("testParseTag", testParseTag),
    ]
}
