//
//  QuestionEditor.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import SwiftUI
import SwiftData

struct QuestionEditor: View {
    @Environment(\.modelContext) private var modelContext
    
    var question: Question
    
    @State private var promptText: String = ""
    @State private var questionPicker: AnswerType = .multiple
    @State private var specialityPicker: Speciality = .oralMed
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Prompt", text: $promptText, axis: .vertical)
                .lineLimit(2...)
                .onSubmit {
                    question.prompt = promptText
                }
            Picker("Speciality", selection: $specialityPicker) {
                ForEach(Speciality.allCases) { speciality in
                    Text(speciality.label)
                        .tag(speciality)
                }
            }
            .onChange(of: specialityPicker) {
                question.rawSpeciality = specialityPicker.rawValue
            }
            Picker("Question Type", selection: $questionPicker) {
                ForEach(AnswerType.allCases) { type in
                    Text(type.label)
                        .tag(type)
                }
            }
            .onChange(of: questionPicker) {
                question.rawAnswerType = questionPicker.rawValue
            }
            if question.rawAnswerType == 0 {
                PrescriptionDetails(for: question)
            } else {
                OptionsDetail(for: question)
            }
            Button(action: addOption) {
                Label("New Option", systemImage: "plus")
            }
            .onAppear {
                promptText = question.prompt
                specialityPicker = Speciality(rawValue: question.rawSpeciality)!
                questionPicker = AnswerType(rawValue: question.rawAnswerType)!
            }
        }
    }
    
    private func addOption() {
        if question.rawAnswerType == 0 {
            let newPrescription = QuestionPrescription()
            modelContext.insert(newPrescription)
            newPrescription.parent = question
        } else {
            let newOption = QuestionOption()
            modelContext.insert(newOption)
            newOption.parent = question
        }
    }
}

#Preview {
    @Previewable @State var question = Question()
    NavigationStack {
        QuestionEditor(question: question)
    }
}
