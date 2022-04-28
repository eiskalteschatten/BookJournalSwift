//
//  PublishersSearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct PublishersSearchList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var title = "Publishers"
    @Binding var selectedItem: Publisher?
    
    @FetchRequest(
        entity: Publisher.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Publisher.name, ascending: false)]
    ) private var publishers: FetchedResults<Publisher>
    
    var body: some View {
        SearchList<Publisher>(
            title: title,
            data: publishers.map { $0 },
            selectedData: $selectedItem,
            createTitle: "Create a Publisher"
        )
    }
}

struct PublishersSearchList_Previews: PreviewProvider {
    @State static var item: Publisher?
    
    static var previews: some View {
        PublishersSearchList(selectedItem: $item)
    }
}
