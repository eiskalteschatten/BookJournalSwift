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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) { item in
                    HStack {
                        if item.name != nil {
                            if selectedData.contains(item) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.yellow)
                            }
                            else {
                                Image(systemName: "circle")
                            }

                            Text(item.name!)
                        }
                    }
                    .onTapGesture {
                        if selectedData.contains(item) {
                            if let index = selectedData.firstIndex(of: item) {
                                selectedData.remove(at: index)
                            }
                        }
                        else {
                            selectedData.append(item)
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
    static let context = PersistenceController.preview.container.viewContext
    
    static var previews: some View {
        SearchSheet<Author>(title: "Search for Something", data: getMockAuthors(), selectedData: $authors)
    }
    
    static func getMockAuthors() -> [Author] {
        let mockAuthor1 = Author(context: context)
        mockAuthor1.name = "Liz"
        
        let mockAuthor2 = Author(context: context)
        mockAuthor2.name = "Scott"
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return [mockAuthor1, mockAuthor2]
    }
}
