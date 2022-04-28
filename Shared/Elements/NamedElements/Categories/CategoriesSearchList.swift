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
    
    var body: some View {
        SearchList<Category>(
            title: title,
            selectedData: $selectedItems,
            createTitle: "Create a Category"
        )
    }
}

struct CategoriesSearchList_Previews: PreviewProvider {
    @State static var items: [Category] = []
    
    static var previews: some View {
        CategoriesSearchList(selectedItems: $items)
    }
}
