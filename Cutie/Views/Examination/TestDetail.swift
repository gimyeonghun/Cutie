//
//  TestDetail.swift
//  Cutie
//
//  Created by Brian Kim on 9/11/2024.
//

import SwiftUI
import SwiftData

struct TestDetail: View {
    @Query(sort: \Exam.title) private var exams: [Exam]
    @Binding var selection: DetailPath?
    var body: some View {
        List(selection: $selection) {
            Section("Specialities") {
                ForEach(Speciality.allCases) { speciality in
                    NavigationLink(value: DetailPath.quiz(speciality)) {
                        Text(speciality.label)
                    }
                }
            }
            Section("Exams") {
                ForEach(exams) { exam in
                    NavigationLink(value: DetailPath.exam(exam)) {
                        Text(exam.title)
                    }
                }
            }
        }
    }
}
