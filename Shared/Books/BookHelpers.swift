//
//  BookHelpers.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.02.22.
//

func getBookAuthors(_ authors: String) -> String {
    return authors.split(separator: ",").joined(separator: ", ")
}
