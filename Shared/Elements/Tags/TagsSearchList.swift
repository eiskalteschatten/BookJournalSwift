//
//  TagsSearchList.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

enum TagsSearchListScreen: Int {
    case home, create
}

struct TagsSearchList: View {
    @State private var screen: TagsSearchListScreen? = .home
    
    @Environment(\.managedObjectContext) private var viewContext
    
    #if os(macOS)
    @State private var showCreateSheet = false
    #endif
    
    var title = "Tags"
    @Binding var selectedItems: [Tag]
    
    @FetchRequest(
        entity: Tag.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.name, ascending: false)]
    ) private var tags: FetchedResults<Tag>
    
    var body: some View {
        SearchList<Tag>(
            title: title,
            data: tags.map { $0 },
            selectedData: $selectedItems,
            addElementMac: {
                #if os(macOS)
                showCreateSheet.toggle()
                #endif
            },
            onDelete: delete
        )
        #if os(iOS)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: CreateTag(screen: $screen),
                    tag: TagsSearchListScreen.create,
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
        .sheet(isPresented: $showCreateSheet) {
            CreateTag(showScreen: $showCreateSheet)
        }
        #endif
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            offsets.map { tags[$0] }.forEach(viewContext.delete)
            
            offsets.map { tags[$0] }.forEach { item in
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

struct TagsSearchList_Previews: PreviewProvider {
    @State static var items: [Tag] = []
    
    static var previews: some View {
        TagsSearchList(selectedItems: $items)
    }
}