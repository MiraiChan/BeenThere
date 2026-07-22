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
  var artistName = ""
  var venueName = ""
  var location = ""
  var date = Date()
  var status: ShowStatus = .upcoming
  var rating: Int = 0
  var notes = ""
  var setlist: [String] = []
  var newSetlistEntry = ""
  
  var isValid: Bool {
    !artistName.trimmingCharacters(in: .whitespaces).isEmpty && !venueName.trimmingCharacters(in: .whitespaces).isEmpty
  }
  
  init(show: Show? = nil, initialStatus: ShowStatus = .upcoming) {
    if let show {
      artistName = show.artistName
      venueName = show.venueName
      location = show.location
      date = show.date
      status = show.status
      rating = show.rating ?? 0
      notes = show.notes ?? ""
      setlist = show.setlist
    } else {
      status = initialStatus
      date = initialStatus == .attended ? .now : Calendar.current.date(byAdding: .day, value: 7, to: .now) ?? .now
    }
  }
  
  func addSetlistEntry() {
    let trimmed = newSetlistEntry.trimmingCharacters(in: .whitespaces)
    guard !trimmed.isEmpty else { return }
    setlist.append(trimmed)
    newSetlistEntry = ""
  }
  
  func save(to context: ModelContext, existing show: Show? = nil) {
    if let show {
      show.artistName = artistName
      show.venueName = venueName
      show.location = location
      show.date = date
      show.status = status
      show.rating = rating > 0 ? rating : nil
      show.notes = notes.isEmpty ? nil : notes
      show.setlist = setlist
    } else {
      let newShow = Show(artistName: artistName, venueName: venueName, location: location, date: date, status: status)
      newShow.rating = rating > 0 ? rating : nil
      newShow.notes = notes.isEmpty ? nil : notes
      newShow.setlist = setlist
      context.insert(newShow)
    }
  }
}
