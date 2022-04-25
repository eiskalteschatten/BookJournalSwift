//
//  SearchListSingleSelect.swift
//  BookJournal
//
//  Created by Alex Seifert on 25.04.22.
//

import SwiftUI

struct SearchListSingleSelect<T: AbstractName>: View {
    @Environment(\.dismiss) var dismiss
    
    var title: String
    var data: [T]
    @Binding var selectedData: T?
    var addElementMac: (() -> Void)?
    var onDelete: (_: IndexSet) -> Void
    
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            #if os(macOS)
            HStack {
                Text(title)
                
                Spacer()
                
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 200)
                
                if addElementMac != nil {
                    Button(action: addElementMac!, label: {
                        Image(systemName: "plus")
                    })
                    .buttonStyle(.plain)
                }
            }
            #endif
            
            List {
                ForEach(searchResults, id: \.self) { item in
                    if item.name != nil {
                        VStack(alignment: .leading) {
                            HStack {
                                if selectedData == item {
                                    Image(systemName: "circle.inset.filled")
                                        .foregroundColor(.accentColor)
                                }
                                else {
                                    Image(systemName: "circle")
                                }

                                Text(item.name!)
                            }
                            .onTapGesture {
                                selectedData = selectedData == item ? nil : item
                                
                                #if os(iOS)
                                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                                impactHeavy.impactOccurred()
                                #endif
                            }
                            
                            #if os(macOS)
                            if item != searchResults.last {
                                Divider()
                                    .padding(.leading, 23)
                            }
                            #endif
                        }
                    }
                }
                .onDelete(perform: onDelete)
                
            }
            .listStyle(.plain)
            #if os(iOS)
            .navigationBarTitle(Text(title), displayMode: .inline)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always)) {
                ForEach(searchResults, id: \.self) { result in
                    if result.name != nil {
                        Text(result.name!).searchCompletion(result.name!)
                    }
                }
            }
            #else
            .searchable(text: $searchText) {
                ForEach(searchResults, id: \.self) { result in
                    if result.name != nil {
                        Text(result.name!).searchCompletion(result.name!)
                    }
                }
            }
            #endif
        }
    }
    
    private var searchResults: [T] {
        if searchText.isEmpty {
            return data
        }
        else {
            return data.filter {
                $0.name != nil
                    ? $0.name!.lowercased().contains(searchText.lowercased())
                    : false
            }
        }
    }
}

struct SearchListSingleSelect_Previews: PreviewProvider {
    @State static var author: Author?
    static let context = PersistenceController.preview.container.viewContext
    static func addItem() {}
    
    static var previews: some View {
        SearchListSingleSelect<Author>(
            title: "Search for Something",
            data: getMockAuthors(),
            selectedData: $author,
            addElementMac: addElementMac,
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
    
    static func addElementMac() {}
    static func deleteAuthors(offsets: IndexSet) {}
}
