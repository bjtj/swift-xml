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
}

public class XmlNode {
    var parent: XmlNode?
    var type: XmlNodeType?
    var children: [XmlNode]?
    var namespace: String?
    var name: String?
    var value: String?
    var text: String?
    var attributes: [XmlAttribute]?

    public var description: String {
        return name!
    }

    init(type: XmlNodeType) {
        self.type = type
    }
    
    var elements: [XmlElement]? {
        get {
            guard let children = children else {
                return nil
            }
            return children.compactMap { $0.type == .element ? $0 as? XmlElement : nil }
        }
    }
    var firstText: XmlText? {
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
    var isRoot: Bool {
        get {
            return parent == nil
        }
    }
    
    func hasAttribute(name: String) -> Bool {
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

    func getAttribute(name: String) -> XmlAttribute? {
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

    func getElement(name: String) -> XmlElement? {
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
    
    func appendChild(node: XmlNode) {
        node.parent = self
        if children == nil {
            self.children = [XmlNode]()
        }
        self.children!.append(node)
    }
}

public class XmlElement: XmlNode {
    public init(namespace: String? = nil, name: String?, attributes: [XmlAttribute]? = nil) {
        super.init(type: .element)
        self.namespace = namespace
        self.name = name
        self.attributes = attributes
    }
}

public class XmlText: XmlNode {
    public init(text: String) {
        super.init(type: .text)
        self.text = text
    }
}

public class XmlAttribute: XmlNode {
    override public var description: String {
        return "\(name!): \(value!)"
    }
    public init(name: String, value: String = "") {
        super.init(type: .attribute)
        self.name = name
        self.value = value
    }
}

public class XmlDTD: XmlNode {
    public init(name: String, attributes: [XmlAttribute]?) {
        super.init(type: .dtd)
        self.name = name
        self.attributes = attributes
    }
}

struct swift_xml {
    var text = "Hello, World!"
}

