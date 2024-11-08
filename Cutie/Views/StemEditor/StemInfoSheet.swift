//
//  StemInfoSheet.swift
//  Cutie
//
//  Created by Brian Kim on 7/11/2024.
//

import SwiftUI
import Vision
import VisionKit
import Foundation

struct StemInfoSheet: View {
    let stem: Stem
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var background: String = ""
    @State var complaint: String = ""
    @State var complaintHistory: String = ""
    @State var dentalHistory: String = ""
    @State var medicalHistory: String = ""
    @State var extraOral: String = ""
    @State var intraOral: String = ""
    @State var additional: String = ""
    
    @State private var showProcessStem: Bool = false
    
    @State private var userInput: String = ""
    
    @State private var userImage: NSImage?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let userImage {
                        Image(nsImage: userImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    HStack {
                        processView
                            .frame(width: 400)
                            
                        inputView
                    }
                }
                .padding(10)
            }
        }
        .frame(minWidth: 800)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let newStem = StemInfo(background: background, complaint: complaint, complaintHistory: complaintHistory, dentalHistory: dentalHistory, medicalHistory: medicalHistory, extraOral: extraOral, intraOral: intraOral, additional: additional)
                    modelContext.insert(newStem)
                    
                    stem.info = newStem
                    dismiss()
                }
            }
        }
        .fileImporter(isPresented: $showProcessStem, allowedContentTypes: [.image]) { result in
            switch result {
            case .success(let fileURL):
                if let data = try? Data(contentsOf: fileURL),
                   let nsImage = NSImage(data: data) {
                    userImage = nsImage
                    recogniseText(from: nsImage)
                } else {
                    print("Error loading image")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    var processView: some View {
        TextEditor(text: $userInput)
            .font(.system(size: 14))
            .padding(.horizontal, 4)
            .frame(width: 400, height: 300)
    }
    
    var inputView: some View {
        ScrollView {
            Form {
                HStack {
                    Button {
                        showProcessStem.toggle()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Recognise Text from Image", systemImage: "apple.image.playground")
                            Spacer()
                        }
                    }
                    .controlSize(.extraLarge)
                    .padding(.top, 4)
                }
                TextField("Background", text: $background, axis: .vertical)
                    .lineLimit(1...)
                TextField("Complaint", text: $complaint, axis: .vertical)
                    .lineLimit(1...)
                TextField("Complaint History", text: $complaintHistory, axis: .vertical)
                    .lineLimit(1...)
                TextField("Dental History", text: $dentalHistory, axis: .vertical)
                    .lineLimit(1...)
                TextField("Medical History", text: $medicalHistory, axis: .vertical)
                    .lineLimit(1...)
                TextField("Extraoral", text: $extraOral, axis: .vertical)
                    .lineLimit(1...)
                TextField("Intraoral", text: $intraOral, axis: .vertical)
                    .lineLimit(1...)
                TextField("Additional", text: $additional, axis: .vertical)
                    .lineLimit(1...)
            }
        }
    }
    
    private func matchOptions() {
        if let capture = userInput.firstMatch(of: /intra oral ([\w ]+)/) {
            let information = String(capture.output.1)
            intraOral = information
        }
        if let capture = userInput.firstMatch(of: /(\d+ \w+-\w+ \w+ \w+)/) {
            let information = String(capture.output.1)
            background = information
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
        matchOptions()
    }
}
