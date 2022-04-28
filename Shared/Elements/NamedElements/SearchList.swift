//
//  SearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

enum SearchListScreen: Int {
    case home, create
}

struct SearchList<T: AbstractName>: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var screen: SearchListScreen? = .home
    
    #if os(macOS)
    @State private var showCreateSheet = false
    #endif
    
    var title: String
    var data: [T]
    @Binding var selectedDataArray: [T]
    @Binding var selectedData: T?
    var createEntity: () -> T
    
    private var singleSelection = false
    @State private var searchText = ""
    
    init(
        title: String,
        data: [T],
        selectedData: Binding<[T]>
    ) {
        self.title = title
        self.data = data
        self._selectedDataArray = selectedData
        self._selectedData = Binding.constant(nil)
    }
    
    init(
        title: String,
        data: [T],
        selectedData: Binding<T?>
    ) {
        self.title = title
        self.data = data
        self._selectedDataArray = Binding.constant([])
        self._selectedData = selectedData
        self.singleSelection = true
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            #if os(macOS)
            HStack {
                Text(title)
                
                Spacer()
                
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 200)
                
                Button(action: { showCreateSheet.toggle() }, label: {
                    Image(systemName: "plus")
                })
                .buttonStyle(.plain)
            }
            #endif
            
            List {
                ForEach(searchResults, id: \.self) { item in
                    if item.name != nil {
                        VStack(alignment: .leading) {
                            HStack {
                                if singleSelection {
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
                            .onTapGesture {
                                if singleSelection {
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
                .onDelete(perform: delete)
                
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: CreateNamedElement<Author>(createEntity: createEntity, title: "Create an Author", screen: $screen),
                        tag: SearchListScreen.create,
                        selection: $screen,
                        label: {
                            Image(systemName: "plus")
                        }
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
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
            .sheet(isPresented: $showCreateSheet) {
                CreateNamedElement<Author>(createEntity: createEntity, title: "Create an Author", showScreen: $showCreateSheet)
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
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            offsets.map { data[$0] }.forEach(viewContext.delete)

            offsets.map { data[$0] }.forEach { item in
                let index = selectedItems.firstIndex(of: item)
                if index != nil {
                    selectedItems.remove(at: index!)
                }
            }

            do {
                try viewContext.save()
            } catch {
                // TODO: Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct SearchList_Previews: PreviewProvider {
    @State static var authors: [Author] = []
    static let viewContext = PersistenceController.preview.container.viewContext
    static func addItem() {}
    
    static var previews: some View {
        SearchList<Author>(
            title: "Search for Something",
            data: getMockAuthors(),
            selectedData: $authors,
            createEntity: createEntity
        )
    }
    
    static func getMockAuthors() -> [Author] {
        let mockAuthor1 = Author(context: viewContext)
        mockAuthor1.name = "Liz"
        
        let mockAuthor2 = Author(context: viewContext)
        mockAuthor2.name = "Scott"
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return [mockAuthor1, mockAuthor2]
    }
    
    static private func createEntity() -> Author {
        return Author(context: viewContext)
    }
}
