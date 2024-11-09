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
    
    @State private var examEditor: Exam? = nil
    @State private var showExamEditor: Bool = false
    
    @State private var path: NavigationPath? = nil
    @State private var detail: DetailPath? = nil
    
    @State private var searchText: String = ""
    @State private var searchTokens: [Speciality] = []
    
    
    var body: some View {
        NavigationSplitView {
            Section {
                List(selection: $path) {
                    ForEach(exams) { exam in
                        NavigationLink(value: NavigationPath.exam(exam)) {
                            Text(exam.title)
                        }
                        .swipeActions {
                            Button {
                                examEditor = exam
                            } label: {
                                Label("Rename", systemImage: "pencil")
                                    .tint(.blue)
                            }
                        }
                    }
                }
            }
            .toolbar {
                Button {
                    showExamEditor.toggle()
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
                case .isSearching:
                    SearchDetails(searchText: $searchText, searchTokens: $searchTokens, path: $detail)
                case .none:
                    ContentUnavailableView("No Exam Selected", systemImage: "film.stack.fill")
                }
            }
            .onChange(of: searchText) {
                path = searchText.isEmpty ? nil : .isSearching
            }
            .onChange(of: searchTokens) {
                path = searchTokens.isEmpty ? nil : .isSearching
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
        .sheet(item: $examEditor) { exam in
            ExamEditor(exam: exam)
        }
        .sheet(isPresented: $showExamEditor) {
            ExamEditor(exam: nil)
        }
        .searchable(text: $searchText, tokens: $searchTokens, suggestedTokens: .constant(Speciality.allCases), placement: .sidebar, prompt: "Questions") { token in
            switch token {
            case .oralMed: Text("Oral Medicine")
            case .perio: Text("Periodontics")
            case .endo: Text("Endodontics")
            case .pros: Text("Prosthodontics")
            case .ortho: Text("Orthodontics")
            case .resto: Text("Restorative Dentistry")
            case .surgery: Text("Oral Surgery")
            case .pain: Text("Pain Management")
            case .medicalEmergency: Text("Medical Emergency")
            }
        }
    }
}

#Preview {
    ContentView()
        .previewEnvironment()
}
