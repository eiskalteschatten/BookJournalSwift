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
    
    @FetchRequest(
        entity: Translator.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Translator.name, ascending: false)]
    ) private var translators: FetchedResults<Translator>
    
    var body: some View {
        SearchList<Translator>(
            title: title,
            data: translators.map { $0 },
            selectedData: $selectedItems,
            createEntity: createEntity
        )
    }
    
    private func createEntity() -> Translator {
        return Translator(context: viewContext)
    }
}

struct TranslatorsSearchList_Previews: PreviewProvider {
    @State static var items: [Translator] = []
    
    static var previews: some View {
        TranslatorsSearchList(selectedItems: $items)
    }
}
