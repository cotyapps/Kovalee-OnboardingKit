import Foundation
import SwiftUI

func extractAllPatterns(from text: String) -> [String] {
	let pattern = "\\[(.*?)\\]"
	let regex = try? NSRegularExpression(pattern: pattern)
	let results = regex?.matches(in: text, range: NSRange(text.startIndex..., in: text))

	var matches = [String]()
	results?.forEach { match in
		if let range = Range(match.range(at: 1), in: text) {
			matches.append(String(text[range]))
		}
	}

	return matches
}

func replaceMatches(in text: String, using dictionary: [String: String]) -> String {
	var replacedText = text
	let patterns = extractAllPatterns(from: text)
	
	for pattern in patterns {
		if let replacement = dictionary[pattern] {
			replacedText = replacedText.replacingOccurrences(of: "[\(pattern)]", with: replacement)
		}
	}
	
	return replacedText
}

extension LocalizedStringKey {
	init(stringLiteral value: String, properties: [String: String]) {
		self.init(replaceMatches(in: value, using: properties))
	}
}
