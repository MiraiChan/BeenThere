//
//  AttendedViewModel.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 28.06.26.
//

import Foundation
import SwiftData

@Observable
final class AttendedViewModel {
  var searchText = ""
  var showingAddSheet = false
  
  func filteredShows(_ places: [FamilyPlace]) -> [FamilyPlace] {
    let attended = places.filter({ $0.status == .visited })
    guard !searchText.isEmpty else { return attended }
    return attended.filter {
      $0.placeName.localizedCaseInsensitiveContains(searchText) ||
      $0.category.localizedCaseInsensitiveContains(searchText) ||
      $0.address.localizedCaseInsensitiveContains(searchText)
    }
  }
  
  func delete(_ place: FamilyPlace, context: ModelContext) {
    context.delete(place)
  }
}
