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
    
    var body: some View {
        SearchList<Author>(
            title: title,
            selectedData: $selectedItems,
            createTitle: "Create an Author"
        )
    }
}

struct AuthorsSearchList_Previews: PreviewProvider {
    @State static var items: [Author] = []
    
    static var previews: some View {
        AuthorsSearchList(selectedItems: $items)
    }
}
