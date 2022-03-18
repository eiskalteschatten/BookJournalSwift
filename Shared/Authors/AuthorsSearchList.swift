//
//  AuthorsSearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct AuthorsSearchList: View {
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
            addItem: addAuthor
        )
    }
    
    private func addAuthor() {
        // TODO
    }
}

struct AuthorsSearchList_Previews: PreviewProvider {
    @State static var authors: [Author] = []
    
    static var previews: some View {
        AuthorsSearchList(selectedAuthors: $authors)
    }
}
