//
//  BookViewBookCoverTitle.swift
//  BookJournal
//
//  Created by Alex Seifert on 31.03.22.
//

import SwiftUI

struct BookViewBookCoverTitle: View {
    @ObservedObject var book: Book
    
    var body: some View {
        let bookcover = getBookcover(book: book)
        
        VStack(spacing: 30) {
            #if os(macOS)
            let frameHeight = 400.0
            #else
            let frameHeight = 307.0
            #endif
            
            bookcover
                .resizable()
                .scaledToFit()
                .frame(height: frameHeight)
                .padding(.horizontal)
                .shadow(radius: 5)
            
            Text(book.title ?? "")
                .font(.title)
                .textSelection(.enabled)
        }
    }
}

struct BookViewBookCoverTitle_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = context.registeredObjects.first(where: { $0 is Book }) as! Book
        
        BookViewBookCoverTitle(book: book)
    }
}
