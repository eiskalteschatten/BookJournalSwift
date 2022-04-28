//
//  CategoriesSearchList.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

struct CategoriesSearchList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var title = "Categories"
    @Binding var selectedItems: [Category]
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: false)]
    ) private var categories: FetchedResults<Category>
    
    var body: some View {
        SearchList<Category>(
            title: title,
            data: categories.map { $0 },
            selectedData: $selectedItems,
            createEntity: createEntity,
            createTitle: "Create a Category"
        )
    }
    
    private func createEntity() -> Category {
        return Category(context: viewContext)
    }
}

struct CategoriesSearchList_Previews: PreviewProvider {
    @State static var items: [Category] = []
    
    static var previews: some View {
        CategoriesSearchList(selectedItems: $items)
    }
}
