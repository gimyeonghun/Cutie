//
//  ExamReport.swift
//  Cutie
//
//  Created by Brian Kim on 9/11/2024.
//

import SwiftUI

struct ExamReport: View {
    let columns = [GridItem](repeating: GridItem(.flexible()), count: 3)
    
    @Environment(\.dismiss) private var dismiss
    
    var questions: [QuestionContainer]
    @Binding var currentIndex: Int
    
    var body: some View {
        NavigationStack {
            Form {
                LazyVGrid(columns: columns) {
                    ForEach(questions) { question in
                        HStack {
                            Button("Question \(question.number + 1)") {
                                currentIndex = question.number
                                dismiss()
                            }
                            .buttonStyle(.link)
                            .foregroundStyle(.primary)
                            .pointerStyle(.zoomIn)
                            QuestionStatusView(status: question.status)
                        }
                    }
                }
            }
            .padding()
            .frame(width: 400)
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    ControlGroup {
                        Button("\(questions.filter({ $0.status == .correct} ).count)") { }
                            .foregroundStyle(QuestionStatus.correct.colour)
                        Button("\(questions.filter({ $0.status == .incorrect} ).count)") { }
                            .foregroundStyle(QuestionStatus.incorrect.colour)
                        Button("\(questions.filter({ $0.status == .partial} ).count)") { }
                            .foregroundStyle(QuestionStatus.partial.colour)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct QuestionStatusView: View {
    let status: QuestionStatus
    
    var body: some View {
        Image(systemName: status.icon)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding()
            .frame(width: 24, height: 24)
            .background(status.colour)
            .mask(RoundedRectangle(cornerRadius: 6))
    }
}

enum QuestionStatus {
    case noAnswer, correct, incorrect, partial
    
    var icon: String {
        switch self {
        case .noAnswer: return "face.dashed"
        case .correct: return "checkmark"
        case .incorrect: return "xmark"
        case .partial: return "minus.forwardslash.plus"
        }
    }
    
    var colour: Color {
        switch self {
        case .noAnswer: return .gray
        case .correct: return .green
        case .incorrect: return .red
        case .partial: return .orange
        }
    }
    
    var label: String {
        switch self {
        case .noAnswer: return "Not Answered Yet"
        case .correct: return "Correct!"
        case .incorrect: return "Incorrect!"
        case .partial: return "Partially Correct"
        }
    }
}

