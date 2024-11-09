//
//  SearchDetail.swift
//  Cutie
//
//  Created by Brian Kim on 9/11/2024.
//

import SwiftUI
import SwiftData

struct SearchDetails: View {
    @Query(sort: \Exam.title) private var exams: [Exam]
    
    @Binding var searchText: String
    @Binding var searchTokens: [Speciality]
    @Binding var path: DetailPath?
    
    @State private var count: Int = 0
    
    init(searchText: Binding<String>, searchTokens: Binding<[Speciality]>, path: Binding<DetailPath?>) {
        _searchText = searchText
        _searchTokens = searchTokens
        _path = path
    }
    
    var body: some View {
        ZStack {
            List(selection: $path) {
                Text("\(count) Results")
                ForEach(exams) { exam in
                    Section(exam.title) {
                        QuestionList(exam: exam, searchText: $searchText, searchTokens: $searchTokens, count: $count)
                    }
                }
            }
            .opacity(count == 0 ? 0 : 1)
            ContentUnavailableView.search
                .opacity(count == 0 ? 1 : 0)
        }
    }
}

private struct QuestionList: View {
    @Query(sort: \Question.dateCreated) private var questions: [Question]
    
    @Binding var searchText: String
    @Binding var searchTokens: [Speciality]
    @Binding var count: Int
    
    init(exam: Exam, searchText: Binding<String>, searchTokens: Binding<[Speciality]>, count: Binding<Int>) {
        let tokens = searchTokens.wrappedValue.map { $0.rawValue }
        let examId = exam.id
        
        let predicate = #Predicate<Question> { question in
            if let stem = question.stem {
                return stem.exam?.id == examId && tokens.contains(question.rawSpeciality)
            } else {
                return false
            }
        }
        
        _searchText = searchText
        _searchTokens = searchTokens
        _questions = Query(filter: predicate, sort: \Question.dateCreated)
        _count = count
    }
    
    var body: some View {
        ForEach(questions) { question in
            if let stem = question.stem {
                NavigationLink(value: DetailPath.stem(stem)) {
                    VStack(alignment: .leading) {
                        Text(stem.title)
                        Text(question.prompt)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }
            }
        }
        .onAppear {
            count = questions.count
        }
    }
}

