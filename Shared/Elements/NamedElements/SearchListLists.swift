//
//  SearchListLists.swift
//  BookJournal
//
//  Created by Alex Seifert on 04.05.22.
//

import SwiftUI

struct SearchListLists: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var selectedData: [ListOfBooks]
    
    @State private var searchText = ""
    @State private var listToEdit: ListOfBooks?
    
    #if os(macOS)
    @State private var showEditSheet = false
    #else
    @State private var screen: SearchListNamedElementScreen? = .home
    @State private var presentDeleteAlert = false
    #endif
    
    @FetchRequest(
        entity: ListOfBooks.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ListOfBooks.name, ascending: true)]
    ) private var lists: FetchedResults<ListOfBooks>
    
    var body: some View {
        VStack(alignment: .leading) {
            #if os(macOS)
            HStack {
                Text("Lists")
                
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
                                if selectedData.contains(item) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.accentColor)
                                }
                                else {
                                    Image(systemName: "circle")
                                }

                                Label(item.name!, systemImage: item.icon ?? DEFAULT_LIST_ICON)
                            }
                            
                            #if os(macOS)
                            if item != searchResults.last {
                                Divider()
                                    .padding(.leading, 23)
                            }
                            #endif
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
                            
                            #if os(iOS)
                            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                            impactHeavy.impactOccurred()
                            #endif
                        }
                        .contextMenu {
                            Button("Edit \"\(item.name ?? "")\"", action: {
                                listToEdit = item
                                
                                #if os(macOS)
                                showEditSheet.toggle()
                                #else
                                screen = .edit
                                #endif
                            })
                            Divider()
                            Button("Delete \"\(item.name ?? "")\"", role: .destructive, action: {
                                listToEdit = item
                                
                                #if os(macOS)
                                EditListViewModel.promptToDeleteList(item)
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
            .navigationBarTitle(Text("Lists"), displayMode: .inline)
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
                        destination: EditList(screen: $screen, list: listToEdit),
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
            .alert("Are you sure you want to delete this list?", isPresented: $presentDeleteAlert, actions: {
                Button("No", role: .cancel, action: { presentDeleteAlert = false })
                Button("Yes", role: .destructive, action: {
                    if let unwrappedList = listToEdit {
                        EditListViewModel.deleteList(unwrappedList)
                        listToEdit = nil
                    }
                })
            }, message: {
                Text("Any books inside this list will not be deleted.")
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
                EditList(showScreen: $showEditSheet, list: listToEdit)
            }
            .onChange(of: showEditSheet) { show in
                if !show {
                    listToEdit = nil
                }
            }
            #endif
        }
    }
    
    private var searchResults: [ListOfBooks] {
        let dataArray = lists.map { $0 }
        
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
            offsets.map { lists[$0] }.forEach(viewContext.delete)

            offsets.map { lists[$0] }.forEach { item in
                let index = selectedData.firstIndex(of: item)
                if index != nil {
                    selectedData.remove(at: index!)
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

struct SearchListLists_Previews: PreviewProvider {
    @State static var lists: [ListOfBooks] = []
    
    static var previews: some View {
        SearchListLists(selectedData: $lists)
    }
}
