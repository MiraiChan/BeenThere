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
  
  func filteredShows(_ shows: [Show]) -> [Show] {
    let attended = shows.filter({ $0.status == .attended })
    guard !searchText.isEmpty else { return attended }
    return attended.filter {
      $0.artistName.localizedCaseInsensitiveContains(searchText) ||
      $0.venueName.localizedCaseInsensitiveContains(searchText) ||
      $0.city.localizedCaseInsensitiveContains(searchText)
    }
  }
  
  func delete(_ show: Show, context: ModelContext) {
    context.delete(show)
  }
}
