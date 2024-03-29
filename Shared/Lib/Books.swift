//
//  Books.swift
//  BookJournal
//
//  Created by Alex Seifert on 25.02.22.
//

import SwiftUI

enum BookReadingStatus: String, CaseIterable, Identifiable {
    case
        notReadYet = "notReadYet",
        currentlyReading = "currentlyReading",
        read = "read",
        stoppedReading = "stoppedReading",
        takingABreak = "takingABreak"
    var id: Self { self }
}

let bookReadingStatusProperties: [BookReadingStatus: String] = [
    .notReadYet: "Not Read Yet",
    .currentlyReading: "Currently Reading",
    .read: "Read",
    .stoppedReading: "Stopped Reading",
    .takingABreak: "Taking a Break"
]

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

let defaultBookcoverNames = [
    "DefaultBookcoverBlack",
    "DefaultBookcoverBlue",
    "DefaultBookcoverRed",
    "DefaultBookcoverGreen",
    "DefaultBookcoverWhite"
]

func getRandomDefaultBookcover() -> String {
    let randomInt = Int.random(in: 0 ..< (defaultBookcoverNames.count - 1))
    return defaultBookcoverNames[randomInt]
}

func getBookcover(book: Book) -> Image {
    #if os(macOS)
    return book.bookcover?.image != nil
        ? Image(nsImage: NSImage(data: book.bookcover!.image!)!)
        : Image(defaultBookcoverNames[0])
    #else
    return book.bookcover?.image != nil
        ? Image(uiImage: UIImage(data: book.bookcover!.image!)!)
        : Image(defaultBookcoverNames[0])
    #endif
}
