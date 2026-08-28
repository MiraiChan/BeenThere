//
//  Experience.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 27.06.26.
//
import Foundation
import SwiftData
import SwiftUI

enum VisitStatus: String, Codable, CaseIterable {
  case visited
  case wishlist
}

@Model
final class FamilyPlace {
  var placeName: String
  var category: String
  var address: String
  var date: Date
  var status: VisitStatus
  
  var rating: Int?
  var notes: String?
  var activities: [String]
  var createdAt: Date
  
  var latitude: Double?
  var longitude: Double?
  var websiteURL: URL?
  
  init(placeName: String, category: String, address: String, date: Date, status: VisitStatus) {
    self.placeName = placeName
    self.category = category
    self.address = address
    self.date = date
    self.status = status
    self.rating = nil
    self.notes = nil
    self.activities = []
    self.createdAt = .now
  }
}

extension VisitStatus {
  var localizedTitle: LocalizedStringResource {
    switch self {
    case .visited:
      AppStrings.visited
    case .wishlist:
      AppStrings.wishlist
    }
  }
}
