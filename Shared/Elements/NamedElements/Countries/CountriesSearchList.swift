//
//  CountriesSearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct CountriesSearchList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var title = "Countries"
    @Binding var selectedItem: Country?
    
    @FetchRequest(
        entity: Country.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Country.name, ascending: false)]
    ) private var countries: FetchedResults<Country>
    
    var body: some View {
        SearchList<Country>(
            title: title,
            data: countries.map { $0 },
            selectedData: $selectedItem,
            createEntity: createEntity
        )
    }
    
    private func createEntity() -> Country {
        return Country(context: viewContext)
    }
}

struct CountriesSearchList_Previews: PreviewProvider {
    @State static var item: Country?
    
    static var previews: some View {
        CountriesSearchList(selectedItem: $item)
    }
}
