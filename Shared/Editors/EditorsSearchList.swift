//
//  EditorsSearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

enum EditorsSearchListScreen: Int {
    case home, create
}

struct EditorsSearchList: View {
    @State private var screen: EditorsSearchListScreen? = .home
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var selectedEditors: [Editor]
    
    @FetchRequest(
        entity: Editor.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Editor.name, ascending: false)]
    ) private var editors: FetchedResults<Editor>
    
    var body: some View {
        SearchList<Editor>(
            title: "Search Editors",
            data: editors.map { $0 },
            selectedData: $selectedEditors,
            onDelete: deleteEditors
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: CreateEditor(screen: $screen),
                    tag: EditorsSearchListScreen.create,
                    selection: $screen,
                    label: {
                        Image(systemName: "plus")
                    }
                )
            }
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            #endif
        }
    }
    
    private func deleteEditors(offsets: IndexSet) {
        withAnimation {
            offsets.map { editors[$0] }.forEach(viewContext.delete)
            offsets.forEach { i in selectedEditors.remove(at: i) }

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

struct EditorsSearchList_Previews: PreviewProvider {
    @State static var editors: [Editor] = []
    
    static var previews: some View {
        EditorsSearchList(selectedEditors: $editors)
    }
}
