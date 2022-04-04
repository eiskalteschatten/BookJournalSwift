//
//  BookRatingEditor.swift
//  BookJournal
//
//  Created by Alex Seifert on 04.04.22.
//

import SwiftUI

struct BookRatingEditor: View {
    @Binding var rating: Int
    
    var body: some View {
        let starSize = 20.0
        let totalStars = 5
        let totalUnfilledStars = totalStars - rating
        let totalFilledStars = totalStars - totalUnfilledStars
        
        HStack {
            Button (action: { rating = 0 }) {
                Image(systemName: "star.slash")
                    .foregroundColor(.red)
                    .opacity(0.8)
            }
            .buttonStyle(PlainButtonStyle())
            
            if totalFilledStars > 0 {
                ForEach(1...totalFilledStars, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: starSize, height: starSize)
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            changeRating(index)
                        }
                }
            }
            
            if totalUnfilledStars > 0 {
                ForEach(1...totalUnfilledStars, id: \.self) { index in
                    Image(systemName: "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: starSize, height: starSize)
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            changeRating(totalFilledStars + index)
                        }
                }
            }
        }
    }
    
    private func changeRating(_ value: Int) {
        rating = value;
        
        #if os(iOS)
        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
        impactHeavy.impactOccurred()
        #endif
    }
}

struct BookRatingEditor_Previews: PreviewProvider {
    @State static var rating = 2
    
    static var previews: some View {
        BookRatingEditor(rating: $rating)
    }
}
