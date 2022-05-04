//
//  SidebarLists.swift
//  BookJournal
//
//  Created by Alex Seifert on 03.05.22.
//

import SwiftUI

struct SidebarLists: View {
    @ObservedObject var sidebarViewModel: SidebarViewModel
    
    @FetchRequest(
        entity: ListOfBooks.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ListOfBooks.name, ascending: true)]
    ) private var lists: FetchedResults<ListOfBooks>
    
    var body: some View {
        Section(header: SectionHeader(sidebarViewModel: sidebarViewModel)) {
            ForEach(lists.filter { $0.name != nil }) { list in
                NavigationLink(
                    destination: BookList(
                        predicate: NSPredicate(format: "ANY lists == %@", list),
                        createOptions: BookModelCreateOptions(list: list)
                    ).navigationTitle(list.name ?? ""),
                    tag: list.objectID.uriRepresentation().absoluteString,
                    selection: $sidebarViewModel.screen,
                    label: {
                        Label(list.name ?? "", systemImage: !(list.icon ?? "").isEmpty ? list.icon! : DEFAULT_LIST_ICON)
                    }
                )
                .listItemTint(Color("SidebarTint"))
                .contextMenu {
                    Button("Edit \"\(list.name ?? "")\"", action: {
                        
                    })
                    Divider()
                    Button("Delete \"\(list.name ?? "")\"", role: .destructive, action: {
                        
                    })
                }
            }
        }
    }
}

fileprivate struct SectionHeader: View {
    @ObservedObject var sidebarViewModel: SidebarViewModel
    
    #if os(macOS)
    @State private var showAddListButton = false
    #else
    @State private var showAddListButton = true
    #endif
    
    var body: some View {
        HStack {
            Text("Lists")
            
            Spacer()
            
            if showAddListButton {
                Button {
                    sidebarViewModel.showCreateSheet.toggle()
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
    @StateObject static var sidebarViewModel = SidebarViewModel()
    
    static var previews: some View {
        SidebarLists(sidebarViewModel: sidebarViewModel)
    }
}
