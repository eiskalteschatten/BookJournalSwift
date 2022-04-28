//
//  GenresSearchList.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

struct GenresSearchList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var title = "Genres"
    @Binding var selectedItems: [Genre]
    
    @FetchRequest(
        entity: Genre.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Genre.name, ascending: false)]
    ) private var genres: FetchedResults<Genre>
    
    var body: some View {
        SearchList<Genre>(
            title: title,
            data: genres.map { $0 },
            selectedData: $selectedItems,
            createEntity: createEntity
        )
    }
    
    private func createEntity() -> Genre {
        return Genre(context: viewContext)
    }
}

struct GenresSearchList_Previews: PreviewProvider {
    @State static var items: [Genre] = []
    
    static var previews: some View {
        GenresSearchList(selectedItems: $items)
    }
}
