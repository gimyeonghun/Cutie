//
//  ContentView.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import SwiftUI

struct ContentView: View {
    @State var stems: [Stem] = []
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(stems) { stem in
                    Text(stem.title)
                }
            }
            .toolbar {
                Button {
                    stems.append(Stem())
                } label: {
                    Label("Add Stem", systemImage: "plus")
                }
            }
        } detail: {
            StemEditor()
        }
    }
}

#Preview {
    ContentView()
        .padding()
}
