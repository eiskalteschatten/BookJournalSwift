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
    
    var body: some View {
        SearchList<Genre>(
            title: title,
            selectedData: $selectedItems,
            createTitle: "Create a Genre"
        )
    }
}

struct GenresSearchList_Previews: PreviewProvider {
    @State static var items: [Genre] = []
    
    static var previews: some View {
        GenresSearchList(selectedItems: $items)
    }
}
