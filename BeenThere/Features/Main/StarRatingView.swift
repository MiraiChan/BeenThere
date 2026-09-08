//
//  StarRatingView.swift
//  BeenThere
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
          withAnimation(.spring(response: AppConstants.Animation.springResponse)) {
            rating = rating == star ? 0 : star
          }
        }
        label: {
          Image(systemName: star <= rating ? AppStrings.Icons.starFill : AppStrings.Icons.star)
            .font(.title2)
            .foregroundStyle(star <= rating ? Color.accentColor : Color.appStarInactive)
            .scaleEffect(star <= rating ? AppConstants.Animation.scaleActive : AppConstants.Animation.scaleInactive)
            .animation(.spring(response: AppConstants.Animation.springResponse), value: rating)
        }
        .buttonStyle(.plain)
      }
    }
  }
}
