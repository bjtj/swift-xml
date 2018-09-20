public enum XmlNodeType {
    case comment
    case element
    case text
}

public struct KeyValuePair {
    var name: String
    var value: String
}

public class XmlNode {
    var parent: XmlNode?
    var type: XmlNodeType?
    var children = [XmlNode]()
    var namespace: String?
    var name: String?
    var text: String?
    var attributes = [KeyValuePair]()

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
        children.append(node)
    }
}

public class XmlElement: XmlNode {
    public init() {
        super.init(type: .element)
    }
}

public class XmlText: XmlNode {
}

struct swift_xml {
    var text = "Hello, World!"
}

public func parse(xmlString: String) {
    let tokenizer = Tokenizer()
    let tokens = tokenizer.tokenize(text: xmlString)
    var cursor: XmlNode?
    for token in tokens {
        print("\(token.type): '\(token.text)'")
        switch token.type {
        case .startTag:
            let node = XmlNode(type: .element)
            if cursor != nil {
                cursor!.appendChild(node: node)
            }
            cursor = node
        case .atomTag:
            let node = XmlNode(type: .element)
            if cursor == nil {
                cursor = node
            } else {
                cursor!.appendChild(node: node)
            }
        case .endTag:
            cursor = cursor!.parent
        case .text:
            let node = XmlNode(type: .text)
            if cursor == nil {
                cursor = node
            } else {
                cursor!.appendChild(node: node)
            }
        }
    }
}
