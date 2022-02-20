//
//  BookView.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.02.22.
//

import SwiftUI
import CoreData

struct BookView: View {
    var book: Book
    
    var body: some View {
        VStack {
            HStack(spacing: 30.0) {
                // TODO: add actual cover image
                Image(systemName: "book.closed.circle")
                    .resizable()
                    .frame(width: 200.0, height: 225.0)
                
                VStack {
                    Text(book.title!)
                        .font(.title)
                    
                    if (book.authors != nil) {
                        Text(getBookAuthors(book.authors!))
                    }
                }
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = Book(context: context)
        BookView(book: book).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
