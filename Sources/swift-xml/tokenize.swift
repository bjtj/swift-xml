
public enum TokenType {
    case tag
    case text
}

public struct Token {
    var type: TokenType
    var text: String
}

public class Tokenizer {
    public func tokenize(text: String) -> [Token] {
        var tokens = [Token]()
        var str = ""
        var intag = false
        for (_, char) in text.enumerated() {
            if intag == false && char == "<" {
                intag = true
                if str.isEmpty == false {
                    tokens.append(Token(type: .text, text: str))
                }
                str = "<"
                continue
            }
            
            if intag == true && char == ">" {
                intag = false
                str.append(char)
                tokens.append(Token(type: .tag, text: str))
                str = ""
                continue
            }

            str.append(char)
        }
        return tokens
    }
}

func isDtd(text: String) -> Bool {
    return text.hasPrefix("<?") && text.hasSuffix("?>")
}

func isStartTag(text: String) -> Bool {
    return text.hasPrefix("</") == false && text.hasSuffix("/>") == false
}

func isEndTag(text: String) -> Bool {
    return text.hasPrefix("</")
}

func isAtomTag(text: String) -> Bool {
    return text.hasSuffix("/>")
}

func unwrapDtd(text: String) -> String {
    return String(text[text.index(text.startIndex, offsetBy: 2)..<text.index(text.endIndex, offsetBy: -2)])
}

func unwrapTag(text: String) -> String {
    let start = text.index(text.startIndex, offsetBy: 1)
    let end = text.index(text.endIndex, offsetBy: (text[text.index(text.endIndex, offsetBy: -2)] == "/" ? -2 : -1))
    return String(text[start..<end])
}
