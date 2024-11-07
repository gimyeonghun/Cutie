//
//  StemEditor.swift
//  Cutie
//
//  Created by Brian Kim on 7/11/2024.
//

import SwiftUI
import VisionKit
import Vision

struct StemEditor: View {
    @State private var stem = Stem()
    @State var stemInfo = Stem.Info()
    @State private var userInput = ""
    
    @State private var showProcessStem: Bool = false
    @State private var showAddImages: Bool = false
    
    @State private var selectedImage: NSImage? = nil
    
    var body: some View {
        HSplitView {
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
                HStack {
                    Spacer()
                    Button{
                        var question = Question()
                        question.options = insertOptions()
                        stem.questions.append(question)
                    } label: {
                        Label("Process", systemImage: "arrow.right.circle")
                    }
                    .controlSize(.large)
                }
            }
            .frame(width: 400)
            ScrollView {
                Form {
                    StemInfo(stemInfo: stemInfo)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(stem.images) { image in
                                if let data = try? Data(contentsOf: image),
                                   let nsImage = NSImage(data: data) {
                                    Image(nsImage: nsImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 300)
                                }
                            }
                        }
                    }
                    ForEach(stem.questions) { question in
                        Section {
                            HStack(alignment: .top) {
                                Button {
                                    if let index = stem.questions.firstIndex(of: question) {
                                        stem.questions.remove(at: index)
                                    }
                                } label: {
                                    Label("Remove", systemImage: "minus")
                                        .labelStyle(.iconOnly)
                                        .buttonStyle(.bordered)
                                        .buttonBorderShape(.circle)
                                }
                                .disabled(stem.questions.count == 1)
                                QuestionEditor(question: question)
                            }
                        }
                    }
                    .formStyle(.columns)
                    .navigationSplitViewColumnWidth(min: 180, ideal: 200)

                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    showAddImages.toggle()
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
        .fileImporter(isPresented: $showAddImages, allowedContentTypes: [.image]) { result in
            switch result {
            case .success(let fileURL):
                stem.images.append(fileURL)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
//        .fileImporter(isPresented: $showProcessStem, allowedContentTypes: [.image]) { result in
//            switch result {
//            case .success(let fileURL):
//                if let data = try? Data(contentsOf: fileURL),
//                   let nsImage = NSImage(data: data) {
//                    recogniseText(from: nsImage)
//                } else {
//                    print("Error loading image")
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
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
        stem.questions.append(.init())
    }
    
    private func insertOptions() -> [Question.Option] {
        var possibleOptions: [String] = []
        
        let lines = userInput.split(separator: "\n")
        lines.forEach { line in
            if let capture = line.firstMatch(of: /[A-Z]\. ([\w ]+)/) {
                possibleOptions.append(String(capture.output.1))
            }
        }
        return possibleOptions.map { Question.Option(text: $0) }
    }
}

extension URL: @retroactive Identifiable {
    public var id: String { self.absoluteString }
}

#Preview {
    StemEditor()
}
