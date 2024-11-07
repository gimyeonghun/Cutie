//
//  NavigationPath.swift
//  Cutie
//
//  Created by Brian Kim on 7/11/2024.
//

import SwiftUI

enum NavigationPath: Hashable {
    case exam(_ exam: Exam)
}

enum DetailPath: Hashable {
    case stem(_ stem: Stem)
}
//    case feed(_ article: HMCDArticle)
//    case list(from: Int, context: DocumentQuery)
//    case inboxGroup(_ article: HMCDArticle)
//    case libraryGroup(_ document: HMCDDocument)
//    
//    var summary: String {
//        switch self {
//        case .feed(let article):
//            return "Feed: \(article.uuid.uuidString)"
//        case .list(let index, let context):
//            return "List(index: \(index), context: \(context.description))"
//        case .inboxGroup(let article):
//            return "Inbox: \(article.uuid.uuidString)"
//        case .libraryGroup(let document):
//            return "Library: \(document.uuid.uuidString)"
//        }
//    }
//    static func == (lhs: DetailPath, rhs: DetailPath) -> Bool {
//        lhs.hashValue == rhs.hashValue
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(summary)
//    }
//}
