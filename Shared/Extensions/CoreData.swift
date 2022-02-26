//
//  CoreData.swift
//  BookJournal
//
//  Created by Alex Seifert on 26.02.22.
//

extension Book {
    public var authorArray: [Author] {
        let set = authors as? Set<Author> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

extension Author {
    public var wrappedName: String {
        name ?? "Unknown Author"
    }
}
