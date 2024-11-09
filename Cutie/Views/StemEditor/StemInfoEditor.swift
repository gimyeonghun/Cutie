//
//  StemInfoEditor.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import SwiftUI
import SwiftData

struct StemInfoEditor: View {
    @Query private var stemInfos: [StemInfo]
    
    let stem: Stem
    
    init(for stem: Stem) {
        let id = stem.id
        let predicate = #Predicate<StemInfo> { info in
            info.stem?.id == id
        }
        _stemInfos = Query(filter: predicate)
        self.stem = stem
    }
    
    @State var background: String = ""
    @State var complaint: String = ""
    @State var complaintHistory: String = ""
    @State var dentalHistory: String = ""
    @State var medicalHistory: String = ""
    @State var extraOral: String = ""
    @State var intraOral: String = ""
    @State var additional: String = ""
    
    var body: some View {
        ForEach(stemInfos) { stemInfo in
            TextField("Background", text: $background, axis: .vertical)
                .lineLimit(1...)
                .onSubmit {
                    stemInfo.background = background
                }
            TextField("Complaint", text: $complaint, axis: .vertical)
                .lineLimit(1...)
                .onSubmit {
                    stemInfo.complaint = complaint
                }
            TextField("Complaint History", text: $complaintHistory, axis: .vertical)
                .lineLimit(1...)
                .onSubmit {
                    stemInfo.complaintHistory = complaintHistory
                }
            TextField("Dental History", text: $dentalHistory, axis: .vertical)
                .lineLimit(1...)
                .onSubmit {
                    stemInfo.dentalHistory = dentalHistory
                }
            TextField("Medical History", text: $medicalHistory, axis: .vertical)
                .lineLimit(1...)
                .onSubmit {
                    stemInfo.medicalHistory = medicalHistory
                }
            TextField("Extraoral", text: $extraOral, axis: .vertical)
                .lineLimit(1...)
                .onSubmit {
                    stemInfo.extraOral = extraOral
                }
            TextField("Intraoral", text: $intraOral, axis: .vertical)
                .lineLimit(1...)
                .onSubmit {
                    stemInfo.intraOral = intraOral
                }
            TextField("Additional", text: $additional, axis: .vertical)
                .lineLimit(1...)
                .onSubmit {
                    stemInfo.additional = additional
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
