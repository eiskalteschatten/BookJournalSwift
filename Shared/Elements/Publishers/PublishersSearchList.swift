//
//  PublishersSearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

enum PublishersSearchListScreen: Int {
    case home, create
}

struct PublishersSearchList: View {
    @State private var screen: PublishersSearchListScreen? = .home
    
    @Environment(\.managedObjectContext) private var viewContext
    
    #if os(macOS)
    @State private var showCreateSheet = false
    #endif
    
    var title = "Publishers"
    @Binding var selectedItem: Publisher?
    
    @FetchRequest(
        entity: Publisher.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Publisher.name, ascending: false)]
    ) private var publishers: FetchedResults<Publisher>
    
    var body: some View {
        SearchList<Publisher>(
            title: title,
            data: publishers.map { $0 },
            selectedData: $selectedItem,
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
                    destination: CreatePublisher(screen: $screen),
                    tag: PublishersSearchListScreen.create,
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
            CreatePublisher(showScreen: $showCreateSheet)
        }
        #endif
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            offsets.map { publishers[$0] }.forEach(viewContext.delete)
            selectedItem = nil

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

struct PublishersSearchList_Previews: PreviewProvider {
    @State static var item: Publisher?
    
    static var previews: some View {
        PublishersSearchList(selectedItem: $item)
    }
}