//
//  QuestionCapture.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import Foundation
import RegexBuilder

enum RegularExpression {
    static let option = Regex {
        // Examples
        // A. Clinical gingival health.
        // • D. Stage I.
        // 1. Grade B. °2
        ". "
        Capture {
            OneOrMore(.word)
        }
    }
    
    static func match(_ text: String, with pattern: some RegexComponent) -> [String] {
        guard let match = text.firstMatch(of: pattern) else {
            return []
        }
        return match.output as? [String] ?? []
    }
}

