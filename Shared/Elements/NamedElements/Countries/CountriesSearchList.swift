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
    
    var body: some View {
        SearchList<Country>(
            title: title,
            selectedData: $selectedItem,
            createTitle: "Create a Country"
        )
    }
}

struct CountriesSearchList_Previews: PreviewProvider {
    @State static var item: Country?
    
    static var previews: some View {
        CountriesSearchList(selectedItem: $item)
    }
}
