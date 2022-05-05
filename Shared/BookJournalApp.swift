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

    @StateObject var globalViewModel = GlobalViewModel.shared
    
    var body: some Scene {
        WindowGroup("BookJournal", id: "BookJournal.viewer") {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(globalViewModel)
                .task {
                    createDefaultListsInCoreData()
                }
                #if os(iOS)
                .alert(globalViewModel.globalError ?? "An error occurred!", isPresented: $globalViewModel.showGlobalErrorAlert, actions: {
                    Button("OK", role: .cancel, action: { globalViewModel.showGlobalErrorAlert = false })
                }, message: {
                    Text(globalViewModel.globalErrorSubtext ?? "An unknown error has occurred.")
                })
                #endif
        }
        #if os(macOS)
        .commands {
            SidebarCommands()
            BookJournalCommands(globalViewModel: globalViewModel)
        }
        #endif
    }
}
