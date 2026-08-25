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
  var showToMarkAttended: FamilyPlace?
  var pendingRating = 0
  
  func filteredShows(_ places: [FamilyPlace]) -> [FamilyPlace] {
    places
      .filter { $0.status == .wishlist }
      .sorted { $0.date < $1.date }
  }
  func delete(_ place: FamilyPlace, context: ModelContext) {
    context.delete(place)
  }
  
  func markAsAttended(_ place: FamilyPlace) {
    place.status = .visited
    place.rating = pendingRating > 0 ? pendingRating : nil
    pendingRating = 0
    showToMarkAttended = nil
  }
}
