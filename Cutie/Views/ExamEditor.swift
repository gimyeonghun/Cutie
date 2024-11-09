//
//  ExamEditor.swift
//  Cutie
//
//  Created by Brian Kim on 9/11/2024.
//

import SwiftUI

struct ExamEditor: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    let exam: Exam?
    @State private var title: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                    .onAppear {
                        title = exam?.title ?? "New Exam"
                    }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save(exam: exam)
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func save(exam: Exam?) {
        if let exam {
            exam.title = title
        } else {
            let newExam = Exam(title: title)
            modelContext.insert(newExam)
        }
    }
}
