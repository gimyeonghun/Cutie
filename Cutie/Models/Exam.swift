//
//  Exam.swift
//  Cutie
//
//  Created by Brian Kim on 7/11/2024.
//

import Foundation
import SwiftData

@Model
final class Exam: Identifiable {
    var id = UUID()
    var title: String
    
    // MARK: Relationships
    @Relationship(deleteRule: .cascade, inverse: \Stem.exam)
    private var stems: [Stem]?
    
    init(title: String) {
        self.title = title
    }
}
