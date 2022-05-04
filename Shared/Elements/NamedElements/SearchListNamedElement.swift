//
//  SearchListNamedElement.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

enum SearchListNamedElementScreen: Int {
    case home, create
}

struct SearchListNamedElement<T: AbstractName>: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    #if os(macOS)
    @State private var showCreateSheet = false
    #else
    @State private var screen: SearchListNamedElementScreen? = .home
    #endif
    
    var title: String
    @Binding var selectedDataArray: [T]
    @Binding var selectedData: T?
    var createTitle: String
    
    private var singleSelection = false
    @State private var searchText = ""
    
    @FetchRequest(
        entity: T.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \T.name, ascending: true)]
    ) private var data: FetchedResults<T>
    
    init(
        title: String,
        selectedData: Binding<[T]>,
        createTitle: String
    ) {
        self.title = title
        self._selectedDataArray = selectedData
        self._selectedData = Binding.constant(nil)
        self.createTitle = createTitle
    }
    
    init(
        title: String,
        selectedData: Binding<T?>,
        createTitle: String
    ) {
        self.title = title
        self._selectedDataArray = Binding.constant([])
        self._selectedData = selectedData
        self.singleSelection = true
        self.createTitle = createTitle
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
                        destination: CreateNamedElement<T>(title: createTitle, screen: $screen),
                        tag: SearchListNamedElementScreen.create,
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
                CreateNamedElement<T>(title: createTitle, showScreen: $showCreateSheet)
            }
            #endif
        }
    }
    
    private var searchResults: [T] {
        let dataArray = data.map { $0 }
        
        if searchText.isEmpty {
            return dataArray
        }
        else {
            return dataArray.filter {
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
                if singleSelection && selectedData == item {
                    selectedData = nil
                }
                else {
                    let index = selectedDataArray.firstIndex(of: item)
                    if index != nil {
                        selectedDataArray.remove(at: index!)
                    }
                }
            }

            do {
                try viewContext.save()
            } catch {
                handleCoreDataError(error as NSError)
            }
        }
    }
}

struct SearchListNamedElement_Previews: PreviewProvider {
    @State static var authors: [Author] = []
    static let viewContext = PersistenceController.preview.container.viewContext
    static func addItem() {}
    
    static var previews: some View {
        SearchListNamedElement<Author>(
            title: "Search for Something",
            selectedData: $authors,
            createTitle: "Create an Author"
        )
    }
}
