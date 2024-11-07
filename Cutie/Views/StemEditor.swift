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
    @State private var userInput = ""
    
    @State private var showFileDialog: Bool = false
    
    @State private var selectedImage: NSImage? = nil
    
    var body: some View {
        HSplitView {
            VStack(alignment: .leading) {
                TextEditor(text: $userInput)
                    .font(.system(size: 14))
                    .frame(width: 400)
                    .padding(4)
                Button("Process") {
                    var question = Question()
                    question.options = insertOptions()
                    stem.questions.append(question)
                }
            }
            ScrollView {
                Form {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(stem.images) { image in
                                if let data = try? Data(contentsOf: image),
                                   let nsImage = NSImage(data: data) {
                                    Image(nsImage: nsImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 300, height: 300)
                                        .onAppear {
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
                    
                } label: {
                    Label("Add Stem Info", systemImage: "info.square")
                }
                Button {
                    showFileDialog.toggle()
                } label: {
                    Label("Add Image", systemImage: "photo.badge.plus.fill")
                }
                Button(action: addQuestion) {
                    Label("Add Item", systemImage: "plus.square.on.square")
                }
            }
        }
        .fileImporter(isPresented: $showFileDialog, allowedContentTypes: [.image]) { result in
            switch result {
            case .success(let fileURL):
                stem.images.append(fileURL)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        // Process the recognized strings.
        print(recognizedStrings)
    }
    
    private func loadImage(from url: URL) {
        // Try loading the data from the file URL
        if let imageData = try? Data(contentsOf: url),
           let nsImage = NSImage(data: imageData) {
            // Set the selected image
            selectedImage = nsImage
        } else {
            print("Failed to load image from URL: \(url)")
        }
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
