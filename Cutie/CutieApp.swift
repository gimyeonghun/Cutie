//
//  CutieApp.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import SwiftUI
import SwiftData

@main
struct CutieApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Exam.self, Question.self, Stem.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
