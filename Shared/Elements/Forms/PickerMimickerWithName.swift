//
//  PickerMimickerWithName.swift
//  BookJournal
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI

struct PickerMimickerWithName<T: AbstractName>: View {
    var title: String
    var data: T?
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            
            if data != nil {
                if let name = data!.name {
                    Text(name).opacity(0.5)
                }
            }
        }
    }
}

struct PickerMimickerWithName_Previews: PreviewProvider {
    @State static var authors: Author?
    static let context = PersistenceController.preview.container.viewContext
    
    static var previews: some View {
        PickerMimickerWithName(title: "Test Link", data: getMockAuthors())
    }
    
    static func getMockAuthors() -> Author {
        let mockAuthor1 = Author(context: context)
        mockAuthor1.name = "Liz"
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return mockAuthor1
    }
}
