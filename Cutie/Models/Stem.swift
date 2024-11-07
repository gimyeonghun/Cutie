//
//  Stem.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Stem: Identifiable {
    var id = UUID()
    var title: String
    
    @Attribute(.externalStorage) var images: [Data]
    
    // MARK: Relationships
    var exam: Exam?
    
    @Relationship(deleteRule: .cascade, inverse: \Question.stem)
    var questions: [Question]?
    
    @Relationship(deleteRule: .cascade, inverse: \StemInfo.stem)
    var info: StemInfo?
    
    init() {
        self.title = "Untitled Question"
        self.images = []
    }
}

@Model
final class StemInfo {
    var background: String
    var complaint: String
    var complaintHistory: String
    var dentalHistory: String
    var medicalHistory: String
    var extraOral: String
    var intraOral: String
    var additional: String
    
    // MARK: Relationships
    var stem: Stem?
    
    init() {
        self.background = ""
        self.complaint = ""
        self.complaintHistory = ""
        self.dentalHistory = ""
        self.medicalHistory = ""
        self.extraOral = ""
        self.intraOral = ""
        self.additional = ""
    }
}
