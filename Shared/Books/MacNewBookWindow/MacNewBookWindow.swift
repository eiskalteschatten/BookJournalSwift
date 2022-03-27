//
//  MacNewBookWindow.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 20.03.22.
//

import Cocoa
import SwiftUI

class MacNewBookWindow: NSWindow {
    var viewContext: NSManagedObjectContext?
    
    override func close() {
        if viewContext != nil && viewContext!.hasChanges {
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

class MacNewBookWindowManager {
    var window: MacNewBookWindow?
    
    private var viewContext: NSManagedObjectContext?
    
    init() {
        let persistenceController = PersistenceController.shared
        viewContext = persistenceController.container.viewContext
    }
    
    func openWindow() {
        if viewContext != nil {
            let contentView = MacNewBookWindowView(newBookWindow: self)
                .environment(\.managedObjectContext, viewContext!)
            
            window = MacNewBookWindow(
                contentRect: NSRect(x: 0, y: 0, width: 450, height: 550),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: false
            )

            window!.viewContext = viewContext
            window!.center()
            window!.setFrameAutosaveName("NewBookWindow")
            window!.title = "Add a New Book"
            window!.isReleasedWhenClosed = false
            window!.isMovableByWindowBackground  = true
            window!.titleVisibility = .hidden
            window!.titlebarAppearsTransparent = true
            window!.styleMask.insert(.fullSizeContentView)

            window!.contentView = NSHostingView(rootView: contentView)
            window!.makeKeyAndOrderFront(nil)
        }
    }
    
    func close() {
        window?.close()
    }
}
