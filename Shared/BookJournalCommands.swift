//
//  BookJournalCommands.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 29.04.22.
//

import SwiftUI

struct BookJournalCommands: Commands {
    var body: some Commands {
        CommandGroup(replacing: CommandGroupPlacement.newItem) {
            Button("New Book") {
                let newBookWindow = MacEditBookWindowManager()
                newBookWindow.openWindow()
            }
            .keyboardShortcut("n", modifiers: [.command])
            
            Divider()
            
            Button("New Window") {
                if let currentWindow = NSApp.keyWindow,
                   let windowController = currentWindow.windowController {
                    windowController.newWindowForTab(nil)
                    
                    if let newWindow = NSApp.keyWindow,
                       currentWindow != newWindow {
                        newWindow.makeKeyAndOrderFront(nil)
                    }
                }
            }
            .keyboardShortcut("n", modifiers: [.option, .command])
            
            Button("New Tab") {
                if let currentWindow = NSApp.keyWindow,
                   let windowController = currentWindow.windowController {
                    windowController.newWindowForTab(nil)
                    
                    if let newWindow = NSApp.keyWindow,
                        currentWindow != newWindow {
                        currentWindow.addTabbedWindow(newWindow, ordered: .above)
                    }
                }
            }
            .keyboardShortcut("t", modifiers: [.command])
        }
    }
}
