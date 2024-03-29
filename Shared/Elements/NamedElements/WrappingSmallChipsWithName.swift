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
    var book: Book?
    
    @FetchRequest private var data: FetchedResults<T>
    
    init(
        book: Book? = nil,
        title: String? = nil,
        chipColor: Color = .gray,
        alignment: HorizontalAlignment = .center
    ) {
        self._data = FetchRequest<T>(
            sortDescriptors: [SortDescriptor(\T.name, order: .forward)],
            predicate: book != nil ? NSPredicate(format: "ANY books == %@", book!) : nil,
            animation: .default
        )
        self.book = book
        self.title = title
        self.chipColor = chipColor
        self.alignment = alignment
    }
    
    var body: some View {
        VStack(alignment: alignment, spacing: 1) {
            if title != nil {
                Text(title!)
            }
            
            if book != nil && data.count > 0 {
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

struct WrappingSmallChipsWithName_Previews: PreviewProvider {
    static var previews: some View {
        WrappingSmallChipsWithName<Author>(title: "Test Link")
    }
}
