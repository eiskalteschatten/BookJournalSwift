//
//  SearchListNamedElement.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

enum SearchListNamedElementScreen: Int {
    case home, edit
}

struct SearchListNamedElement<T: AbstractName>: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    #if os(macOS)
    @State private var showEditSheet = false
    #else
    @State private var screen: SearchListNamedElementScreen? = .home
    @State private var presentDeleteAlert = false
    #endif
    
    var title: String
    @Binding var selectedDataArray: [T]
    @Binding var selectedData: T?
    var createTitle: String
    var editTitle: String
    
    private var singleSelection = false
    @State private var searchText = ""
    @State private var elementToEdit: T?
    
    @FetchRequest(
        entity: T.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \T.name, ascending: true)]
    ) private var data: FetchedResults<T>
    
    init(
        title: String,
        selectedData: Binding<[T]>,
        createTitle: String,
        editTitle: String
    ) {
        self.title = title
        self._selectedDataArray = selectedData
        self._selectedData = Binding.constant(nil)
        self.createTitle = createTitle
        self.editTitle = editTitle
    }
    
    init(
        title: String,
        selectedData: Binding<T?>,
        createTitle: String,
        editTitle: String
    ) {
        self.title = title
        self._selectedDataArray = Binding.constant([])
        self._selectedData = selectedData
        self.singleSelection = true
        self.createTitle = createTitle
        self.editTitle = editTitle
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
                
                Button(action: { showEditSheet.toggle() }, label: {
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
                            
                            #if os(macOS)
                            if item != searchResults.last {
                                Divider()
                                    .padding(.leading, 23)
                            }
                            #endif
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
                        .contextMenu {
                            Button("Edit \"\(item.name ?? "")\"", action: {
                                elementToEdit = item
                                
                                #if os(macOS)
                                showEditSheet.toggle()
                                #else
                                screen = .edit
                                #endif
                            })
                            Divider()
                            Button("Delete \"\(item.name ?? "")\"", role: .destructive, action: {
                                elementToEdit = item
                                
                                #if os(macOS)
                                EditNamedElementViewModel<T>.promptToDeleteElement(item)
                                #else
                                presentDeleteAlert.toggle()
                                #endif
                            })
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
                        destination: EditNamedElement<T>(createTitle: createTitle, editTitle: editTitle, screen: $screen, element: elementToEdit),
                        tag: SearchListNamedElementScreen.edit,
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
            .alert("Are you sure you want to delete this item?", isPresented: $presentDeleteAlert, actions: {
                Button("No", role: .cancel, action: { presentDeleteAlert = false })
                Button("Yes", role: .destructive, action: {
                    if let unwrappedElement = elementToEdit {
                        EditNamedElementViewModel<T>.deleteElement(unwrappedElement)
                        elementToEdit = nil
                    }
                })
            }, message: {
                Text("No books will be deleted.")
            })
            #else
            .searchable(text: $searchText) {
                ForEach(searchResults, id: \.self) { result in
                    if result.name != nil {
                        Text(result.name!).searchCompletion(result.name!)
                    }
                }
            }
            .sheet(isPresented: $showEditSheet) {
                EditNamedElement<T>(createTitle: createTitle, editTitle: editTitle, showScreen: $showEditSheet, element: elementToEdit)
            }
            .onChange(of: showEditSheet) { show in
                if !show {
                    elementToEdit = nil
                }
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
            createTitle: "Create an Author",
            editTitle: "Edit Author"
        )
    }
}
