//
//  StemEditor.swift
//  Cutie
//
//  Created by Brian Kim on 7/11/2024.
//

import SwiftUI

struct StemEditor: View {
    @State private var stem = Stem()
    @State private var userInput = ""
    
    var body: some View {
        HSplitView {
            VStack(alignment: .leading) {
                TextEditor(text: $userInput)
                    .font(.system(size: 14))
                    .frame(width: 400)
                    .padding(4)
                Button("Process") {
                    var question = Question()
                    question.options = insertOptions()
                    stem.questions.append(question)
                }
            }
            ScrollView {
                Form {
                    ForEach(stem.questions) { question in
                        Section {
                            HStack(alignment: .top) {
                                Button {
                                    if let index = stem.questions.firstIndex(of: question) {
                                        stem.questions.remove(at: index)
                                    }
                                } label: {
                                    Label("Remove", systemImage: "minus")
                                        .labelStyle(.iconOnly)
                                        .buttonStyle(.bordered)
                                        .buttonBorderShape(.circle)
                                }
                                .disabled(stem.questions.count == 1)
                                QuestionEditor(question: question)
                            }
                        }
                    }
                    .formStyle(.columns)
                    .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                    .toolbar {
                        ToolbarItem {
                            Button(action: addQuestion) {
                                Label("Add Item", systemImage: "plus")
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private func addQuestion() {
        stem.questions.append(.init())
    }
    
    private func insertOptions() -> [Question.Option] {
        var possibleOptions: [String] = []
        
        let lines = userInput.split(separator: "\n")
        lines.forEach { line in
            if let capture = line.firstMatch(of: /[A-Z]\. ([\w ]+)/) {
                possibleOptions.append(String(capture.output.1))
            }
        }
        return possibleOptions.map { Question.Option(text: $0) }
    }
}
