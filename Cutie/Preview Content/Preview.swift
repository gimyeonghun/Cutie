//
//  Preview.swift
//  Cutie
//
//  Created by Brian Kim on 7/11/2024.
//

import SwiftUI
import SwiftData

extension ModelContainer {
    @MainActor
    static let previews: ModelContainer = {
        let container = try! ModelContainer(for: Exam.self, Question.self, Stem.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        return container
    }()
}

@MainActor
struct PreviewEnvironmentModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modelContainer(.previews)
    }
}

extension View {
    @MainActor
    func previewEnvironment() -> some View {
        modifier(PreviewEnvironmentModifier())
    }
}
