//
//  SidebarViewToolbar.swift
//  UltimatePortfolio
//
//  Created by Gaspare Monte on 14/02/24.
//

import SwiftUI

struct SidebarViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @State private var showingAwards: Bool = false

    var body: some View {
#if DEBUG
        Button {
            dataController.deleteAll()
            dataController.createSampleData()
        } label: {
            Label("ADD SAMPLES", systemImage: "flame")
        }
#endif

        Button {
            showingAwards.toggle()
        } label: {
            Label("Show awards", systemImage: "rosette")
        }
        .sheet(isPresented: $showingAwards, content: AwardView.init)

        Button(action: dataController.newTag) {
            Label("Add tag", systemImage: "plus")
        }
    }
}

#Preview {
    SidebarViewToolbar()
        .environmentObject(DataController.preview)
}
