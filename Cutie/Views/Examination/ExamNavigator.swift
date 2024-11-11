//
//  ExamNavigator.swift
//  Cutie
//
//  Created by Brian Kim on 9/11/2024.
//

import SwiftUI
import SwiftData

struct ExamNavigator: View {
    @Query private var questions: [Question]
    
    @Binding var newIndex: Int
    
    let columns = [GridItem](repeating: GridItem(.flexible()), count: 10)
    
    init(_ exam: Exam, index: Binding<Int>) {
        let id = exam.id
        
        let predicate = #Predicate<Question> { question in
            if let stem = question.stem {
                return stem.exam?.id == id
            } else {
                return false
            }
        }
        
        _questions = Query(filter: predicate)
        _newIndex = index
    }
    
    init(_ speciality: Speciality, index: Binding<Int>) {
        let rawSpeciality = speciality.rawValue
        
        let predicate = #Predicate<Question> { question in
            question.rawSpeciality == rawSpeciality
        }
        
        _questions = Query(filter: predicate)
        _newIndex = index
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(0..<questions.count, id:\.self) { index in
                    Button {
                        newIndex = index
                    } label: {
                        Text("\(index + 1)")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundStyle(.gray)
                            )
                        
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .frame(width: 450)
    }
}
