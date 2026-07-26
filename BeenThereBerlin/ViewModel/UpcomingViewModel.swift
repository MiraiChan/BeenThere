//
//  UpcomingViewModel.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 03.07.26.
//

import SwiftUI
import SwiftData

@Observable
final class UpcomingViewModel {
  var showingAddSheet = false
  var showToMarkAttended: Show?
  var pendingRating = 0
  
  func filteredShows(_ shows: [Show]) -> [Show] {
    shows
      .filter { $0.status == .upcoming }
      .sorted { $0.date < $1.date }
  }
  func delete(_ show: Show, context: ModelContext) {
    context.delete(show)
  }
}
