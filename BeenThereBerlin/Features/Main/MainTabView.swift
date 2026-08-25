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
      Tab(AppStrings.visited, systemImage: AppStrings.Icons.figureWalk) {
        AttendedView()
      }
      Tab(AppStrings.wishlist, systemImage: AppStrings.Icons.star) {
        UpcomingView()
      }
      Tab(AppStrings.settings, systemImage: AppStrings.Icons.gear) {
        SettingsView()
      }
    }
  }
}
