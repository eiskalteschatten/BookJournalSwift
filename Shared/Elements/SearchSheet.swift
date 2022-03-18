//
//  SearchSheet.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct SearchSheet<T: AbstractName>: View {
    @Environment(\.dismiss) var dismiss
    
    var title: String
    var data: [T]
    @Binding var selectedData: [T]
    
    @State private var searchText = ""
    @State var selectKeeper = Set<String>()
    
    var body: some View {
        NavigationView {
            List(selection: $selectKeeper) {
                ForEach(searchResults, id: \.self) { item in
                    HStack {
                        if item.name != nil {
                            Image(systemName: "circle")
                            
    //                        Image(systemName: "checkmark.circle.fill")
    //                            .foregroundColor(.yellow)
                            Text(item.name!)
                        }
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)) {
                ForEach(searchResults, id: \.self) { result in
                    if result.name != nil {
                        Text(result.name!).searchCompletion(result.name!)
                    }
                }
            }
            .navigationBarTitle(Text(title), displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: {
                        dismiss()
                    }) {
                        Text("Done")
                    }
                )
        }
    }
    
    var searchResults: [T] {
            if searchText.isEmpty {
                return data
        } else {
            return data.filter { $0.name != nil ? $0.name!.contains(searchText) : false }
        }
    }
}

struct SearchSheet_Previews: PreviewProvider {
    @State static var authors: [Author] = []
    
    static var previews: some View {
        SearchSheet<Author>(title: "Search for Something", selectedData: $authors)
    }
}
