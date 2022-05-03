//
//  BookRating.swift
//  BookJournal
//
//  Created by Alex Seifert on 03.04.22.
//

import SwiftUI

struct BookRating: View {
    @ObservedObject var book: Book
    
    var body: some View {
        let starSize = 20.0
        let totalStars: Int16 = 5
        let totalUnfilledStars: Int16 = totalStars - book.rating
        let totalFilledStars: Int16 = totalStars - totalUnfilledStars
        
        HStack {
            if totalFilledStars > 0 {
                ForEach(1...totalFilledStars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: starSize, height: starSize)
                        .foregroundColor(.yellow)
                    
                }
            }
            
            if totalUnfilledStars > 0 {
                ForEach(1...totalUnfilledStars, id: \.self) { _ in
                    Image(systemName: "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: starSize, height: starSize)
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}

struct BookRating_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = context.registeredObjects.first(where: { $0 is Book }) as! Book
        
        BookRating(book: book)
    }
}
