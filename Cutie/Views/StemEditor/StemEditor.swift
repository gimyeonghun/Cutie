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
    
    @State private var showFilePicker: Bool = false
    
    @State private var showInfoSheet: Bool = false

    @State private var stemTitle = ""
    @State private var userInput = ""
    @State private var importType: ImportType = .attachment
    
    @Environment(\.modelContext) private var modelContext
    
    enum ImportType {
        case attachment
        case processImage
    }
    
    var body: some View {
        HStack {
            processView
                .frame(width: 300)
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
                    showInfoSheet.toggle()
                } label: {
                    Label("Add Stem Info", systemImage: "info.square")
                }
                Button {
                    importType = .attachment
                    showFilePicker.toggle()
                } label: {
                    Label("Add Image", systemImage: "photo.badge.plus.fill")
                }
                Button(action: addQuestion) {
                    Label("Add Item", systemImage: "plus.square.on.square")
                }
            }
        }
        .sheet(isPresented: $showInfoSheet) {
            StemInfoSheet(stem: stem)
        }
        .fileImporter(isPresented: $showFilePicker, allowedContentTypes: [.image]) { result in
            switch result {
            case .success(let fileURL):
                guard let data = try? Data(contentsOf: fileURL) else { return }
                
                guard importType == .processImage else {
                    let newFigure = Figure(data)
                    modelContext.insert(newFigure)
                    newFigure.stem = stem
                    return
                }
                
                if let nsImage = NSImage(data: data) {
                    recogniseText(from: nsImage)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    var processView: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button {
                    importType = .processImage
                    showFilePicker.toggle()
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
                .frame(width: 300)
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
                    .onSubmit {
                        stem.title = stemTitle
                    }
                    .id(stem.id)
                StemInfoEditor(for: stem)
                    .id(stem.id)
                StemFigures(for: stem)
                QuestionDetail(for: stem)
            }
            .formStyle(.columns)
            .safeAreaPadding(10)
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
            if let capture = line.firstMatch(of: /[A-Z]\. ([\w\d\.\- ]+)/) {
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

//                .padding()
//            }
//        }



////        }
//    }
//    

//}

//#Preview {
//    StemEditor()
//}
