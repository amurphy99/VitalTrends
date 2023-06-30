//
//  murand0App.swift
//  murand0
//
//  Created by Andrew Murphy on 12/11/22.
//

import SwiftUI

@main
struct murand0App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}
