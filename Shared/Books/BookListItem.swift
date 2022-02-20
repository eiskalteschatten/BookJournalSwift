//
//  BookListItem.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.02.22.
//

import SwiftUI
import CoreData

struct BookListItem: View {
    var book: Book
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Text("img")
            
            VStack(alignment: .leading, spacing: 3) {
                Text(book.title!)
                    .font(Font.body.bold())
                
                if (book.authors != nil) {
                    Text(book.authors!.split(separator: ",").joined(separator: ", "))
                        .font(.footnote)
                }
            }
        }
        .padding(.top, 3)
        .padding(.bottom, 3)
    }
}

struct BookListItem_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = Book(context: context)
        BookListItem(book: book).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

