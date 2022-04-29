//
//  ErrorHandling.swift
//  BookJournal
//
//  Created by Alex Seifert on 29.04.22.
//

import Foundation

func handleCoreDataError(_ error: NSError) {
    // TODO: show something to the user?
    
    #if DEBUG
    fatalError("Unresolved error \(error), \(error.userInfo)")
    #endif
}
