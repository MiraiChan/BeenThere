//
//  MainTabView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 29.06.26.
//

import SwiftUI
struct MainTabView: View {
  var body: some View {
    TabView {
      Tab("Attended", systemImage: "figure.walk") {
        AttendedView()
      }
      Tab("Upcoming", systemImage: "calendar") {
        UpcomingView()
      }
      Tab("Settings", systemImage: "gear") {
        SettingsView()
      }
    }
  }
}
