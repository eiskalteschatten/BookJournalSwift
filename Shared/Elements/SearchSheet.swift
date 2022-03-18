//
//  SearchSheet.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct SearchSheet<T>: View {
    @Environment(\.dismiss) var dismiss
    
    var title: String
    @Binding var selectedData: [T]
    
    @State private var searchText = ""
    @State var selectKeeper = Set<String>()
    
    // TODO: replace with real items passed into this component
    private let authors = ["Holly", "Josh", "Rhonda", "Ted"]
    
    var body: some View {
        NavigationView {
            List(selection: $selectKeeper) {
                ForEach(searchResults, id: \.self) { author in
                    HStack {
                        Image(systemName: "circle")
                        
//                        Image(systemName: "checkmark.circle.fill")
//                            .foregroundColor(.yellow)
                        Text(author)
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)) {
                ForEach(searchResults, id: \.self) { result in
                    Text(result).searchCompletion(result)
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
    
    var searchResults: [String] {
            if searchText.isEmpty {
            return authors
        } else {
            return authors.filter { $0.contains(searchText) }
        }
    }
}

struct SearchSheet_Previews: PreviewProvider {
    @State static var authors: [Author] = []
    
    static var previews: some View {
        SearchSheet<Author>(title: "Search for Something", selectedData: $authors)
    }
}
