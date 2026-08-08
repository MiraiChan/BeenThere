//
//  AddEditShowViewModel.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 14.07.26.
//

import Foundation
import SwiftData

@Observable
final class AddEditShowViewModel {
  var placeName = ""
  var category = ""
  var address = ""
  var date = Date()
  var status: VisitStatus = .wishlist
  var rating: Int = 0
  var notes = ""
  var activities: [String] = []
  var newActivityEntry = ""
  
  var isValid: Bool {
    !placeName.trimmingCharacters(in: .whitespaces).isEmpty && !category.trimmingCharacters(in: .whitespaces).isEmpty
  }
  
  init(place: FamilyPlace? = nil, initialStatus: VisitStatus = .wishlist) {
    if let place {
      placeName = place.placeName
      category = place.category
      address = place.address
      date = place.date
      status = place.status
      rating = place.rating ?? 0
      notes = place.notes ?? ""
      activities = place.activities
    } else {
      status = initialStatus
      date = initialStatus == .visited ? .now : Calendar.current.date(byAdding: .day, value: 7, to: .now) ?? .now
    }
  }
  
  func addSetlistEntry() {
    let trimmed = newActivityEntry.trimmingCharacters(in: .whitespaces)
    guard !trimmed.isEmpty else { return }
    activities.append(trimmed)
    newActivityEntry = ""
  }
  
  func save(to context: ModelContext, existing place: FamilyPlace? = nil) {
    if let place {
      place.placeName = placeName
      place.category = category
      place.address = address
      place.date = date
      place.status = status
      place.rating = rating > 0 ? rating : nil
      place.notes = notes.isEmpty ? nil : notes
      place.activities = activities
    } else {
      let newPlace = FamilyPlace(placeName: placeName, category: category, address: address, date: date, status: status)
      newPlace.rating = rating > 0 ? rating : nil
      newPlace.notes = notes.isEmpty ? nil : notes
      newPlace.activities = activities
      context.insert(newPlace)
    }
  }
}
