public enum XmlNodeType {
    case dtd
    case comment
    case element
    case attribute
    case text
}

// public struct KeyValuePair {
//     var name: String
//     var value: String
// }

public class XmlNode {
    var parent: XmlNode?
    var type: XmlNodeType?
    var children = [XmlNode]()
    var namespace: String?
    var name: String?
    var value: String?
    var text: String?
    // var attributes = [KeyValuePair]()
    var attributes: [XmlAttribute]?

    public var description: String {
        return name!
    }

    init(type: XmlNodeType) {
        self.type = type
    }
    
    var elements: [XmlNode] {
        get {
            return children.filter { $0.type == .element }
        }
    }
    var firstText: String? {
        guard children.count > 0 else {
            return nil
        }
        if children[0].type == .text {
            return children[0].text
        }
        return nil
    }
    var isRoot: Bool {
        get {
            return parent == nil
        }
    }
    func appendChild(node: XmlNode) {
        node.parent = self
        children.append(node)
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
    public init() {
        super.init(type: .dtd)
    }
}

struct swift_xml {
    var text = "Hello, World!"
}

public func parse(xmlString: String) -> XmlNode {
    let tokenizer = Tokenizer()
    let tokens = tokenizer.tokenize(text: xmlString)
    var cursor: XmlNode?
    for token in tokens {
        switch token.type {
        case .tag:
            if isStartTag(text: token.text) {
                let node = parseTag(text: token.text)
                if cursor != nil {
                    cursor!.appendChild(node: node)
                }
                cursor = node
            } else if isEndTag(text: token.text) {
                if cursor!.parent == nil {
                    return cursor!
                }
                cursor = cursor!.parent
            } else if isAtomTag(text: token.text) {
                let node = XmlNode(type: .element)
                if cursor == nil {
                    cursor = node
                } else {
                    cursor!.appendChild(node: node)
                }                
            }
        case .text:
            let node = XmlNode(type: .text)
            if cursor == nil {
                cursor = node
            } else {
                cursor!.appendChild(node: node)
            }
        }
    }
    return cursor!
}

public func parseTag(text: String) -> XmlElement {
    let start = text.index(text.startIndex, offsetBy: 1)
    let end = text.index(text.endIndex, offsetBy: (text[text.index(text.endIndex, offsetBy: -2)] == "/" ? -2 : -1))
    let sub = text[start..<end]
    var tokens = [String]()
    var escape = false
    var inQuote = false
    var str = ""
    for (_, char) in sub.enumerated() {
        if escape == true {
            switch char {
            case "n":
                str.append("\n")
            case "r":
                str.append("\r")
            case "t":
                str.append("\t")
            default:
                str.append(char)
            }
            escape = false
        } else if inQuote == true {
            switch char {
            case "\\":
                escape = true
            case "\"":
                tokens.append(str)
                str = ""
                inQuote = false
            default:
                str.append(char)
            }
        } else if inQuote == false {
            switch char {
            case "\"":
                inQuote = true
            case " ", "\t", "\r", "\n":
                if str.isEmpty == false {
                    tokens.append(str)
                    str = ""
                }
            case "=":
                if str.isEmpty == false {
                    tokens.append(str)
                    str = ""
                }
                tokens.append(String(char))
            default:
                str.append(char)
            }
        }
    }

    if str.isEmpty == false {
        tokens.append(str)
    }


    var attributes = [XmlAttribute]()
    var name = ""
    var expectValue = false
    for (_, token) in tokens[1..<tokens.count].enumerated() {
        if name.isEmpty {
            name = token
        } else if token == "=" {
            expectValue = true
        } else if expectValue == true {
            let attr = XmlAttribute(name: name, value: token)
            expectValue = false
            attributes.append(attr)
            name = ""
        } else {
            let attr = XmlAttribute(name: name)
            attributes.append(attr)
            name = token
        }
    }
    if name.isEmpty == false {
        let attr = XmlAttribute(name: name)
        attributes.append(attr)
    }

    let sep = tokens[0].split(separator: ":")
    if sep.count > 1 {
        return XmlElement(namespace: String(sep[0]), name: String(sep[1]), attributes: attributes)
    } else {
        return XmlElement(name: String(sep[0]), attributes: attributes)
    }
}

