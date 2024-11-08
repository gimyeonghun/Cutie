//
//  StemInfoEditor.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import SwiftUI

struct StemInfoEditor: View {
    let stemInfo: StemInfo?
    
    @State var background: String = ""
    @State var complaint: String = ""
    @State var complaintHistory: String = ""
    @State var dentalHistory: String = ""
    @State var medicalHistory: String = ""
    @State var extraOral: String = ""
    @State var intraOral: String = ""
    @State var additional: String = ""
    
    var body: some View {
        if let stemInfo {
            Group {
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
            .onAppear {
                background = stemInfo.background
                complaint = stemInfo.complaint
                complaintHistory = stemInfo.complaintHistory
                dentalHistory = stemInfo.dentalHistory
                medicalHistory = stemInfo.medicalHistory
                extraOral = stemInfo.extraOral
                intraOral = stemInfo.intraOral
                additional = stemInfo.additional
            }
        }
    }
}
