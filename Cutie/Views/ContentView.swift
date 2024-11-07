//
//  ContentView.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Exam.title) private var exams: [Exam]
    
    @State private var showExamEditor: Bool = false
    
    @State private var path: NavigationPath? = nil
    @State private var detail: DetailPath? = nil
    
    var body: some View {
        NavigationSplitView {
            List(selection: $path) {
                ForEach(exams) { exam in
                    NavigationLink(value: NavigationPath.exam(exam)) {
                        Text(exam.title)
                    }
                }
            }
            .toolbar {
                Button {
                    let newExam = Exam(title: "New Exam")
                    modelContext.insert(newExam)
                    //                    showExamEditor.toggle()
                } label: {
                    Label("Add Exam", systemImage: "rectangle.stack.badge.plus")
                }
            }
            .frame(minWidth: 180)
        } content: {
            Group {
                switch path {
                case .exam(let exam):
                    StemDetail(for: exam, selection: $detail)
                case .none:
                    ContentUnavailableView("No Exam Selected", systemImage: "film.stack.fill")
                }
            }
        } detail: {
            Group {
                switch detail {
                case .stem(let stem):
                    StemEditor(stem: stem)
                case .none:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .previewEnvironment()
}
