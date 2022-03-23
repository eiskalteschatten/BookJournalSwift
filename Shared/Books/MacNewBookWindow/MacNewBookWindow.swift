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
        // TODO: prompt user for unsaved changes
        // if viewContext.hasChanges { ... }
        super.close()
    }
}

func openNewBookWindow() {
    let persistenceController = PersistenceController.shared
    
    let contentView = MacNewBookWindowView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    
    let window = MacNewBookWindow(
        contentRect: NSRect(x: 0, y: 0, width: 450, height: 500),
        styleMask: [.titled, .closable, .miniaturizable],
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
