//
//  iOSiPadOSBookView.swift
//  BookJournal (iOS)
//
//  Created by Alex Seifert on 03.04.22.
//

import SwiftUI

struct iOSBookViewWrapper: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var globalViewModel: GlobalViewModel
    
    @State private var showEditBookSheet = false
    @State private var presentDeleteAlert = false
    
    var body: some View {
        Group {
            if globalViewModel.selectedBook != nil {
                if horizontalSizeClass == .regular && verticalSizeClass == .regular {
                    iPadOSBookView(showEditBookSheet: $showEditBookSheet)
                }
                else {
                    iOSBookView(showEditBookSheet: $showEditBookSheet)
                }
            }
            else {
                NoBookSelected()
            }
        }
        .alert("Are you sure you want to delete this book?", isPresented: $presentDeleteAlert, actions: {
            Button("No", role: .cancel, action: { presentDeleteAlert = false })
            Button("Yes", role: .destructive, action: { deleteBook() })
        }, message: {
            Text("This is permanent.")
        })
        .toolbar {
            ToolbarItem {
                Menu {
                    Button(action: { showEditBookSheet.toggle() }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Divider()
                    Button(role: .destructive) { presentDeleteAlert.toggle() } label: {
                        Label("Delete", systemImage: "trash")
                    }
                 } label: {
                     Image(systemName: "ellipsis.circle")
                 }
            }
        }
    }
    
    private func deleteBook() {
        withAnimation {
            if let unwrappedBook = globalViewModel.selectedBook {
                globalViewModel.selectedBook = nil
                viewContext.delete(unwrappedBook)
                
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
}

struct iOSBookViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        iOSBookViewWrapper()
    }
}
