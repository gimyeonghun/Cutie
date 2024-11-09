//
//  NavigationPath.swift
//  Cutie
//
//  Created by Brian Kim on 7/11/2024.
//

import SwiftUI

enum NavigationPath: Hashable {
    case test
    case exam(_ exam: Exam)
    case isSearching
}

enum DetailPath: Hashable {
    case stem(_ stem: Stem)
    case exam(_ exam: Exam)
    case quiz(_ speciality: Speciality)
}
