//
//  BookJournalApp.swift
//  Shared
//
//  Created by Alex Seifert on 23.01.22.
//

import SwiftUI

@main
struct BookJournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        #if os(macOS)
        .commands {
            SidebarCommands()
            BookJournalCommands()
        }
        #endif
    }
}
