//
//  SettingsViewModel.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 04.08.26.
//

import SwiftData
import UserNotifications
import Foundation
import UIKit

@Observable
final class SettingsViewModel {
  var notificationsEnabled = false
  
  func attendedCount(_ places: [FamilyPlace]) -> Int {
    places.filter { $0.status == .visited }.count
  }
  
  func upcomingCount(_ places: [FamilyPlace]) -> Int {
    places.filter { $0.status == .wishlist }.count
  }
  
  func seenThisYear(_ places: [FamilyPlace]) -> Int {
    let year = Calendar.current.component(.year, from: .now)
    return places.filter { $0.status == .visited && Calendar.current.component(.year, from: $0.date) == year }.count
  }
  
  func topArtist(_ places: [FamilyPlace]) -> String? {
    let attended = places.filter { $0.status == .visited }
    let counts = Dictionary(grouping: attended, by: \.category)
      .mapValues(\.count)
    return counts.max { $0.value < $1.value }?.key
  }
  
  func exportText(_ places: [FamilyPlace]) -> String {
    let attended = places
      .filter { $0.status == .visited }
      .sorted { $0.date > $1.date }
    guard !attended.isEmpty else { return String(localized: AppStrings.noPlacesLogged) }
    
    let lines = attended.map { place in
      let date = place.date.formatted(.dateTime.day().month().year())
      return "\(date) - \(place.placeName) (\(place.category)), \(place.address)"
    }
    return String(localized: AppStrings.myPlacesHistoryTitle) + lines.joined(separator: "\n")
  }
  
  func requestNotificationPermission() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      if settings.authorizationStatus == .denied {
        DispatchQueue.main.async {
          if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
          }
        }
      } else {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
          DispatchQueue.main.async {
            self.notificationsEnabled = granted
          }
        }
      }
    }
  }
  
  func checkNotificationStatus() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      DispatchQueue.main.async {
        self.notificationsEnabled = settings.authorizationStatus == .authorized
      }
    }
  }
}
