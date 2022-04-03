//
//  BookViewRating.swift
//  BookJournal
//
//  Created by Alex Seifert on 03.04.22.
//

import SwiftUI

struct BookViewRating: View {
    var rating: Int
    
    var body: some View {
        let totalStars = 5
        let totalUnfilledStars = totalStars - rating
        let totalFilledStars = totalStars - totalUnfilledStars
        
        HStack {
            if totalFilledStars > 0 {
                ForEach(1...totalFilledStars, id: \.self) {_ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
            
            if totalUnfilledStars > 0 {
                ForEach(1...totalUnfilledStars, id: \.self) {_ in
                    Image(systemName: "star")
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}

struct BookViewRating_Previews: PreviewProvider {
    static var previews: some View {
        BookViewRating(rating: 0)
        BookViewRating(rating: 3)
        BookViewRating(rating: 5)
    }
}
