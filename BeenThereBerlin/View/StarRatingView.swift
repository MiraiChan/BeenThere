//
//  StarRatingView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 29.07.26.
//

import SwiftUI

struct StarRatingView: View {
  @Binding var rating: Int
  private let maxRating = 5
  
  var body: some View {
    HStack {
      ForEach(1 ... maxRating, id: \.self) { star in
        Button {
          withAnimation(.spring(response: 0.5)) {
            rating = rating == star ? 0 : star
          }
        }
        label: {
          Image(systemName: star <= rating ? "star.fill" : "star")
            .font(.title2)
            .foregroundStyle(star <= rating ? Color.yellow: Color.secondary)
        }
      }
    }
  }
}
