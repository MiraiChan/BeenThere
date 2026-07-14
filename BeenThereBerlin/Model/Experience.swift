//
//  Experience.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 27.06.26.
//
import Foundation
import SwiftData
import SwiftUI

//Codable → can be saved to the database
//CaseIterable → you can list all cases (for example, for Picker)
enum ShowStatus: String, Codable, CaseIterable { //rename to ExperienceStatus
  case attended
  case upcoming
}

@Model
final class Show {
  var artistName: String
  var venueName: String
  var location: String
  var date: Date
  var status: ShowStatus
  
  var rating: Int?
  var notes: String?
  var setlist: [String]
  var createdAt: Date
  
  init(artistName: String, venueName: String, city: String, date: Date, status: ShowStatus) {
    self.artistName = artistName
    self.venueName = venueName
    self.location = location
    self.date = date
    self.status = status
    self.rating = nil
    self.notes = nil
    self.setlist = []
    self.createdAt = .now
  }
}

#Preview {
  //Creating a temporary database (in-memory)
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  //Creating a SwiftData container, launching
  let container = try! ModelContainer(for: Show.self, configurations: config)
  //Creating test data
  let sample = Show(artistName: "MGK", venueName: "Coke Arena", city: "Toronto", date: .now, status: .attended)
  //this object must exist in the database
  container.mainContext.insert(sample)
  //Text(sample.artistName) → The UI you see in Preview
  //.modelContainer(container) → connects SwiftData to this UI
  return Text(sample.artistName).modelContainer(container)
}
