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
    var chipColor: Color = .gray
    var alignment: HorizontalAlignment = .center
    
    @FetchRequest private var data: FetchedResults<T>
    
    init(
        book: Book? = nil,
        title: String? = nil,
        chipColor: Color = .gray,
        alignment: HorizontalAlignment = .center
    ) {
        if let unwrappedBook = book {
            self._data = FetchRequest<T>(
                sortDescriptors: [SortDescriptor(\T.name, order: .forward)],
                predicate: NSPredicate(format: "ANY books == %@", unwrappedBook),
                animation: .default
            )
        }
        self.title = title
        self.chipColor = chipColor
        self.alignment = alignment
    }
    
    var body: some View {
        VStack(alignment: alignment, spacing: 1) {
            if title != nil {
                Text(title!)
            }
            
            if data.count > 0 {
                Spacer()
                
                WrappingHStack(data, id: \.self, alignment: alignment) { item in
                    SmallChip(background: chipColor) {
                        HStack(alignment: .center, spacing: 4) {
                            if let name = item.name {
                                Text(name)
                            }
                        }
                    }
                    .padding(.horizontal, 1)
                    .padding(.vertical, 3)
                    .contextMenu {
                        let copyButtonLabel = item.name != nil ? "Copy \"\(item.name!)\"" : "Copy"
                        Button(copyButtonLabel) {
                            if let name = item.name {
                                copyTextToClipboard(name)
                            }
                        }
                        .disabled(item.name == nil)
                    }
                }
                .frame(minWidth: 250)
            }
        }
    }
}

//struct WrappingSmallChipsWithName_Previews: PreviewProvider {
//    @State static var authors: [Author] = []
//    static let context = PersistenceController.preview.container.viewContext
//    
//    static var previews: some View {
//        WrappingSmallChipsWithName(title: "Test Link", data: getMockAuthors())
//    }
//    
//    static func getMockAuthors() -> [Author] {
//        let mockAuthor1 = Author(context: context)
//        mockAuthor1.name = "Liz"
//        
//        let mockAuthor2 = Author(context: context)
//        mockAuthor2.name = "Scott"
//        
//        do {
//            try context.save()
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        
//        return [mockAuthor1, mockAuthor2]
//    }
//}
