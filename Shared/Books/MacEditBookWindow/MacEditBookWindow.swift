//
//  MacEditBookWindow.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 20.03.22.
//

import Cocoa
import SwiftUI

fileprivate let CLOSE_WITH_PROMPT_DEFAULT = true

class MacEditBookWindow: NSWindow {
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

class MacEditBookWindowManager {
    private var book: Book?
    private var window: MacEditBookWindow?
    private var viewContext: NSManagedObjectContext?
    private var createOptions: BookModelCreateOptions?
    
    init(book: Book? = nil) {
        let persistenceController = PersistenceController.shared
        viewContext = persistenceController.container.viewContext
        self.book = book
    }
    
    func openWindow(createOptions: BookModelCreateOptions? = nil) {
        if viewContext != nil {
            let contentView = MacEditBookWindowView(newBookWindow: self, book: book, createOptions: createOptions)
                .environment(\.managedObjectContext, viewContext!)
            
            window = MacEditBookWindow(
                contentRect: NSRect(x: 0, y: 0, width: 450, height: 550),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: false
            )

            window!.center()
            window!.setFrameAutosaveName("NewBookWindow")
            window!.isReleasedWhenClosed = false
            window!.isMovableByWindowBackground  = true
            window!.titleVisibility = .hidden
            window!.titlebarAppearsTransparent = true
            window!.styleMask.insert(.fullSizeContentView)
            
            if let title = book?.title {
                window!.title = "Edit \(title)"
            }
            else {
                window!.title = "Add a New Book"
            }

            window!.contentView = NSHostingView(rootView: contentView)
            window!.makeKeyAndOrderFront(nil)
        }
    }
    
    func close(closeWithPrompt: Bool = CLOSE_WITH_PROMPT_DEFAULT) {
        window?.closeWithPrompt = closeWithPrompt
        window?.close()
    }
}
