//
//  CreateAuthor.swift
//  BookJournal
//
//  Created by Alex Seifert on 18.03.22.
//

import SwiftUI

struct CreateAuthor: View {
    @Binding var screen: AuthorsSearchListScreen?
    
    @State private var name: String = ""
    
    var body: some View {
        Form {
            TextField(
                "Name",
                text: $name
            )
        }
        .navigationBarTitle(Text("Create an Author"), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: {
                    saveAuthor()
                    screen = .home
                }) {
                    Text("Save").bold()
                }
            )
    }
    
    private func saveAuthor() {
        
    }
}

struct CreateAuthor_Previews: PreviewProvider {
    @State static var screen: AuthorsSearchListScreen?
    
    static var previews: some View {
        CreateAuthor(screen: $screen)
    }
}
