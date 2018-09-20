
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
                tokens.append(Token(type: .text, text: str))
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


func isStartTag(text: String) -> Bool {
    return text.hasPrefix("</") == false && text.hasSuffix("/>") == false
}

func isEndTag(text: String) -> Bool {
    return text.hasPrefix("</")
}

func isAtomTag(text: String) -> Bool {
    return text.hasSuffix("/>")
}
