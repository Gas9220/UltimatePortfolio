//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Gaspare Monte on 08/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ViewModel

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List(selection: $viewModel.dataController.selectedIssue) {
            ForEach(viewModel.dataController.issuesForSelectedFilter()) { issue in
                IssueRow(issue: issue)
            }
            .onDelete(perform: viewModel.delete)
        }
        .toolbar(content: ContentViewToolbar.init)
        .navigationTitle("Issues")
        .searchable(
            text: $viewModel.dataController.filterText,
            tokens: $viewModel.dataController.filterTokens,
            suggestedTokens: .constant(viewModel.dataController.suggestedFilterTokens),
            prompt: "Filter issues, or type # to add tags") { tag in Text(tag.tagName)
            }
    }

}

#Preview {
    ContentView(dataController: .preview)
}
