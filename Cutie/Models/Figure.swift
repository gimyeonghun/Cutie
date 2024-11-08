//
//  Figure.swift
//  Cutie
//
//  Created by Brian Kim on 8/11/2024.
//

import Foundation
import SwiftData

@Model
final class Figure: Identifiable {
    var id = UUID()
    var dateCreated: Date = Date()
    
    var stem: Stem?
    
    @Attribute(.externalStorage) var image: Data
    
    init(_ data: Data) {
        self.image = data
    }
}
