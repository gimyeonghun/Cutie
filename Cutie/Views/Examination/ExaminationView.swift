
//
//  ExaminationView.swift
//  Cutie
//
//  Created by Brian Kim on 9/11/2024.
//

import SwiftUI
import SwiftData

struct ExaminationView: View {
    @Query private var questions: [Question]
    
    @State private var currentQuestion: Question?
    @State private var currentIndex: Int = 0
    
    init(exam: Exam) {
        let id = exam.id
        
        let predicate = #Predicate<Question> { question in
            if let stem = question.stem {
                return stem.exam?.id == id
            } else {
                return false
            }
        }
        
        _questions = Query(filter: predicate)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let currentQuestion {
                ExamScreen(question: currentQuestion)
            } else {
                ContentUnavailableView("Nothing to Study", systemImage: "faceid")
            }
        }
        .onAppear {
            currentQuestion = questions[0]
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    
                } label: {
                    Label("Show Report", systemImage: "printer.filled.and.paper")
                }
                Button {
                    if currentIndex != 0 {
                        currentIndex -= 1
                        currentQuestion = questions[currentIndex]
                    }
                } label: {
                    Label("Previous}", systemImage: "chevron.left")
                }
                .disabled(currentIndex == 0)
                Button {
                    if currentIndex != questions.count - 1 {
                        currentIndex += 1
                        currentQuestion = questions[currentIndex]
                    }
                } label: {
                    Label("Next", systemImage: "chevron.right")
                }
                .disabled(currentIndex == questions.count)
            }
        }
    }
}

struct ExamScreen: View {
    var question: Question
    var body: some View {
        Text(question.prompt)
//        switch question.rawAnswerType {
//        case 0:
//        case 1: Text("render")
//        case 2: Text("render")
//        default: EmptyView()
//        }
    }
}
