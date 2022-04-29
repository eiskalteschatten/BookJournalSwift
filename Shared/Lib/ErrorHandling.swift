//
//  ErrorHandling.swift
//  BookJournal
//
//  Created by Alex Seifert on 29.04.22.
//

import SwiftUI
import os

func showErrorAlert(
    error: NSError,
    errorMessage: String,
    subErrorMessage: String,
    logger: Logger?
) {
    let _logger = logger != nil ? logger! : Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "Generic Error"
    )
    
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
    
    let errorToLog = "Unresolved error \(error), \(error.userInfo)"
    _logger.error("\(errorToLog)")
    
    #if DEBUG
    fatalError(errorToLog)
    #endif
}

func handleCoreDataError(_ error: NSError) {
    showErrorAlert(
        error: error,
        errorMessage: "An error occurred while attempting to save your changes.",
        subErrorMessage: "Please wait a little bit and try again.",
        logger: Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: handleCoreDataError.self)
        )
    )
}
