//
//  CategoriesSearchList.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

enum CategoriesSearchListScreen: Int {
    case home, create
}

struct CategoriesSearchList: View {
    @State private var screen: CategoriesSearchListScreen? = .home
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var selectedItems: [Category]
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: false)]
    ) private var categories: FetchedResults<Category>
    
    var body: some View {
        SearchList<Category>(
            title: "Search Categories",
            data: categories.map { $0 },
            selectedData: $selectedItems,
            onDelete: delete
        )
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: CreateCategory(screen: $screen),
                    tag: CategoriesSearchListScreen.create,
                    selection: $screen,
                    label: {
                        Image(systemName: "plus")
                    }
                )
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            #endif
        }
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            offsets.map { categories[$0] }.forEach(viewContext.delete)
            offsets.forEach { i in selectedItems.remove(at: i) }

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

struct CategoriesSearchList_Previews: PreviewProvider {
    @State static var items: [Category] = []
    
    static var previews: some View {
        CategoriesSearchList(selectedItems: $items)
    }
}