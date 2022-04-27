//
//  BookListItem.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.02.22.
//

import SwiftUI
import CoreData
import WrappingHStack

struct BookListItem: View {
    @ObservedObject var book: Book
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            let bookcover = getBookcover(book: book)
            
            bookcover
                .resizable()
                .scaledToFit()
                .frame(width: 50.0, height: 77.0)
                .clipped()
            
            VStack(alignment: .leading, spacing: 3.0) {
                Text(book.title ?? "")
                    .font(Font.body.bold())
                    .padding(.bottom, 2)
                
                if (book.authors != nil && book.sortedAuthors.count > 0) {
                    let authors = book.sortedAuthors.map{ $0.name ?? "" }.joined(separator: ", ")
                    Text(authors)
                        .font(.footnote)
                }
            }
        }
        .padding(.top, 5.0)
        .padding(.bottom, 5.0)
    }
}

struct BookListItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = Book(context: context)
        BookListItem(book: book).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

