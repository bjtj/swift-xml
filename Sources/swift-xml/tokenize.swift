
public enum TokenType {
    case atomTag
    case startTag
    case endTag
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
                var nodeType = TokenType.startTag
                if str.last == "/" {
                    nodeType = .atomTag
                    // str = String(str[str.startIndex..<str.index(str.endIndex, offsetBy: -1)])
                } else if str.first == "/" {
                    nodeType = .endTag
                    // str = String(str[str.index(str.startIndex, offsetBy: 1)..<str.endIndex])
                }         
                tokens.append(Token(type: nodeType, text: str))
                str = ""
                continue
            }

            str.append(char)
        }
        return tokens
    }
}
