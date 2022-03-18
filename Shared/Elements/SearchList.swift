//
//  SearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct SearchList<T: AbstractName>: View {
    @Environment(\.dismiss) var dismiss
    
    var title: String
    var data: [T]
    @Binding var selectedDataArray: [T]
    @Binding var selectedData: T?
    var onDelete: (_: IndexSet) -> Void
    var singleSelection: Bool? = false
    
    @State private var searchText = ""
    
    init(
        title: String,
        data: [T],
        selectedData: Binding<[T]>,
        onDelete: @escaping (_: IndexSet) -> Void
    ) {
        self.title = title
        self.data = data
        self._selectedDataArray = selectedData
        self._selectedData = Binding.constant(nil)
        self.onDelete = onDelete
        self.singleSelection = false
    }
    
    init(
        title: String,
        data: [T],
        selectedData: Binding<T?>,
        onDelete: @escaping (_: IndexSet) -> Void,
        singleSelection: Bool
    ) {
        self.title = title
        self.data = data
        self._selectedDataArray = Binding.constant([])
        self._selectedData = selectedData
        self.onDelete = onDelete
        self.singleSelection = true
    }
    
    var body: some View {
        List {
            ForEach(searchResults, id: \.self) { item in
                HStack {
                    if item.name != nil {
                        if singleSelection! {
                            if selectedData == item {
                                Image(systemName: "circle.inset.filled")
                                    .foregroundColor(.accentColor)
                            }
                            else {
                                Image(systemName: "circle")
                            }
                        }
                        else {
                            if selectedDataArray.contains(item) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                            }
                            else {
                                Image(systemName: "circle")
                            }
                        }

                        Text(item.name!)
                    }
                }
                .onTapGesture {
                    if singleSelection! {
                        selectedData = selectedData == item ? nil : item
                    }
                    else {
                        if selectedDataArray.contains(item) {
                            if let index = selectedDataArray.firstIndex(of: item) {
                                selectedDataArray.remove(at: index)
                            }
                        }
                        else {
                            selectedDataArray.append(item)
                        }
                    }
                }
            }
            .onDelete(perform: onDelete)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)) {
            ForEach(searchResults, id: \.self) { result in
                if result.name != nil {
                    Text(result.name!).searchCompletion(result.name!)
                }
            }
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

struct SearchList_Previews: PreviewProvider {
    @State static var authors: [Author] = []
    static let context = PersistenceController.preview.container.viewContext
    static func addItem() {}
    
    static var previews: some View {
        SearchList<Author>(
            title: "Search for Something",
            data: getMockAuthors(),
            selectedData: $authors,
            onDelete: deleteAuthors
        )
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
    
    static func deleteAuthors(offsets: IndexSet) {}
}
