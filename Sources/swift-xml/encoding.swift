import Foundation

public func escapeXml(text: String) -> String {
    return text.replacingOccurrences(of: "&", with: "&amp;")
      .replacingOccurrences(of: "<", with: "&gt;")
      .replacingOccurrences(of: ">", with: "&lt;")
}

public func unescapeXml(text: String) -> String {
    return text.replacingOccurrences(of: "&gt;", with: "<")
      .replacingOccurrences(of: "&lt;", with: ">")
      .replacingOccurrences(of: "&amp;", with: "&")
}
