//
//  ExamScreen.swift
//  Cutie
//
//  Created by Brian Kim on 9/11/2024.
//

import SwiftUI

struct ExamScreen: View {
    let stem: Stem
    let index: Int
    var question: Question
    @Binding var progress: Set<QuestionContainer>
    
    @State private var correctOptions: Set<QuestionOption> = []
    @State private var selectedOptions: Set<QuestionOption> = []
    
    @State private var answerStatus = QuestionStatus.noAnswer
    
    var body: some View {
        HStack(alignment: .top) {
            figures
            Divider()
            Form {
                info
                Text(question.prompt)
                    .padding(.vertical)
                switch question.rawAnswerType {
                case 0: Text("Write a Prescription")
                case 1, 2:
                    if let options = question.options {
                        ForEach(options) { option in
                            ExamOption(option: option, selection: $selectedOptions)
                        }
                        .onChange(of: selectedOptions) {
                            if selectedOptions == correctOptions {
                                answerStatus = .correct
                            } else if selectedOptions.isEmpty {
                                answerStatus = .noAnswer
                            } else if selectedOptions.isSubset(of: correctOptions) {
                                answerStatus = .partial
                            } else if selectedOptions.isSuperset(of: correctOptions) {
                                answerStatus = .incorrect
                            } else {
                                answerStatus = .incorrect
                            }
                            
                            if let questionContainer = progress.filter({ $0.number == index }).first {
                                progress.remove(questionContainer)
                            }
                            progress.insert(QuestionContainer(number: index, status: answerStatus))
                        }
                    }
                default: EmptyView()
                }
                Text(answerStatus.label)
                    .foregroundStyle(answerStatus.colour)
            }
            .padding(20)
        }
        .onAppear {
            if let options = question.options {
                print(question.prompt)
                print(options.filter({ $0.isCorrect }))
                correctOptions = Set(options.filter({ $0.isCorrect }))
            }
        }
    }
    
    var info: some View {
        Group {
            if let info = stem.info {
                TextField("Background", text: .constant(info.background), axis: .vertical)
                    .textFieldStyle(.plain)
                    .disabled(true)
                TextField("Complaint", text: .constant(info.complaint), axis: .vertical)
                    .textFieldStyle(.plain)
                    .disabled(true)
                TextField("Complaint History", text: .constant(info.complaintHistory), axis: .vertical)
                    .textFieldStyle(.plain)
                    .disabled(true)
                TextField("Dental History", text: .constant(info.dentalHistory), axis: .vertical)
                    .textFieldStyle(.plain)
                    .disabled(true)
                TextField("Medical History", text: .constant(info.medicalHistory), axis: .vertical)
                    .textFieldStyle(.plain)
                    .disabled(true)
                TextField("Extra Oral", text: .constant(info.extraOral), axis: .vertical)
                    .textFieldStyle(.plain)
                    .disabled(true)
                TextField("Intra Oral", text: .constant(info.intraOral), axis: .vertical)
                    .textFieldStyle(.plain)
                    .disabled(true)
                TextField("Additional", text: .constant(info.additional), axis: .vertical)
                    .textFieldStyle(.plain)
                    .disabled(true)
            }
        }
    }
    
    var figures: some View {
        Group {
            if let images = stem.images {
                ZStack {
                    ScrollView {
                        VStack {
                            ForEach(images) { image in
                                if let nsImage = NSImage(data: image.image) {
                                    Image(nsImage: nsImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 400)
                                }
                            }
                            .padding()
                        }
                    }
                    .opacity(images.count == 0 ? 0 : 1)
                    ContentUnavailableView("No Images", systemImage: "photo.stack")
                        .opacity(images.count == 0 ? 1 : 0)
                }
            } else {
                ContentUnavailableView("No Images", systemImage: "photo.stack")
            }
        }
    }
}

struct ExamOption: View {
    let option: QuestionOption
    @Binding var selection: Set<QuestionOption>
    @State private var isChecked: Bool = false
    
    var body: some View {
        Toggle(isOn: $isChecked) {
            Text(option.text)
        }
        .onChange(of: isChecked) {
            if isChecked {
                selection.insert(option)
            } else {
                selection.remove(option)
            }
        }
    }
}
