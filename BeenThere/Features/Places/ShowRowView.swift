//
//  ShowRowView.swift
//  BeenThere
//
//  Created by Almira Khafizova on 03.07.26.
//
import SwiftUI

struct ShowRowView: View {
  let place: FamilyPlace
  var body: some View {
    VStack(alignment: .leading, spacing: AppConstants.Spacing.small) {
      Text(place.placeName)
        .font(.headline)
      
      if place.address.hasPrefix("http") {
        HStack(alignment: .center, spacing: AppConstants.Spacing.small) {
          Image(systemName: AppStrings.Icons.locationIcon)
            .imageScale(.small)
          Text(AppStrings.location)
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .padding(.bottom, AppConstants.Padding.medium)
      } else {
        Text(place.address)
          .font(.subheadline)
          .foregroundStyle(.secondary)
          .padding(.bottom, AppConstants.Padding.medium)
      }
      
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
          HStack(spacing: AppConstants.Spacing.tiny) {
            ForEach(1...5, id: \.self) { star in
              Image(systemName: star <= rating ? AppStrings.Icons.starFill : AppStrings.Icons.star)
                .font(.caption2)
                .foregroundStyle(star <= rating ? Color.accentColor : Color.appStarInactive)
            }
          }
        }
      }
    }
    .padding(.vertical, AppConstants.Padding.tiny)
  }
}
