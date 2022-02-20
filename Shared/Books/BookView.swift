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
        Text(book.title!)
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        AllBooksView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

