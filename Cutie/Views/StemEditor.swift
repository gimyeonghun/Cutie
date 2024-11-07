//
//  StemEditor.swift
//  Cutie
//
//  Created by Brian Kim on 7/11/2024.
//

import SwiftUI
import SwiftData
import VisionKit
import Vision

struct StemEditor: View {
    var stem: Stem
    //    @State private var stem = Stem()
    //    @State var stemInfo = Stem.Info()
    
    //
    @State private var showProcessStem: Bool = false
    @State private var showAddImages: Bool = false
    //
    //    @State private var selectedImage: NSImage? = nil
    //
    
    @State private var stemTitle = ""
    @State private var userInput = ""
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack {
            processView
                .frame(width: 400)
            Divider()
                .overlay(alignment: .center) {
                    Button {
                        let newQuestion = Question()
                        modelContext.insert(newQuestion)
                        newQuestion.options = insertOptions()
                        newQuestion.stem = stem
                    } label: {
                        Label("Process", systemImage: "arrowshape.right")
                    }
                    .labelStyle(.iconOnly)
                    .controlSize(.large)
                    .padding()
                }
            questionView
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    
                } label: {
                    Label("Add Stem Info", systemImage: "info.square")
                }
                Button {
                    showAddImages.toggle()
                } label: {
                    Label("Add Image", systemImage: "photo.badge.plus.fill")
                }
                Button(action: addQuestion) {
                    Label("Add Item", systemImage: "plus.square.on.square")
                }
            }
        }
    }
    
    var processView: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button {
                    showProcessStem.toggle()
                } label: {
                    Label("Recognise Text from Image", systemImage: "apple.image.playground")
                }
                .controlSize(.extraLarge)
                .padding(.top, 4)
                Spacer()
            }
            TextEditor(text: $userInput)
                .font(.system(size: 14))
                .padding(.horizontal, 4)
        }
        .padding(4)
    }
    
    var questionView: some View {
        ScrollView {
            Form {
                TextField("Title", text: $stemTitle)
                    .onAppear {
                        stemTitle = stem.title
                    }
                    .onChange(of: stemTitle) {
                        stem.title = stemTitle
                    }
                QuestionDetail(for: stem)
            }
            .formStyle(.columns)
        }
    }
    
    private func recogniseText(from nsImage: NSImage) {
        guard let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }
        
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        
        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        
        
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        // Process the recognized strings.
        userInput = recognizedStrings.joined(separator: "\n")
    }
    
    private func addQuestion() {
        let newQuestion = Question()
        modelContext.insert(newQuestion)
        newQuestion.stem = stem
    }
    
    private func insertOptions() -> [QuestionOption] {
        var possibleOptions: [String] = []
        
        let lines = userInput.split(separator: "\n")
        lines.forEach { line in
            if let capture = line.firstMatch(of: /[A-Z]\. ([\w ]+)/) {
                possibleOptions.append(String(capture.output.1))
            }
        }
        return possibleOptions.map { QuestionOption(text: $0) }
    }
}

private struct QuestionDetail: View {
    @Environment(\.modelContext) private var modelContext
    let stem: Stem
    @Query(sort:\Question.dateCreated) private var questions: [Question]
    
    init(for stem: Stem) {
        let id = stem.id
        let predicate = #Predicate<Question> { question in
            question.stem?.id == id
        }
        self.stem = stem
        _questions = Query(filter: predicate, sort:\.dateCreated)
    }
    
    var body: some View {
        ForEach(questions) { question in
            Section {
                HStack(alignment: .top) {
                    Button {
                        modelContext.delete(question)
                    } label: {
                        Label("Remove", systemImage: "minus")
                            .labelStyle(.iconOnly)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.circle)
                    }
                    .disabled(stem.questions?.count == 1)
                    QuestionEditor(question: question)
                }
            }
        }
    }
}
//        HSplitView {
//            ScrollView {
//                Form {
//                    StemInfoEditor(stemInfo: stemInfo)
//                    ScrollView(.horizontal) {
//                        HStack {
//                            ForEach(stem.images) { image in
//                                if let data = try? Data(contentsOf: image),
//                                   let nsImage = NSImage(data: data) {
//                                    Image(nsImage: nsImage)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 300, height: 300)
//                                }
//                            }
//                        }
//                    }
//                .padding()
//            }
//        }

//        .fileImporter(isPresented: $showAddImages, allowedContentTypes: [.image]) { result in
//            switch result {
//            case .success(let fileURL):
//                stem.images.append(fileURL)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
////        .fileImporter(isPresented: $showProcessStem, allowedContentTypes: [.image]) { result in
////            switch result {
////            case .success(let fileURL):
////                if let data = try? Data(contentsOf: fileURL),
////                   let nsImage = NSImage(data: data) {
////                    recogniseText(from: nsImage)
////                } else {
////                    print("Error loading image")
////                }
////            case .failure(let error):
////                print(error.localizedDescription)
////            }
////        }
//    }
//    

//}

//#Preview {
//    StemEditor()
//}
