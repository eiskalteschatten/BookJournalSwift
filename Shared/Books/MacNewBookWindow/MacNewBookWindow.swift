//
//  MacNewBookWindow.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 20.03.22.
//

import Cocoa
import SwiftUI

fileprivate let CLOSE_WITH_PROMPT_DEFAULT = true

class MacNewBookWindow: NSWindow {
    var closeWithPrompt = CLOSE_WITH_PROMPT_DEFAULT
    
    override func close() {
        if closeWithPrompt {
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
    private var book: Book?
    private var window: MacNewBookWindow?
    private var viewContext: NSManagedObjectContext?
    
    init(book: Book? = nil) {
        let persistenceController = PersistenceController.shared
        viewContext = persistenceController.container.viewContext
        self.book = book
    }
    
    func openWindow() {
        if viewContext != nil {
            let contentView = MacNewBookWindowView(newBookWindow: self, book: book)
                .environment(\.managedObjectContext, viewContext!)
            
            window = MacNewBookWindow(
                contentRect: NSRect(x: 0, y: 0, width: 450, height: 550),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: false
            )

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
    
    func close(closeWithPrompt: Bool = CLOSE_WITH_PROMPT_DEFAULT) {
        window?.closeWithPrompt = closeWithPrompt
        window?.close()
    }
}
