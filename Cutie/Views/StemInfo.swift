//
//  StemInfo.swift
//  Cutie
//
//  Created by Brian Kim on 6/11/2024.
//

import SwiftUI

struct StemInfo: View {
    @State var stemInfo: Stem.Info
    
    var body: some View {
        TextField("Background", text: $stemInfo.background)
        TextField("Complaint", text: $stemInfo.complaint)
        TextField("Complaint History", text: $stemInfo.complaintHistory)
        TextField("Dental History", text: $stemInfo.dentalHistory)
        TextField("Medical History", text: $stemInfo.medicalHistory)
        TextField("Extraoral", text: $stemInfo.extraOral)
        TextField("Intraoral", text: $stemInfo.intraOral)
        TextField("Additional", text: $stemInfo.additional)
    }
}

#Preview {
    @Previewable @State var stemInfo = Stem.Info()
    StemInfo(stemInfo: stemInfo)
}
