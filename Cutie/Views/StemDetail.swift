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
    
    @Environment(\.modelContext) private var modelContext
    
    init(for exam: Exam, selection: Binding<DetailPath?>) {
        let id = exam.id
        let predicate = #Predicate<Stem> { stem in
            stem.exam?.id == id
        }
        self.exam = exam
        _stems = Query(filter: predicate, sort:\.title)
        _selection = selection
    }
    
    var body: some View {
        ZStack {
            List(selection: $selection) {
                ForEach(stems) { stem in
                    NavigationLink(value: DetailPath.stem(stem)) {
                        Text(stem.title)
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
                modelContext.insert(newStem)
                newStem.exam = exam
            } label: {
                Label("Add Exam", systemImage: "rectangle.stack.badge.plus")
            }
        }
        .frame(minWidth: 180)
    }
}
