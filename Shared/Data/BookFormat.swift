//
//  BookFormat.swift
//  BookJournal
//
//  Created by Alex Seifert on 25.02.22.
//

enum BookFormat: String, CaseIterable, Identifiable {
    case paperback, hardback, ebook, audiobook, other
    var id: Self { self }
}

let bookFormatProperties: [BookFormat: [String]] = [
    .paperback: ["Paperback", "book"],
    .hardback: ["Hardback", "book.closed"],
    .ebook: ["E-Book", "ipad"],
    .audiobook: ["Audiobook", "airpodsmax"],
    .other: ["Other", "questionmark"]
]
