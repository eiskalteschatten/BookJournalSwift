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
    
    public var sortedTranslators: [Translator] {
        let set = translators as? Set<Translator> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var sortedLists: [ListOfBooks] {
        let set = lists as? Set<ListOfBooks> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var sortedGenres: [Genre] {
        let set = genres as? Set<Genre> ?? []
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
    
    public var readingStatusString: String? {
        if let status = readingStatus {
            if let statusKey = BookReadingStatus(rawValue: status) {
                return bookReadingStatusProperties[statusKey]
            }
            
            return nil
        }
        
        return nil
    }
    
    public var bookFormatStrings: [String] {
        if let format = bookFormat {
            if let formatKey = BookFormat(rawValue: format) {
                return bookFormatProperties[formatKey] ?? [""]
            }
            
            return [""]
        }
        
        return [""]
    }
    
    public var languageReadInLocalizedName: String {
        if let unwrapped = languageReadIn {
            let locale: Locale = .current
            return locale.localizedString(forLanguageCode: unwrapped) ?? ""
        }
        else {
            return ""
        }
    }
    
    public var originalLanguageLocalizedName: String {
        if let unwrapped = originalLanguage {
            let locale: Locale = .current
            return locale.localizedString(forLanguageCode: unwrapped) ?? ""
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
