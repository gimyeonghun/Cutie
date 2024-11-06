//
//  Item.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
