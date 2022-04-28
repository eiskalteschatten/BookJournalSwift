//
//  TagsSearchList.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

struct TagsSearchList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var title = "Tags"
    @Binding var selectedItems: [Tag]
    
    var body: some View {
        SearchList<Tag>(
            title: title,
            selectedData: $selectedItems,
            createTitle: "Create a Tag"
        )
    }
}

struct TagsSearchList_Previews: PreviewProvider {
    @State static var items: [Tag] = []
    
    static var previews: some View {
        TagsSearchList(selectedItems: $items)
    }
}
