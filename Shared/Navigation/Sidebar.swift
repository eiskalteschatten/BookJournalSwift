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
    @State private var screen: String?
    
    @FetchRequest(
        entity: ListOfBooks.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ListOfBooks.name, ascending: false)]
    ) private var lists: FetchedResults<ListOfBooks>
    
    var body: some View {
        List {
            Section("Library") {
                NavigationLink(
                    destination: BookList().navigationTitle("All Books"),
                    tag: "allBooks",
                    selection: $screen,
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
                    selection: $screen,
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
                    selection: $screen,
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
                    selection: $screen,
                    label: {
                        Label("Books Read", systemImage: "checkmark.square")
                    }
                )
                .listItemTint(Color("SidebarTint"))
            }
            
            Section("Lists") {
                ForEach(lists.filter { $0.name != nil }) { list in
                    NavigationLink(
                        destination: BookList(
                            predicate: NSPredicate(format: "ANY lists == %@", list),
                            createOptions: BookModelCreateOptions(list: list)
                        ).navigationTitle(list.name ?? ""),
                        tag: list.objectID.uriRepresentation().absoluteString,
                        selection: $screen,
                        label: {
                            if let icon = list.icon {
                                Label(list.name ?? "", systemImage: icon)
                            }
                            else {
                                Text(list.name ?? "")
                            }
                        }
                    )
                    .listItemTint(Color("SidebarTint"))
                }
            }
        }
        .listStyle(SidebarListStyle())
        .onChange(of: screen) { newScreen in
            defaults.set(newScreen, forKey: sidebarScreenKey)
        }
        .onAppear {
            if let restoredScreen = defaults.string(forKey: sidebarScreenKey) as String? {
                screen = restoredScreen
            }
        }
        #if os(iOS)
        .navigationBarTitle("BookJournal")
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
