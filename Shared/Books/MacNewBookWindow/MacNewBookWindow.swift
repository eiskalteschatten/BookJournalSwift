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
        super.close()
    }
}

func openNewBookWindow() {
    let contentView = MacNewBookWindowView()
    
    let window = MacNewBookWindow(
        contentRect: NSRect(x: 0, y: 0, width: 500, height: 600),
        styleMask: [.titled, .closable, .miniaturizable],
        backing: .buffered,
        defer: false
    )
    
    window.center()
    window.setFrameAutosaveName("NewBookWindow")
    window.title = "Add a New Book"
    window.toolbarStyle = .unifiedCompact
    window.isReleasedWhenClosed = false

    window.contentView = NSHostingView(rootView: contentView)
    window.makeKeyAndOrderFront(nil)
}
