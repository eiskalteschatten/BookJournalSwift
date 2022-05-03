//
//  SidebarLists.swift
//  BookJournal
//
//  Created by Alex Seifert on 03.05.22.
//

import SwiftUI

struct SidebarLists: View {
    @Binding var screen: String?
    
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
        Section(header: SectionHeader(showAddListButton: $showAddListButton)) {
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
}

fileprivate struct SectionHeader: View {
    @Binding var showAddListButton: Bool
    
    var body: some View {
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
    }
}

struct SidebarLists_Previews: PreviewProvider {
    @State static private var screen: String?
    
    static var previews: some View {
        SidebarLists(screen: $screen)
    }
}
