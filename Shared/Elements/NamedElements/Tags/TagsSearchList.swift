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
    
    @FetchRequest(
        entity: Tag.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: false)]
    ) private var tags: FetchedResults<Tag>
    
    var body: some View {
        SearchList<Tag>(
            title: title,
            data: tags.map { $0 },
            selectedData: $selectedItems,
            createEntity: createEntity
        )
    }
    
    private func createEntity() -> Tag {
        return Tag(context: viewContext)
    }
}

struct TagsSearchList_Previews: PreviewProvider {
    @State static var items: [Tag] = []
    
    static var previews: some View {
        TagsSearchList(selectedItems: $items)
    }
}
