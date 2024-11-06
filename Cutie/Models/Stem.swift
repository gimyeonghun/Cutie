//
//  Stem.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import Foundation

struct Stem {
    var info: Info?
    var questions: [Question]
    
    struct Info {
        var background: String
        var complaint: String
        var complaintHistory: String
        var dentalHistory: String
        var medicalHistory: String
        var extraOral: String
        var intraOral: String
        var additional: String?
    }
    
    init() {
        self.info = nil
        self.questions = []
    }
}
