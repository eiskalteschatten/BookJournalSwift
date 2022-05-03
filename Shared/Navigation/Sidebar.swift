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
    
    #if os(macOS)
    @State private var showAddListButton = false
    #else
    @State private var showAddListButton = true
    #endif
    
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
            
            Section(header:
                HStack {
                    Text("Lists")
                    Spacer()
                    if showAddListButton {
                        Button {
                            // TODO
                        } label : {
                            Image(systemName: "plus.circle")
                                #if os(macOS)
                                .font(.system(size: 15))
                                #else
                                .font(.system(size: 20))
                                .foregroundColor(.accentColor)
                                #endif
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.trailing, 5)
                    }
                }
                #if os(macOS)
                .onHover { _ in
                    showAddListButton.toggle()
                }
                #endif
            ) {
                ForEach(lists.filter { $0.name != nil }) { list in
                    NavigationLink(
                        destination: BookList(
                            predicate: NSPredicate(format: "ANY lists == %@", list),
                            createOptions: BookModelCreateOptions(list: list)
                        ).navigationTitle(list.name ?? ""),
                        tag: list.objectID.uriRepresentation().absoluteString,
                        selection: $screen,
                        label: {
                            Label(list.name ?? "", systemImage: list.icon ?? DEFAULT_LIST_ICON)
                        }
                    )
                    .listItemTint(Color("SidebarTint"))
                    #if os(macOS)
                    .onHover { _ in
                        showAddListButton.toggle()
                    }
                    #endif
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
