public func parseXml(xmlString: String) -> XmlDocument {
    let tokenizer = Tokenizer()
    let tokens = tokenizer.tokenize(text: xmlString)
    var cursor: XmlNode?
    var firstElementFound = false
    let document = XmlDocument()
    for token in tokens {
        
        if firstElementFound == false {
            switch token.type {
            case  .tag:
                if isDtd(text: token.text) == true {
                    let dtd = parseDtd(text: unwrapDtd(text: token.text))
                    document.dtd = dtd
                    continue
                } else {
                    firstElementFound = true
                }
            case .text:
                if token.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    continue
                }
            }
        }
        
        switch token.type {
        case .tag:
            if isStartTag(text: token.text) {
                let node = parseTag(text: unwrapTag(text: token.text))
                if cursor != nil {
                    cursor!.appendChild(node: node)
                }
                cursor = node
            } else if isEndTag(text: token.text) {
                if cursor!.parent == nil {
                    document.rootElement = cursor as? XmlElement
                    return document
                }
                cursor = cursor!.parent
            } else if isAtomTag(text: token.text) {
                let node = parseTag(text: unwrapTag(text: token.text))
                if cursor == nil {
                    cursor = node
                } else {
                    cursor!.appendChild(node: node)
                }                
            }
        case .text:
            let node = XmlText(text: unescapeXml(text: token.text))
            if cursor == nil {
                cursor = node
            } else {
                cursor!.appendChild(node: node)
            }
        }
    }
    return document
}

public func parseDtd(text: String) -> XmlDTD {
    let elem = parseTag(text: text)
    return XmlDTD(name: elem.name!, attributes: elem.attributes!)
}

public func parseTag(text: String) -> XmlElement {
    let sub = text
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
