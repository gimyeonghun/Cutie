//
//  PrescriptionDetails.swift
//  Cutie
//
//  Created by Brian Kim on 7/11/2024.
//

import SwiftUI
import SwiftData

struct PrescriptionDetails: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \QuestionPrescription.name) private var prescriptions: [QuestionPrescription]
    
    let question: Question
    
    @State private var name: String = ""
    @State private var dosage: Int = 0
    @State private var dispense: Int = 0
    @State private var interval: Int = 0
    @State private var maximum: Int = 0
    
    init(for question: Question) {
        let id = question.id
        let predicate = #Predicate<QuestionPrescription> { script in
            script.parent?.id == id
        }
        _prescriptions = Query(filter: predicate, sort:\.name)
        self.question = question
    }
    
    var body: some View {
        Group {
            if let prescription = prescriptions.first {
                TextField("Name", text: $name)
                    .onChange(of: name) {
                        prescription.name = name
                    }
                TextField("Dosage", value: $dosage, format: .number)
                    .onChange(of: name) {
                        prescription.dosage = dosage
                    }
                TextField("Dispense", value: $dispense, format: .number)
                    .onChange(of: dispense) {
                        prescription.dispense = dispense
                    }
                TextField("Interval", value: $interval, format: .number)
                    .onChange(of: interval) {
                        prescription.interval = interval
                    }
                TextField("Maximum", value: $maximum, format: .number)
                    .onChange(of: maximum) {
                        prescription.maximum = maximum
                    }
            }
        }
        .onAppear {
            name = prescriptions.first?.name ?? ""
            dosage = prescriptions.first?.dosage ?? 0
            dispense = prescriptions.first?.dispense ?? 0
            interval = prescriptions.first?.interval ?? 0
            maximum = prescriptions.first?.maximum ?? 0
        }
    }
}
