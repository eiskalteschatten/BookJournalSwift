//
//  GenresSearchList.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

enum GenresSearchListScreen: Int {
    case home, create
}

struct GenresSearchList: View {
    @State private var screen: GenresSearchListScreen? = .home
    
    @Environment(\.managedObjectContext) private var viewContext
    
    #if os(macOS)
    @State private var showCreateSheet = false
    #endif
    
    var title = "Genres"
    @Binding var selectedItems: [Genre]
    
    @FetchRequest(
        entity: Genre.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Genre.name, ascending: false)]
    ) private var genres: FetchedResults<Genre>
    
    var body: some View {
        SearchList<Genre>(
            title: title,
            data: genres.map { $0 },
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
                    destination: CreateGenre(screen: $screen),
                    tag: GenresSearchListScreen.create,
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
            CreateGenre(showScreen: $showCreateSheet)
        }
        #endif
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            offsets.map { genres[$0] }.forEach(viewContext.delete)
            
            offsets.map { genres[$0] }.forEach { item in
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

struct GenresSearchList_Previews: PreviewProvider {
    @State static var items: [Genre] = []
    
    static var previews: some View {
        GenresSearchList(selectedItems: $items)
    }
}
