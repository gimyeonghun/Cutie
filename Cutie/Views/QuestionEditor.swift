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
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Prompt", text: $promptText, axis: .vertical)
                .lineLimit(2...)
                .onChange(of: promptText) {
                    question.prompt = promptText
                }
            OptionsDetail(for: question)
            Button(action: addOption) {
                Label("New Option", systemImage: "plus")
            }
            .onAppear {
                promptText = question.prompt
            }
        }
    }
    
    private func addOption() {
        let newOption = QuestionOption()
        modelContext.insert(newOption)
        newOption.parent = question
    }
}

struct OptionsDetail: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \QuestionOption.dateCreated) private var options: [QuestionOption]
    
    let question: Question
    
    init(for question: Question) {
        let id = question.id
        let predicate = #Predicate<QuestionOption> { option in
            option.parent?.id == id
        }
        _options = Query(filter: predicate, sort:\.dateCreated)
        self.question = question
    }
    
    var body: some View {
        ForEach(options) { option in
            HStack {
                Button {
                    modelContext.delete(option)
                } label: {
                    Label("Remove", systemImage: "minus")
                        .labelStyle(.iconOnly)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.circle)
                }
                .disabled(question.options?.count == 1)
                MultipleChoiceOption(option: option)
            }
        }
    }
}

struct MultipleChoiceOption: View {
    var option: QuestionOption
    
    @State private var isCorrect: Bool = false
    @State private var text: String = ""
    @State private var value: Int = 0
    
    var body : some View {
        HStack {
            Toggle("Correct", isOn: $isCorrect)
                .onChange(of: isCorrect) {
                    value = 0
                    option.isCorrect = isCorrect
                }
            TextField("Question", text: $text)
                .onChange(of: text) {
                    option.text = text
                }
            TextField("Value", value: $value, format: .number)
                .onChange(of: value) {
                    option.value = value
                }
                .frame(width: 50)
        }
        .labelsHidden()
        .onAppear {
            isCorrect = option.isCorrect
            text = option.text
            value = option.value
        }
    }
}

#Preview {
    @Previewable @State var question = Question()
    NavigationStack {
        QuestionEditor(question: question)
    }
}
