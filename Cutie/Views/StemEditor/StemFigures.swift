//
//  StemFigures.swift
//  Cutie
//
//  Created by Brian Kim on 8/11/2024.
//

import SwiftUI
import SwiftData

struct StemFigures: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Figure.dateCreated) private var figures: [Figure]
    
    let stem: Stem
    
    init(for stem: Stem) {
        let id = stem.id
        let predicate = #Predicate<Figure> { figure in
            figure.stem?.id == id
        }
        _figures = Query(filter: predicate, sort:\.dateCreated)
        self.stem = stem
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(figures) { figure in
                    if let nsImage = NSImage(data: figure.image) {
                        Image(nsImage: nsImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .overlay(alignment: .topTrailing) {
                                Button("-") {
                                    modelContext.delete(figure)
                                }
                            }
                    }
                }
            }
        }
    }
}
