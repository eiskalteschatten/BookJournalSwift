//
//  Lists.swift
//  BookJournal
//
//  Created by Alex Seifert on 04.05.22.
//

import SwiftUI
import CoreData

let listSFSymbols = [
    DEFAULT_LIST_ICON,
    "list.bullet",
    "list.triangle",
    "list.number",
    "list.star",
    "list.bullet.rectangle",
    "list.bullet.circle",
    "list.and.film",
    "music.note.list",
    "music.note",
    "book",
    "book.circle",
    "books.vertical",
    "text.book.closed",
    "character.book.closed",
    "checklist",
    "star",
    "asterisk",
    "memorychip",
    "desktopcomputer",
    "laptopcomputer",
    "laptopcomputer.and.arrow.down",
    "arrow.down",
    "arrow.down.circle",
    "arrow.down.square",
    "bookmark",
    "bookmark.circle",
    "bookmark.square",
    "checkmark",
    "checkmark.circle",
    "exclamationmark.circle",
    "exclamationmark.triangle",
    "exclamationmark",
    "exclamationmark.2",
    "exclamationmark.3",
    "arrow.clockwise",
    "arrow.clockwise.circle",
    "square.and.arrow.up",
    "person",
    "person.2",
    "person.3",
    "timer",
    "trash",
    "pencil.and.outline",
    "highlighter",
    "graduationcap",
    "graduationcap.circle",
    "globe",
    "sun.min",
    "moon",
    "cloud",
    "cloud.rain",
    "snowflake",
    "thermometer.sun",
    "heart",
    "heart.circle",
    "flag",
    "flag.circle",
    "brain.head.profile",
    "camera",
    "quote.bubble",
    "bubble.left.and.bubble.right",
    "phone",
    "cart",
    "cart.circle",
    "bag",
    "bag.circle",
    "barcode",
    "gift",
    "gauge",
    "speedometer",
    "theatermasks",
    "theatermasks.circle",
    "cross.vial",
    "applelogo"
]

let defaultLists = [
    ["Wishlist", "list.star"],
    ["Borrowed Books", "person.2"],
    ["Lent Books", "gift"],
    ["Books Recommended to Me", "star"]
]

func createDefaultListsInCoreData() {
    let persistenceController = PersistenceController.shared
    let viewContext = persistenceController.container.viewContext
    
    let preferencesFetch: NSFetchRequest<AppPreferences> = AppPreferences.fetchRequest()
    preferencesFetch.fetchLimit = 1
    
    do {
        let preferences = try viewContext.fetch(preferencesFetch)
        
        let preferencesRow = preferences.count > 0 ? preferences[0] : AppPreferences(context: viewContext)
        
        if !preferencesRow.defaultListsCreated {
            defaultLists.forEach { list in
                let newList = ListOfBooks(context: viewContext)
                newList.createdAt = Date()
                newList.updatedAt = Date()
                newList.name = list[0]
                newList.icon = list[1]
            }
            
            preferencesRow.defaultListsCreated = true
            
            try viewContext.save()
        }
    } catch {
        handleCoreDataError(error as NSError)
    }
}
