
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
    
    @State private var showNavigator: Bool = false
    @State private var showReport: Bool = false
    
    @State private var progress: Set<QuestionContainer> = []
    
    let exam: Exam?
    let speciality: Speciality?
    
    init(exam: Exam) {
        let id = exam.id
        
        let predicate = #Predicate<Question> { question in
            if let stem = question.stem {
                return stem.exam?.id == id
            } else {
                return false
            }
        }
        
        self.exam = exam
        self.speciality = nil
        _questions = Query(filter: predicate)
    }
    
    init(speciality: Speciality) {
        let rawSpec = speciality.rawValue
        
        let predicate = #Predicate<Question> { question in
            question.rawSpeciality == rawSpec
        }
        self.speciality = speciality
        self.exam = nil
        _questions = Query(filter: predicate)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let currentQuestion,
               let stem = currentQuestion.stem {
                Text("Question \(currentIndex + 1)")
                    .font(.largeTitle)
                    .padding()
                ExamScreen(stem: stem, index: currentIndex, question: currentQuestion, progress: $progress)
                    .id(currentQuestion.id)
            } else {
                ContentUnavailableView("Nothing to Study", systemImage: "faceid")
            }
        }
        .sheet(isPresented: $showReport) {
            ExamReport(questions: Array(progress), currentIndex: $currentIndex)
        }
        .onAppear {
            currentQuestion = questions[0]
        }
        .onChange(of: currentIndex) {
            currentQuestion = questions[currentIndex]
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    showNavigator.toggle()
                } label: {
                    Label("Exam Navigator", systemImage: "square.grid.3x3.fill")
                }
                .popover(isPresented: $showNavigator) {
                    if let exam {
                        ExamNavigator(exam, index: $currentIndex)
                    } else if let speciality {
                        ExamNavigator(speciality, index: $currentIndex)
                    } else {
                        EmptyView()
                    }
                }
                Button {
                    showReport.toggle()
                } label: {
                    Label("Show Report", systemImage: "printer.filled.and.paper")
                }
                Button {
                    if currentIndex != 0 {
                        currentIndex -= 1
                    }
                } label: {
                    Label("Previous}", systemImage: "chevron.left")
                }
                .disabled(currentIndex == 0)
                Button {
                    if currentIndex != questions.count - 1 {
                        currentIndex += 1
                    }
                } label: {
                    Label("Next", systemImage: "chevron.right")
                }
                .disabled(currentIndex == questions.count - 1)
            }
        }
    }
}

struct QuestionContainer: Identifiable, Hashable {
    var id: UUID = UUID()
    var number: Int
    var status: QuestionStatus
}
