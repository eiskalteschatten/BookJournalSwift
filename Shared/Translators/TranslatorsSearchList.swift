//
//  TranslatorsSearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

enum TranslatorsSearchListScreen: Int {
    case home, create
}

struct TranslatorsSearchList: View {
    @State private var screen: TranslatorsSearchListScreen? = .home
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var selectedItems: [Translator]
    
    @FetchRequest(
        entity: Translator.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Translator.name, ascending: false)]
    ) private var translators: FetchedResults<Translator>
    
    var body: some View {
        SearchList<Translator>(
            title: "Search Translators",
            data: translators.map { $0 },
            selectedData: $selectedItems,
            onDelete: delete
        )
        #if os(iOS)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: CreateTranslator(screen: $screen),
                    tag: TranslatorsSearchListScreen.create,
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
        #endif
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            offsets.map { translators[$0] }.forEach(viewContext.delete)
            
            offsets.map { translators[$0] }.forEach { item in
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

struct TranslatorsSearchList_Previews: PreviewProvider {
    @State static var items: [Translator] = []
    
    static var previews: some View {
        TranslatorsSearchList(selectedItems: $items)
    }
}
