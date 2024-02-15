//
//  ContentViewModel.swift
//  UltimatePortfolio
//
//  Created by Gaspare Monte on 15/02/24.
//

import Foundation

extension ContentView {
    class ViewModel: ObservableObject {
        var dataController: DataController

        init(dataController: DataController) {
            self.dataController = dataController
        }

        func delete(_ offsets: IndexSet) {
            let issues = dataController.issuesForSelectedFilter()

            for offset in offsets {
                let item = issues[offset]
                dataController.delete(item)
            }
        }
    }
}
