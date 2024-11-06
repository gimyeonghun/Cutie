//
//  Question.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import Foundation
import SwiftUI

struct Question: Identifiable, Equatable {
    var id = UUID()
    var prompt: String
    var textbox: String
    var answerType: AnswerType
    var speciality: Speciality
    var images: [Image]
    var options: [Option]
    
    init() {
        self.prompt = ""
        self.textbox = ""
        self.answerType = .multiple
        self.speciality = .oralMed
        self.images = []
        self.options = [Option()]
    }
    
    struct Option: Identifiable, Equatable {
        var id = UUID()
        var text: String
        var value: Int
        var isCorrect: Bool
        
        init() {
            self.text = ""
            self.value = 0
            self.isCorrect = false
        }
        
        init (text: String) {
            self.text = text
            self.value = 0
            self.isCorrect = false
        }
    }
    
    enum AnswerType {
        case text, single, multiple
    }
    
    enum Speciality {
        case oralMed, perio, endo, pros, ortho, resto, surgery, pain, medicalEmergency
    }
    
    
}
