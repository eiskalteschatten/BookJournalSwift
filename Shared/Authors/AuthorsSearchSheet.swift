//
//  AuthorsSearchSheet.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct AuthorsSearchSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var selectedAuthors: [Author]
    
    @FetchRequest(
        entity: Author.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Author.name, ascending: false)]
    ) private var authors: FetchedResults<Author>
    
    var body: some View {
        SearchSheet<Author>(title: "Search Authors", data: authors, selectedData: $selectedAuthors)
    }
    
    // TODO: Replace with actual authors
    private func getMockAuthors() {
        let mockAuthor1 = Author(context: viewContext)
        mockAuthor1.name = "Liz"
        
        let mockAuthor2 = Author(context: viewContext)
        mockAuthor2.name = "Scott"
        
        do {
            try viewContext.save()
        } catch {
            // TODO: Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct AuthorsSearchSheet_Previews: PreviewProvider {
    @State static var authors: [Author] = []
    
    static var previews: some View {
        AuthorsSearchSheet(selectedAuthors: $authors)
    }
}
