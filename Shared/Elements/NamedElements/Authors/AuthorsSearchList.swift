//
//  AuthorsSearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct AuthorsSearchList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var title = "Authors"
    @Binding var selectedItems: [Author]
    
    @FetchRequest(
        entity: Author.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Author.name, ascending: false)]
    ) private var authors: FetchedResults<Author>
    
    var body: some View {
        SearchList<Author>(
            title: title,
            data: authors.map { $0 },
            selectedData: $selectedItems,
            createEntity: createEntity
        )
    }
    
    private func createEntity() -> Author {
        return Author(context: viewContext)
    }
}

struct AuthorsSearchList_Previews: PreviewProvider {
    @State static var items: [Author] = []
    
    static var previews: some View {
        AuthorsSearchList(selectedItems: $items)
    }
}
