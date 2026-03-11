import Testing
@testable import PBEditCore

@Suite("Transform Tests")
struct TransformTests {

    // MARK: - Trim Transform

    @Test("Trim removes leading and trailing whitespace")
    func trimWhitespace() throws {
        let input = "  hello world  "
        let result = try apply(.trim, to: input)
        #expect(result == "hello world")
    }

    @Test("Trim removes newlines")
    func trimNewlines() throws {
        let input = "\n\nhello\n\n"
        let result = try apply(.trim, to: input)
        #expect(result == "hello")
    }

    @Test("Trim handles mixed whitespace")
    func trimMixedWhitespace() throws {
        let input = " \t\n hello \n\t "
        let result = try apply(.trim, to: input)
        #expect(result == "hello")
    }

    @Test("Trim preserves internal whitespace")
    func trimPreservesInternal() throws {
        let input = "  hello   world  "
        let result = try apply(.trim, to: input)
        #expect(result == "hello   world")
    }

    @Test("Trim handles empty string")
    func trimEmptyString() throws {
        let input = ""
        let result = try apply(.trim, to: input)
        #expect(result == "")
    }

    @Test("Trim handles whitespace-only string")
    func trimWhitespaceOnly() throws {
        let input = "   \n\t  "
        let result = try apply(.trim, to: input)
        #expect(result == "")
    }

    // MARK: - Upper Transform

    @Test("Upper converts lowercase to uppercase")
    func upperLowercase() throws {
        let input = "hello world"
        let result = try apply(.upper, to: input)
        #expect(result == "HELLO WORLD")
    }

    @Test("Upper handles mixed case")
    func upperMixedCase() throws {
        let input = "HeLLo WoRLd"
        let result = try apply(.upper, to: input)
        #expect(result == "HELLO WORLD")
    }

    @Test("Upper preserves numbers and symbols")
    func upperPreservesNonLetters() throws {
        let input = "hello123!@#"
        let result = try apply(.upper, to: input)
        #expect(result == "HELLO123!@#")
    }

    @Test("Upper handles unicode")
    func upperUnicode() throws {
        let input = "café"
        let result = try apply(.upper, to: input)
        #expect(result == "CAFÉ")
    }

    // MARK: - Lower Transform

    @Test("Lower converts uppercase to lowercase")
    func lowerUppercase() throws {
        let input = "HELLO WORLD"
        let result = try apply(.lower, to: input)
        #expect(result == "hello world")
    }

    @Test("Lower handles mixed case")
    func lowerMixedCase() throws {
        let input = "HeLLo WoRLd"
        let result = try apply(.lower, to: input)
        #expect(result == "hello world")
    }

    @Test("Lower preserves numbers and symbols")
    func lowerPreservesNonLetters() throws {
        let input = "HELLO123!@#"
        let result = try apply(.lower, to: input)
        #expect(result == "hello123!@#")
    }

    // MARK: - Replace Transform

    @Test("Replace simple pattern")
    func replaceSimple() throws {
        let input = "hello world"
        let result = try apply(.replace(pattern: "world", replacement: "there"), to: input)
        #expect(result == "hello there")
    }

    @Test("Replace all occurrences")
    func replaceAll() throws {
        let input = "hello hello hello"
        let result = try apply(.replace(pattern: "hello", replacement: "hi"), to: input)
        #expect(result == "hi hi hi")
    }

    @Test("Replace with regex pattern")
    func replaceRegex() throws {
        let input = "abc123def456"
        let result = try apply(.replace(pattern: "[0-9]+", replacement: "X"), to: input)
        #expect(result == "abcXdefX")
    }

    @Test("Replace with capture groups")
    func replaceCaptureGroups() throws {
        let input = "John Smith"
        let result = try apply(.replace(pattern: "(\\w+) (\\w+)", replacement: "$2, $1"), to: input)
        #expect(result == "Smith, John")
    }

    @Test("Replace with empty replacement")
    func replaceWithEmpty() throws {
        let input = "hello123world"
        let result = try apply(.replace(pattern: "[0-9]+", replacement: ""), to: input)
        #expect(result == "helloworld")
    }

    @Test("Replace no match leaves string unchanged")
    func replaceNoMatch() throws {
        let input = "hello world"
        let result = try apply(.replace(pattern: "xyz", replacement: "abc"), to: input)
        #expect(result == "hello world")
    }

    @Test("Replace throws on invalid regex")
    func replaceInvalidRegex() throws {
        let input = "hello"
        #expect(throws: Error.self) {
            _ = try apply(.replace(pattern: "[invalid", replacement: "x"), to: input)
        }
    }
}
