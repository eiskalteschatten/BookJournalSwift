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
    var book: Book
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            let bookcover = getBookcover(book: book)
            
            bookcover
                .resizable()
                .scaledToFit()
                .frame(width: 50.0, height: 77.0)
                .clipped()
            
            VStack(alignment: .leading, spacing: 3.0) {
                Text(book.title!)
                    .font(Font.body.bold())
                    .padding(.bottom, 5)
                
                if (book.authors != nil && book.authorArray.count > 0) {
                    WrappingHStack(book.authorArray, id: \.self) { author in
                        Text(author.wrappedName)
                            .font(.footnote)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(AUTHOR_COLOR)
                            )
                            .foregroundColor(.black)
                            .padding(.vertical, 3)
                    }
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

