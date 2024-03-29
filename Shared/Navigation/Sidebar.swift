//
//  Sidebar.swift
//  BookJournal
//
//  Created by Alex Seifert on 02.05.22.
//

import SwiftUI

struct Sidebar: View {
    private let defaults = UserDefaults.standard
    private let sidebarScreenKey = "Sidebar.screen"
    
    @StateObject private var sidebarViewModel = SidebarViewModel()
    
    var body: some View {
        List {
            Section("Library") {
                NavigationLink(
                    destination: BookList().navigationTitle("All Books"),
                    tag: "allBooks",
                    selection: $sidebarViewModel.screen,
                    label: {
                        Label("All Books", systemImage: "books.vertical")
                    }
                )
                .listItemTint(Color("SidebarTint"))
                
                NavigationLink(
                    destination: BookList(
                        predicate: NSPredicate(format: "readingStatus == %@", BookReadingStatus.currentlyReading.rawValue),
                        createOptions: BookModelCreateOptions(readingStatus: .currentlyReading)
                    ).navigationTitle("Currently Reading"),
                    tag: BookReadingStatus.currentlyReading.rawValue,
                    selection: $sidebarViewModel.screen,
                    label: {
                        Label("Currently Reading", systemImage: "book")
                    }
                )
                .listItemTint(Color("SidebarTint"))
                
                NavigationLink(
                    destination: BookList(
                        predicate: NSPredicate(format: "readingStatus == %@", BookReadingStatus.notReadYet.rawValue),
                        createOptions: BookModelCreateOptions(readingStatus: .notReadYet)
                    ).navigationTitle("Not Read Yet"),
                    tag: BookReadingStatus.notReadYet.rawValue,
                    selection: $sidebarViewModel.screen,
                    label: {
                        Label("Not Read Yet", systemImage: "book.closed")
                    }
                )
                .listItemTint(Color("SidebarTint"))
                
                NavigationLink(
                    destination: BookList(
                          predicate: NSPredicate(format: "readingStatus == %@", BookReadingStatus.read.rawValue),
                          createOptions: BookModelCreateOptions(readingStatus: .read)
                    ).navigationTitle("Books Read"),
                    tag: BookReadingStatus.read.rawValue,
                    selection: $sidebarViewModel.screen,
                    label: {
                        Label("Books Read", systemImage: "checkmark.square")
                    }
                )
                .listItemTint(Color("SidebarTint"))
            }
            
            SidebarLists(sidebarViewModel: sidebarViewModel)
        }
        .listStyle(SidebarListStyle())
        .onChange(of: sidebarViewModel.screen) { newScreen in
            defaults.set(newScreen, forKey: sidebarScreenKey)
        }
        .onChange(of: sidebarViewModel.showEditSheet) { show in
            if !show {
                sidebarViewModel.listToEdit = nil
            }
        }
        .onAppear {
            if let restoredScreen = defaults.string(forKey: sidebarScreenKey) as String? {
                sidebarViewModel.screen = restoredScreen
            }
            else {
                GlobalViewModel.shared.selectedBook = nil
            }
        }
        .sheet(isPresented: $sidebarViewModel.showEditSheet) {
            EditList(showScreen: $sidebarViewModel.showEditSheet, list: sidebarViewModel.listToEdit)
        }
        #if os(iOS)
        .navigationBarTitle("BookJournal")
        .alert("Are you sure you want to delete this list?", isPresented: $sidebarViewModel.presentDeleteAlert, actions: {
            Button("No", role: .cancel, action: { sidebarViewModel.presentDeleteAlert = false })
            Button("Yes", role: .destructive, action: {
                if let unwrappedList = sidebarViewModel.listToEdit {
                    EditListViewModel.deleteList(unwrappedList)
                    sidebarViewModel.listToEdit = nil
                }
            })
        }, message: {
            Text("Any books inside this list will not be deleted.")
        })
        #else
        .frame(minWidth: 200)
        #endif
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
