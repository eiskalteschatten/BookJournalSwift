//
//  MacChipsEditor.swift
//  BookJournal (macOS)
//
//  Created by Alex Seifert on 21.03.22.
//

import SwiftUI

struct MacChipsEditor<T: AbstractName>: View {
    var title: String
    var data: [T]
    var chipColor: Color
    var editAction: () -> Void
    var minHeight: CGFloat? = 100
    var maxHeight: CGFloat? = 100
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                
                Spacer()
                
                Button("Edit", action: editAction)
            }
            
            GroupBox {
                ScrollView {
                    WrappingSmallChipsWithName<T>(data: data, chipColor: chipColor)
                }
                .frame(maxWidth: .infinity, minHeight: minHeight, maxHeight: maxHeight)
            }
        }
    }
}

struct MacChipsEditor_Previews: PreviewProvider {
    @State static var authors: [Author] = []
    static let context = PersistenceController.preview.container.viewContext
    
    static var previews: some View {
        MacChipsEditor<Author>(title: "Authors", data: getMockAuthors(), chipColor: .blue, editAction: editAction)
    }
    
    static func editAction() {}
    
    static func getMockAuthors() -> [Author] {
        let mockAuthor1 = Author(context: context)
        mockAuthor1.name = "Liz"
        
        let mockAuthor2 = Author(context: context)
        mockAuthor2.name = "Scott"
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return [mockAuthor1, mockAuthor2]
    }
}
