//
//  SettingsViewModel.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 04.08.26.
//

import SwiftData
import UserNotifications
import Foundation

@Observable
final class SettingsViewModel {
  var notificationsEnabled = false
  
  func attendedCount(_ shows: [Show]) -> Int {
    shows.filter { $0.status == .attended }.count
  }
  
  func upcomingCount(_ shows: [Show]) -> Int {
    shows.filter { $0.status == .upcoming }.count
  }
  
  func seenThisYear(_ shows: [Show]) -> Int {
    let year = Calendar.current.component(.year, from: .now)
    return shows.filter { $0.status == .attended && Calendar.current.component(.year, from: $0.date) == year }.count
  }
  
  func topArtist(_ shows: [Show]) -> String? {
    let attended = shows.filter { $0.status == .attended }
    let counts = Dictionary(grouping: attended, by: \.artistName)
      .mapValues(\.count)
    return counts.max { $0.value < $1.value }?.key
  }
}
