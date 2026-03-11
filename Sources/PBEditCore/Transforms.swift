import Foundation

public enum Transform {
    case trim
    case upper
    case lower
    case replace(pattern: String, replacement: String)
}

public func apply(_ transform: Transform, to text: String) throws -> String {
    switch transform {
    case .trim:
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    case .upper:
        return text.uppercased()
    case .lower:
        return text.lowercased()
    case .replace(let pattern, let replacement):
        let regex = try NSRegularExpression(pattern: pattern)
        let range = NSRange(text.startIndex..., in: text)
        return regex.stringByReplacingMatches(in: text, range: range, withTemplate: replacement)
    }
}
