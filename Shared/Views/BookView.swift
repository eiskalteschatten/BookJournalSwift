//
//  BookView.swift
//  BookJournal
//
//  Created by Alex Seifert on 20.02.22.
//

import SwiftUI
import CoreData

struct BookView: View {
    var book: Item
    
    var body: some View {
        Text("test!")
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        AllBooksView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

