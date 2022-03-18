//
//  CreateTranslator.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct CreateTranslator: View {
    @Binding var screen: TranslatorsSearchListScreen?
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var name: String = ""
    
    var body: some View {
        Form {
            TextField(
                "Name",
                text: $name
            )
        }
        .navigationBarTitle(Text("Create a Translator"), displayMode: .inline)
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
        let newTranslator = Translator(context: viewContext)
        newTranslator.createdAt = Date()
        newTranslator.updatedAt = Date()
        newTranslator.name = name
        
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

struct CreateTranslator_Previews: PreviewProvider {
    @State static var screen: TranslatorsSearchListScreen?
    
    static var previews: some View {
        CreateTranslator(screen: $screen)
    }
}
