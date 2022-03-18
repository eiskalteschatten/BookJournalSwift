//
//  CreatePublisher.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct CreatePublisher: View {
    @Binding var screen: PublishersSearchListScreen?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var name: String = ""
    
    var body: some View {
        Form {
            TextField(
                "Name",
                text: $name
            )
        }
        .navigationBarTitle(Text("Create a Publisher"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    save()
                    screen = .home
                }) {
                    Text("Save").bold()
                }
            )
    }
    
    private func save() {
        let newPublisher = Publisher(context: viewContext)
        newPublisher.createdAt = Date()
        newPublisher.updatedAt = Date()
        newPublisher.name = name
        
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

struct CreatePublisher_Previews: PreviewProvider {
    @State static var screen: PublishersSearchListScreen?
    
    static var previews: some View {
        CreatePublisher(screen: $screen)
    }
}
