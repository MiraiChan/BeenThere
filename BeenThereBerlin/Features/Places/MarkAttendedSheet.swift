//
//  MarkAttendedSheet.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 27.07.26.
//

import SwiftUI

struct MarkAttendedSheet: View {
  let place: FamilyPlace
  @Bindable var viewModel: UpcomingViewModel
  @Environment(\.dismiss) private var dismiss
  var body: some View {
    NavigationStack {
      VStack(spacing: 24) {
        Text(AppStrings.howWas(place.placeName))
          .font(.title2)
          .bold()
          .multilineTextAlignment(.center)
          .lineLimit(2)
          .padding(.top)
        
        StarRatingView(rating: $viewModel.pendingRating)
        
        Text(AppStrings.optionalRating)
          .font(.caption)
          .foregroundStyle(.secondary)
        Spacer()
      }
      .padding()
      .background(Color.appPrimary.ignoresSafeArea())
      .navigationTitle(AppStrings.markAsVisited)
      .navigationBarTitleDisplayMode(.inline)
      
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(AppStrings.cancel) {
            viewModel.pendingRating = 0
            dismiss()
          }
        }
        
        ToolbarItem(placement: .confirmationAction) {
          Button(AppStrings.done) {
            viewModel.markAsAttended(place)
            dismiss()
          }
        }
      }
    }
    .presentationDetents([.medium])
  }
}
