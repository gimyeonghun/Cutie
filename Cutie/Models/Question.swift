//
//  Question.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Question: Identifiable, Equatable {
    var id = UUID()
    var prompt: String
    var textbox: String
    var rawAnswerType: Int
    var rawSpeciality: Int
    
    var dateCreated: Date
    
    // MARK: Relationships
    var stem: Stem?
    
    @Relationship(deleteRule: .cascade, inverse: \QuestionOption.parent)
    var options: [QuestionOption]?
    
    @Relationship(deleteRule: .cascade, inverse: \QuestionPrescription.parent)
    var prescription: QuestionPrescription?
    
    init() {
        self.prompt = ""
        self.textbox = ""
        self.rawAnswerType = AnswerType.multiple.rawValue
        self.rawSpeciality = Speciality.oralMed.rawValue
        self.dateCreated = Date()
    }
}

@Model
final class QuestionOption: Identifiable, Equatable {
    var id = UUID()
    var text: String
    var value: Float
    var isCorrect: Bool
    
    var dateCreated: Date = Date()
    
    // MARK: Relationship
    var parent: Question?
    
    init() {
        self.text = ""
        self.value = 0
        self.isCorrect = false
    }
    
    init(text: String) {
        self.text = text
        self.value = 0
        self.isCorrect = false
    }
}

@Model
final class QuestionPrescription: Identifiable, Equatable {
    var id = UUID()
    
    var name: String
    var dosage: Int
    var dispense: Int
    var interval: Int
    var maximum: Int
    
    // MARK: Relationship
    var parent: Question?
    
    init() {
        self.name = ""
        self.dosage = 0
        self.dispense = 0
        self.interval = 0
        self.maximum = 0
    }
}


enum AnswerType: Int, Identifiable, CaseIterable, Codable {
    case text, single, multiple
    
    var id: Int { rawValue }
    
    var label: String {
        switch self {
        case .text: return "Prescription"
        case .single: return "Single Answer"
        case .multiple: return "Multiple Answers"
        }
    }
}

enum Speciality: Int, Identifiable, CaseIterable, Codable {
    case oralMed, perio, endo, pros, ortho, resto, surgery, pain, medicalEmergency
    
    var id: Int { rawValue }
    
    var label: String {
        switch self {
        case .oralMed: return "Oral Medicine"
        case .perio: return "Periodontics"
        case .endo: return "Endodontics"
        case .pros: return "Prosthodontics"
        case .ortho: return "Orthdontics"
        case .resto: return "Restorative Dentistry"
        case .surgery: return "Oral Surgery"
        case .pain: return "Pain Management"
        case .medicalEmergency: return "Medical Emergency"
        }
    }
}
