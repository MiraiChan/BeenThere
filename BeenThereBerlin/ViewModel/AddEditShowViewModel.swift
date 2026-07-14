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
  
  init(artistName: String = "", venueName: String = "", location: String = "", date: Date = Date(), status: ShowStatus, rating: Int, notes: String = "", setlist: [String], newSetlistEntry: String = "") {
    self.artistName = artistName
    self.venueName = venueName
    self.location = location
    self.date = date
    self.status = status
    self.rating = rating
    self.notes = notes
    self.setlist = setlist
    self.newSetlistEntry = newSetlistEntry
  }
}
