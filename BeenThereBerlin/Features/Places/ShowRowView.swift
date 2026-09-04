//
//  ShowRowView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 03.07.26.
//
import SwiftUI

struct ShowRowView: View {
  let place: FamilyPlace
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(place.placeName)
        .font(.headline)
      
      Text(place.address)
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.bottom, 10)
      
      HStack {
        Text(place.category)
          .font(.caption)
          .foregroundStyle(.secondary)
        
        Text(AppStrings.bullet)
          .font(.caption)
          .foregroundStyle(.secondary)
        
        Text(place.date.formatted(date: .abbreviated, time: .omitted))
          .font(.caption)
          .foregroundStyle(.secondary)
        
        if let rating = place.rating {
          Spacer()
          HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { star in
              Image(systemName: star <= rating ? AppStrings.Icons.starFill : AppStrings.Icons.star)
                .font(.caption2)
                .foregroundStyle(star <= rating ? Color.accentColor : Color.appStarInactive)
            }
          }
        }
      }
    }
    .padding(.vertical, 2)
  }
}
