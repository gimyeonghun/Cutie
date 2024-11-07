//
//  Stem.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import Foundation
import SwiftUI

struct Stem: Identifiable {
    var id = UUID()
    var title: String
    var info: Info?
    var questions: [Question]
    var images: [URL]
    
    struct Info {
        var background: String
        var complaint: String
        var complaintHistory: String
        var dentalHistory: String
        var medicalHistory: String
        var extraOral: String
        var intraOral: String
        var additional: String
        
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
    
    init() {
        self.title = "Untitled Question"
        self.info = nil
        self.questions = []
        self.images = []
    }
}
