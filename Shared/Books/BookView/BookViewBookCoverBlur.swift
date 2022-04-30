//
//  BookViewBookCoverBlur.swift
//  BookJournal
//
//  Created by Alex Seifert on 31.03.22.
//

import SwiftUI

struct BookViewBookCoverBlur: View {
    @ObservedObject var book: Book
    
    var body: some View {
        let bookcover = getBookcover(book: book)
        
        GeometryReader { geometry in
            if geometry.frame(in: .global).minY <= 0 {
                bookcover
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(y: geometry.frame(in: .global).minY / 9)
                    .clipped()
                    .blur(radius: 30)
                    .opacity(0.4)
            }
            else {
                bookcover
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                    .clipped()
                    .offset(y: -geometry.frame(in: .global).minY)
                    .blur(radius: 30)
                    .opacity(0.4)
            }
        }
        .frame(height: 200)
    }
}

struct BookViewBookCoverBlur_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = context.registeredObjects.first(where: { $0 is Book }) as! Book
        
        BookViewBookCoverBlur(book: book)
    }
}
