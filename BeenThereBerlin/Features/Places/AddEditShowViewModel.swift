//
//  AddEditShowViewModel.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 14.07.26.
//
import Foundation
import SwiftData
import MapKit
import OSLog

@Observable
final class AddEditShowViewModel: NSObject, MKLocalSearchCompleterDelegate {
  var placeName = AppStrings.empty
  var category = AppStrings.empty
  var address = AppStrings.empty
  var date = Date()
  var status: VisitStatus = .wishlist
  var rating: Int = 0
  var notes = AppStrings.empty
  var activities: [String] = []
  var newActivityEntry = AppStrings.empty
  
  var latitude: Double?
  var longitude: Double?
  var websiteURL: URL?
  
  var searchQuery = AppStrings.empty
  var searchResults: [MKLocalSearchCompletion] = []
  @ObservationIgnored private let completer = MKLocalSearchCompleter()
  
  
  var isValid: Bool {
    !placeName.trimmingCharacters(in: .whitespaces).isEmpty && !category.trimmingCharacters(in: .whitespaces).isEmpty
  }
  
  init(place: FamilyPlace? = nil, initialStatus: VisitStatus = .wishlist) {
    super.init()
    completer.delegate = self
    completer.resultTypes = [.pointOfInterest, .address]
    
    if let place {
      placeName = place.placeName
      category = place.category
      address = place.address
      date = place.date
      status = place.status
      rating = place.rating ?? 0
      notes = place.notes ?? AppStrings.empty
      activities = place.activities
      latitude = place.latitude
      longitude = place.longitude
      websiteURL = place.websiteURL
    } else {
      status = initialStatus
      date = initialStatus == .visited ? .now : Calendar.current.date(byAdding: .day, value: 7, to: .now) ?? .now
    }
  }
  
  func updateSearchQuery(_ query: String) {
    self.searchQuery = query
    if query.isEmpty {
      searchResults = []
    } else {
      completer.queryFragment = query
    }
  }
  
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    self.searchResults = completer.results
  }
  
  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    AppLogger.addEditShowViewModel.error(
      "Search completion failed: \(error.localizedDescription)"
    )
  }
  
  func select(completion: MKLocalSearchCompletion) {
    let request = MKLocalSearch.Request(completion: completion)
    let search = MKLocalSearch(request: request)
    
    search.start { [weak self] response, error in
      if let error {
        AppLogger.addEditShowViewModel.error(
          "Search failed with error: \(error.localizedDescription)"
        )
        return
      }
      
      guard let self = self, let mapItem = response?.mapItems.first else { return }
      
      DispatchQueue.main.async {
        self.placeName = mapItem.name ?? completion.title
        self.address = completion.subtitle
        
        if let poiCategory = mapItem.pointOfInterestCategory?.rawValue {
          self.category = poiCategory.replacingOccurrences(
            of: "MKPOICategory",
            with: AppStrings.empty
          )
        }
        self.latitude = mapItem.location.coordinate.latitude
        self.longitude = mapItem.location.coordinate.longitude
        self.websiteURL = mapItem.url
        self.searchQuery = AppStrings.empty
        self.searchResults = []
      }
    }
  }
  
  func addSetlistEntry() {
    let trimmed = newActivityEntry.trimmingCharacters(in: .whitespaces)
    guard !trimmed.isEmpty else { return }
    activities.append(trimmed)
    newActivityEntry = AppStrings.empty
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
      place.latitude = latitude
      place.longitude = longitude
      place.websiteURL = websiteURL
    } else {
      let newPlace = FamilyPlace(placeName: placeName, category: category, address: address, date: date, status: status)
      newPlace.rating = rating > 0 ? rating : nil
      newPlace.notes = notes.isEmpty ? nil : notes
      newPlace.activities = activities
      newPlace.latitude = latitude
      newPlace.longitude = longitude
      newPlace.websiteURL = websiteURL
      context.insert(newPlace)
    }
  }
}
