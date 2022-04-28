//
//  BookLinksView.swift
//  BookJournal
//
//  Created by Alex Seifert on 28.04.22.
//

import SwiftUI

struct BookLinksView: View {
    var book: Book
    
    var body: some View {
        HStack(spacing: 20) {
            Button("Amazon", action: {
                guard let url = buildSearchURL(AMAZON_SEARCH_URL) else {
                    // TODO: what do I do here?
                    return
                }
                
                openURLInBrowser(url)
            })
                #if os(macOS)
                .buttonStyle(.link)
                #endif
            
            Button("Google Books", action: {
                guard let url = buildSearchURL(GOOGLE_BOOKS_SEARCH_URL) else {
                    // TODO: what do I do here?
                    return
                }
                
                openURLInBrowser(url)
            })
                #if os(macOS)
                .buttonStyle(.link)
                #endif
        }
    }
    
    private func buildSearchURL(_ url: String) -> URL? {
        if var isbn = book.isbn, !isbn.isEmpty {
            isbn = isbn.replacingOccurrences(of: "-", with: "")
            isbn = isbn.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
            return URL(string: "\(url)\(isbn)")
        }
        else {
            if let title = book.title {
                var query = title
                
                if book.sortedAuthors.count > 0 {
                    query += " " + book.sortedAuthors.map({ $0.name ?? "" }).joined(separator: " ")
                }
                
                query = query.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
                return URL(string: "\(url)\(query)")
            }
        }
        
        return nil
    }
}

struct BookLinksView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = context.registeredObjects.first(where: { $0 is Book }) as! Book
        
        BookLinksView(book: book)
    }
}
