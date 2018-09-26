public enum XmlNodeType {
    case dtd
    case comment
    case element
    case attribute
    case text
}

public class XmlDocument {
    public var dtd: XmlDTD?
    public var rootElement: XmlElement?

    public var description: String {
        var str = ""
        if let dtd = dtd {
            str.append("\(dtd.description)\r\n")
        }
        if let rootElement = rootElement {
            str.append("\(rootElement.description)")
        }
        return str
    }

    public init() {
    }
}

public class XmlNode {
    public var parent: XmlNode?
    public var type: XmlNodeType?
    public var children: [XmlNode]?
    public var namespace: String?
    public var name: String?
    public var value: String?
    public var text: String?
    public var attributes: [XmlAttribute]?

    public var description: String {
        return name!
    }

    public init(type: XmlNodeType) {
        self.type = type
    }
    
    public var elements: [XmlElement]? {
        get {
            guard let children = children else {
                return nil
            }
            return children.compactMap { $0.type == .element ? $0 as? XmlElement : nil }
        }
    }
    public var firstText: XmlText? {
        guard let children = children else {
            return nil
        }
        guard children.count > 0 else {
            return nil
        }
        for node in children {
            if node.type == .text {
                return node as? XmlText
            }
        }
        return nil
    }
    public var isRoot: Bool {
        get {
            return parent == nil
        }
    }

    var attributesString: String {
        guard let attributes = attributes else {
            return ""
        }
        return attributes.map { $0.description }.joined(separator: " ")
    }
    
    public func hasAttribute(name: String) -> Bool {
        guard let attributes = attributes else {
            return false
        }
        for attribute in attributes {
            if attribute.name == name {
                return true
            }
        }
        return false
    }

    public func getAttribute(name: String) -> XmlAttribute? {
        guard let attributes = attributes else {
            return nil
        }
        for attribute in attributes {
            if attribute.name == name {
                return attribute
            }
        }
        return nil
    }

    public func getElement(name: String) -> XmlElement? {
        guard let elements = self.elements else {
            return nil
        }
        for element in elements {
            if element.name == name {
                return element
            }
        }
        return nil
    }
    
    public func appendChild(node: XmlNode) {
        node.parent = self
        if children == nil {
            self.children = [XmlNode]()
        }
        self.children!.append(node)
    }
}

public class XmlElement: XmlNode {
    override public var description: String {
        var str = "<\(tagName)"
        if attributes != nil && attributes!.isEmpty == false {
            str.append(" ")
            str.append(attributesString)
        }
        if children == nil || children!.isEmpty {
            str.append(" />")
            return str
        }
        str.append(">")
        for child in children! {
            str.append(child.description)
        }
        str.append("</\(tagName)>")
        return str
    }
    var tagName: String {
        if namespace != nil {
            return "\(namespace!):\(name!)"
        }
        return "\(name!)"
    }
    public init(namespace: String? = nil, name: String, attributes: [XmlAttribute]? = nil) {
        super.init(type: .element)
        self.namespace = namespace
        self.name = name
        self.attributes = attributes
    }
}

public class XmlText: XmlNode {
    override public var description: String {
        return escapeXml(text: text!)
    }
    public init(text: String) {
        super.init(type: .text)
        self.text = text
    }
}

public class XmlAttribute: XmlNode {
    override public var description: String {
        return "\(name!)=\"\(value!)\""
    }
    public init(name: String, value: String = "") {
        super.init(type: .attribute)
        self.name = name
        self.value = value
    }
}

public class XmlDTD: XmlNode {
    override public var description: String {
        if attributesString.isEmpty {
            return "<?\(name!) ?>"
        }
        return "<?\(name!) \(attributesString)?>"
    }
    public init(name: String = "xml", attributes: [XmlAttribute]? = nil) {
        super.init(type: .dtd)
        self.name = name
        self.attributes = attributes
    }
}

struct swift_xml {
    var text = "Hello, World!"
}

