//
//  OptionDetails.swift
//  Cutie
//
//  Created by Brian Kim on 7/11/2024.
//

import SwiftUI
import SwiftData

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
