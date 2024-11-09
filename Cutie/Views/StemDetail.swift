//
//  StemDetail.swift
//  Cutie
//
//  Created by Brian Kim on 7/11/2024.
//

import SwiftUI
import SwiftData

struct StemDetail: View {
    let exam: Exam
    @Binding var selection: DetailPath?
    
    @Query(sort: \Stem.title) private var stems: [Stem]
    @Query private var questions: [Question]
    
    @Environment(\.modelContext) private var modelContext
    
    init(for exam: Exam, selection: Binding<DetailPath?>) {
        let examId = exam.id
        let stemPredicate = #Predicate<Stem> { stem in
            stem.exam?.id == examId
        }
        self.exam = exam
        _stems = Query(filter: stemPredicate, sort: [SortDescriptor(\Stem.title, comparator: .localizedStandard)])
        
        let qPredicate = #Predicate<Question> { question in
            if let stem = question.stem {
                return stem.exam?.id == examId
            } else {
                return false
            }
        }
        _questions = Query(filter: qPredicate)
        
        _selection = selection
    }
    
    var body: some View {
        ZStack {
            List(selection: $selection) {
                ForEach(stems) { stem in
                    NavigationLink(value: DetailPath.stem(stem)) {
                        Text(stem.title)
                            .swipeActions {
                                Button(role: .destructive) {
                                    deleteStem(stem)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .opacity(stems.isEmpty ? 0 : 1)
            ContentUnavailableView("No Questions", systemImage: "rectangle.stack")
            .opacity(stems.isEmpty ? 1 : 0)
        }
        .toolbar {
            Button {
                let newStem = Stem()
                newStem.title = "Question \(questions.count + 1)"
                modelContext.insert(newStem)
                newStem.exam = exam
            } label: {
                Label("Add Exam", systemImage: "rectangle.stack.badge.plus")
            }
        }
        .frame(minWidth: 180)
    }
    
    private func deleteStem(_ stem: Stem) {
        modelContext.delete(stem)
    }
}
