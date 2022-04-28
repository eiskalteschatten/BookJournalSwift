//
//  EditorsSearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct EditorsSearchList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var title = "Editors"
    @Binding var selectedItems: [Editor]
    
    var body: some View {
        SearchList<Editor>(
            title: title,
            selectedData: $selectedItems,
            createTitle: "Create an Editor"
        )
    }
}

struct EditorsSearchList_Previews: PreviewProvider {
    @State static var items: [Editor] = []
    
    static var previews: some View {
        EditorsSearchList(selectedItems: $items)
    }
}
