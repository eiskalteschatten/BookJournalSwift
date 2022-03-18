//
//  AuthorsSearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

enum AuthorsSearchListScreen: Int {
    case home, createAuthor
}

struct AuthorsSearchList: View {
    @State private var screen: AuthorsSearchListScreen? = .home
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var selectedAuthors: [Author]
    
    @FetchRequest(
        entity: Author.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Author.name, ascending: false)]
    ) private var authors: FetchedResults<Author>
    
    var body: some View {
        SearchList<Author>(
            title: "Search Authors",
            data: authors.map { $0 },
            selectedData: $selectedAuthors,
            onDelete: deleteAuthors
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: CreateAuthor(screen: $screen),
                    tag: AuthorsSearchListScreen.createAuthor,
                    selection: $screen,
                    label: {
                        Image(systemName: "plus")
                    }
                )
            }
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            #endif
        }
    }
    
    private func deleteAuthors(offsets: IndexSet) {
        withAnimation {
            offsets.map { authors[$0] }.forEach(viewContext.delete)

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
}

struct AuthorsSearchList_Previews: PreviewProvider {
    @State static var authors: [Author] = []
    
    static var previews: some View {
        AuthorsSearchList(selectedAuthors: $authors)
    }
}
