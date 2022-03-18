//
//  SearchSheet.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct SearchSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var title: String
    
    @State private var searchText = ""
    
    // TODO: replace with real items passed into this component
    private let authors = ["Holly", "Josh", "Rhonda", "Ted"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { author in
                    NavigationLink(destination: Text(author)) {
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
    static var previews: some View {
        SearchSheet(title: "Search for Something")
    }
}
