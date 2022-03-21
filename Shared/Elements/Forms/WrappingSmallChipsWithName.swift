//
//  WrappingSmallChipsWithName.swift
//  BookJournal
//
//  Created by Alex Seifert on 19.03.22.
//

import SwiftUI
import WrappingHStack

struct WrappingSmallChipsWithName<T: AbstractName>: View {
    var title: String?
    var data: [T]
    var chipColor: Color = .gray
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            if title != nil {
                Text(title!)
            }
            
            if data.count > 0 {
                Spacer()
                
                WrappingHStack(data, id: \.self) { item in
                    SmallChip(background: chipColor) {
                        HStack(alignment: .center, spacing: 4) {
                            if let name = item.name {
                                Text(name)
                            }
                        }
                    }
                    .padding(.horizontal, 1)
                    .padding(.vertical, 3)
                }
                .frame(minWidth: 250)
            }
        }
    }
}

struct WrappingSmallChipsWithName_Previews: PreviewProvider {
    @State static var authors: [Author] = []
    static let context = PersistenceController.preview.container.viewContext
    
    static var previews: some View {
        WrappingSmallChipsWithName(title: "Test Link", data: getMockAuthors())
    }
    
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
