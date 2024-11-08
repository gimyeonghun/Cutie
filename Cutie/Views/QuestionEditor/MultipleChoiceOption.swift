//
//  MultipleChoiceOption.swift
//  Cutie
//
//  Created by Brian Kim on 7/11/2024.
//

import SwiftUI
import SwiftData

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
