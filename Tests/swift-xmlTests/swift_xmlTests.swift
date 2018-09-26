import XCTest
@testable import SwiftXml

final class swift_xmlTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_xml().text, "Hello, World!")
    }

    func testXmlDocument() {
        let xml = "<?xml version=\"1.0\"?>" +
"<root xmlns=\"urn:schemas-upnp-org:device-1-0\">" +
"  <specVersion>" +
"  <major>1</major>" +
"  <minor>0</minor>" +
"  </specVersion>" +
"  <device>" +
"  <deviceType>urn:schemas-upnp-org:device:DimmableLight:1</deviceType>" +
"  <friendlyName>UPnP Sample Dimmable Light ver.1</friendlyName>" +
"  <manufacturer>Testers</manufacturer>" +
"  <manufacturerURL>www.example.com</manufacturerURL>" +
"  <modelDescription>UPnP Test Device</modelDescription>" +
"  <modelName>UPnP Test Device</modelName>" +
"  <modelNumber>1</modelNumber>" +
"  <modelURL>www.example.com</modelURL>" +
"  <serialNumber>12345678</serialNumber>" +
"  <UDN>e399855c-7ecb-1fff-8000-000000000000</UDN>" +
"  <serviceList>" +
"    <service>" +
"    <serviceType>urn:schemas-upnp-org:service:SwitchPower:1</serviceType>" +
"    <serviceId>urn:upnp-org:serviceId:SwitchPower.1</serviceId>" +
"    <SCPDURL>/e399855c-7ecb-1fff-8000-000000000000/urn:schemas-upnp-org:service:SwitchPower:1/scpd.xml</SCPDURL>" +
"    <controlURL>/e399855c-7ecb-1fff-8000-000000000000/urn:schemas-upnp-org:service:SwitchPower:1/control.xml</controlURL>" +
"    <eventSubURL>/e399855c-7ecb-1fff-8000-000000000000/urn:schemas-upnp-org:service:SwitchPower:1/event.xml</eventSubURL>" +
"    </service>" +
"    <service>" +
"    <serviceType>urn:schemas-upnp-org:service:Dimming:1</serviceType>" +
"    <serviceId>urn:upnp-org:serviceId:Dimming.1</serviceId>" +
"    <SCPDURL>/e399855c-7ecb-1fff-8000-000000000000/urn:schemas-upnp-org:service:Dimming:1/scpd.xml</SCPDURL>" +
"    <controlURL>/e399855c-7ecb-1fff-8000-000000000000/urn:schemas-upnp-org:service:Dimming:1/control.xml</controlURL>" +
"    <eventSubURL>/e399855c-7ecb-1fff-8000-000000000000/urn:schemas-upnp-org:service:Dimming:1/event.xml</eventSubURL>" +
"    </service>" +
"  </serviceList>" +
"  </device>" +
"</root>"
        let document = parseXml(xmlString: xml)
        XCTAssertEqual(document.dtd!.name, "xml")
        XCTAssertEqual(document.rootElement!.name, "root")

        guard let root = document.rootElement else {
            XCTAssert(false)
            return
        }

        XCTAssertEqual(root.attributes![0].name, "xmlns")
        XCTAssertEqual(root.attributes![0].value, "urn:schemas-upnp-org:device-1-0")

        XCTAssertEqual(root.getAttribute(name: "xmlns")!.value, "urn:schemas-upnp-org:device-1-0")

        XCTAssertEqual(root.elements![0].name, "specVersion")
        XCTAssertEqual(root.elements![1].name, "device")

        let elements = root.elements![1].elements!
        for element in elements {
            print("\(element.name!) - \(element.firstText?.text ?? "nil")")
        }

        print("\(document.description)")
    }

    func testHtml() {
        let document = parseXml(xmlString: "<html><body><h1>hello</h1><img src=\"img.jpg\" /></body></html>")
        XCTAssertEqual("html", document.rootElement!.name)
    }

    func testParseTag() {
        let xml = "<u:node attr1=\"a1\" attr2=\"a2\" />"
        let node = parseTag(text: unwrapTag(text: xml))
        XCTAssertEqual("node", node.name)
        XCTAssertEqual("u", node.namespace)
        XCTAssertEqual("attr1", node.attributes![0].name)
        XCTAssertEqual("a1", node.attributes![0].value)
        XCTAssertEqual("attr2", node.attributes![1].name)
        XCTAssertEqual("a2", node.attributes![1].value)
    }

    static var allTests = [
      ("testExample", testExample),
      ("testXmlDocument", testXmlDocument),
      ("testHtml", testHtml),
      ("testParseTag", testParseTag),
    ]
}
