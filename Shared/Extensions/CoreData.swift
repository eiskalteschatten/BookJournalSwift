//
//  CoreData.swift
//  BookJournal
//
//  Created by Alex Seifert on 26.02.22.
//

import SwiftUI

extension Book {
    public var sortedAuthors: [Author] {
        let set = authors as? Set<Author> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var sortedEditors: [Editor] {
        let set = editors as? Set<Editor> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var dateStartedFormatted: String {
        if let unwrapped = dateStarted {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            return dateFormatter.string(from: unwrapped)
        }
        else {
            return ""
        }
    }
    
    public var dateFinishedFormatted: String {
        if let unwrapped = dateFinished {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            return dateFormatter.string(from: unwrapped)
        }
        else {
            return ""
        }
    }
}

extension AbstractName {
    public var wrappedName: String {
        name ?? "Unnamed"
    }
}
