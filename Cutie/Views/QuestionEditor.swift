//
//  QuestionEditor.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import SwiftUI

struct QuestionEditor: View {
    @State var question: Question
    
    var body: some View {
        Form {
            TextField("Prompt", text: $question.prompt, axis: .vertical)
                .lineLimit(2...)
            ForEach(question.options) { option in
                HStack {
                    Button {
                        if let index = question.options.firstIndex(of: option) {
                            question.options.remove(at: index)
                        }
                    } label: {
                        Label("Remove", systemImage: "minus")
                            .labelStyle(.iconOnly)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                    }
                    .disabled(question.options.count == 1)
                    MultipleChoiceOption(option: option)
                }
            }
            Button(action: addOption) {
                Label("New Option", systemImage: "plus")
            }
        }
    }
    
    private func addOption() {
        question.options.append(Question.Option())
    }
}

struct MultipleChoiceOption: View {
    @State var option: Question.Option
    var body : some View {
        HStack {
            Toggle("Correct", isOn: $option.isCorrect)
            TextField("Question", text: $option.text)
            TextField("Value", value: $option.value, format: .number)
                .frame(width: 50)
        }
        .onChange(of: option.isCorrect) {
            option.value = 0
        }
        .labelsHidden()
    }
}

#Preview {
    @Previewable @State var question = Question()
    NavigationStack {
        QuestionEditor(question: question)
    }
}
