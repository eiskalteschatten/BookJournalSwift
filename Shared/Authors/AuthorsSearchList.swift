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
            selectedData: $selectedAuthors
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
        }
    }
}

struct AuthorsSearchList_Previews: PreviewProvider {
    @State static var authors: [Author] = []
    
    static var previews: some View {
        AuthorsSearchList(selectedAuthors: $authors)
    }
}
