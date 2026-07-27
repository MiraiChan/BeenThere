//
//  MarkAttendedSheet.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 27.07.26.
//

import SwiftUI

struct MarkAttendedSheet: View {
  let show: Show
  @Bindable var viewModel: UpcomingViewModel
  @Environment(\.dismiss) private var dismiss
  var body: some View {
    NavigationStack {
      VStack(spacing: 24) {
        Text("How was \(show.artistName)?")
          .font(.title2)
          .bold()
          .multilineTextAlignment(.center)
          .lineLimit(2)
          .padding(.top)
        
        //StarRatingView
        
        Text("Optional - you can always add rating later")
          .font(.caption)
          .foregroundStyle(.secondary)
        Spacer()
      }
      .padding()
      .navigationTitle("Mark as Attended")
      .navigationBarTitleDisplayMode(.inline)
      
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            viewModel.pendingRating = 0
            dismiss()
          }
        }
      }
    }
  }
}
