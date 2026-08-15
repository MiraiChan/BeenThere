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
      Tab(AppStrings.visited, systemImage: "figure.walk") {
        AttendedView()
      }
      Tab(AppStrings.wishlist, systemImage: "star") {
        UpcomingView()
      }
      Tab(AppStrings.settings, systemImage: "gear") {
        SettingsView()
      }
    }
  }
}
