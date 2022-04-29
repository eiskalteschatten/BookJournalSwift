//
//  ErrorHandling.swift
//  BookJournal
//
//  Created by Alex Seifert on 29.04.22.
//

import SwiftUI

func handleCoreDataError(_ error: NSError) {
    let errorMessage = "An error occurred while attempting to save your changes."
    let subErrorMessage = "Please wait a little bit and try again."
    
    #if os(macOS)
    let alert = NSAlert()
    alert.messageText = errorMessage
    alert.informativeText = subErrorMessage
    alert.addButton(withTitle: "OK")
    alert.alertStyle = .critical
    #else
    let globalViewModel = GlobalViewModel.shared
    globalViewModel.globalError = errorMessage
    globalViewModel.globalErrorSubtext = subErrorMessage
    globalViewModel.showGlobalErrorAlert = true
    #endif
    
    #if DEBUG
    fatalError("Unresolved error \(error), \(error.userInfo)")
    #endif
}
