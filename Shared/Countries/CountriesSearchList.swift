//
//  CountriesSearchList.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

enum CountriesSearchListScreen: Int {
    case home, create
}

struct CountriesSearchList: View {
    @State private var screen: CountriesSearchListScreen? = .home
    
    @Environment(\.managedObjectContext) private var viewContext
    
    #if os(macOS)
    @State private var showCreateSheet = false
    #endif
    
    var title = "Countries"
    @Binding var selectedItem: Country?
    
    @FetchRequest(
        entity: Country.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Country.name, ascending: false)]
    ) private var countries: FetchedResults<Country>
    
    var body: some View {
        SearchList<Country>(
            title: title,
            data: countries.map { $0 },
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
                    destination: CreateCountry(screen: $screen),
                    tag: CountriesSearchListScreen.create,
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
            CreateCountry(showScreen: $showCreateSheet)
        }
        #endif
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            offsets.map { countries[$0] }.forEach(viewContext.delete)
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

struct CountriesSearchList_Previews: PreviewProvider {
    @State static var item: Country?
    
    static var previews: some View {
        CountriesSearchList(selectedItem: $item)
    }
}
