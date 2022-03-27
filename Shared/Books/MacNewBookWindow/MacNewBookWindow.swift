//
//  MacNewBookWindow.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 20.03.22.
//

import Cocoa
import SwiftUI

final class MacNewBookWindow: NSWindow {
    override func close() {
        let persistenceController = PersistenceController.shared
        let viewContext = persistenceController.container.viewContext
        
        if viewContext.hasChanges {
            let alert = NSAlert()
            alert.messageText = "Are you sure you want to close this window?"
            alert.informativeText = "Your changes will be lost if you continue."
            alert.addButton(withTitle: "No")
            alert.addButton(withTitle: "Yes")
            alert.alertStyle = .warning
            
            let dontClose = alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
        
            if !dontClose {
                super.close()
            }
        }
        else {
            super.close()
        }
    }
}

func openNewBookWindow() {
    let persistenceController = PersistenceController.shared
    
    let contentView = MacNewBookWindowView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    
    let window = MacNewBookWindow(
        contentRect: NSRect(x: 0, y: 0, width: 450, height: 550),
        styleMask: [.titled, .closable, .miniaturizable, .resizable],
        backing: .buffered,
        defer: false
    )
    
    window.center()
    window.setFrameAutosaveName("NewBookWindow")
    window.title = "Add a New Book"
    window.isReleasedWhenClosed = false
    window.isMovableByWindowBackground  = true
    window.titleVisibility = .hidden
    window.titlebarAppearsTransparent = true
    window.styleMask.insert(.fullSizeContentView)

    window.contentView = NSHostingView(rootView: contentView)
    window.makeKeyAndOrderFront(nil)
}
