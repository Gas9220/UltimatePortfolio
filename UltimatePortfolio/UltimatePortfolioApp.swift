//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Gaspare Monte on 08/02/24.
//

import SwiftUI

@main
struct UltimatePortfolioApp: App {
    @StateObject var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        }
    }
}
