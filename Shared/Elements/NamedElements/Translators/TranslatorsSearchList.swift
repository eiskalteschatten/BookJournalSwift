//
//  TranslatorsSearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct TranslatorsSearchList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var title = "Translators"
    @Binding var selectedItems: [Translator]
    
    var body: some View {
        SearchList<Translator>(
            title: title,
            selectedData: $selectedItems,
            createTitle: "Create a Translator"
        )
    }
}

struct TranslatorsSearchList_Previews: PreviewProvider {
    @State static var items: [Translator] = []
    
    static var previews: some View {
        TranslatorsSearchList(selectedItems: $items)
    }
}
