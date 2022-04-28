//
//  Helpers.swift
//  BookJournal
//
//  Created by Alex Seifert on 28.04.22.
//

import SwiftUI

func openURLInBrowser(_ url: URL) {
    #if os(iOS)
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
    #else
    NSWorkspace.shared.open(url)
    #endif
}
