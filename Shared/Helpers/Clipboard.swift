//
//  Clipboard.swift
//  BookJournal
//
//  Created by Alex Seifert on 29.04.22.
//

import SwiftUI

#if os(macOS)
fileprivate let pasteboard = NSPasteboard.general
#else
fileprivate let pasteboard = UIPasteboard.general
#endif

func copyTextToClipboard(_ text: String) {
    #if os(macOS)
    pasteboard.clearContents()
    pasteboard.setString(text, forType: .string)
    #else
    pasteboard.string = text
    #endif
}
