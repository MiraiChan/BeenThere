//
//  SettingsView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 29.06.26.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
  @Query private var allShows: [Show]
  @State private var viewModel = SettingsViewModel()
  
  var body: some View {
    NavigationStack {
      Form{
        Section("Your Stats") {
          LabeledContent("Shows Attended", value: "\(viewModel.attendedCount(allShows))")
          LabeledContent("Upcoming", value: "\(viewModel.upcomingCount(allShows))")
          LabeledContent("Seen this year", value: "\(viewModel.seenThisYear(allShows))")
          if let topArtist = viewModel.topArtist(allShows)
              LabeledContent("Most Seen Artist", value: topArtist)
        }
        
        Section("Notifications") {
          //reminders toggle
        }
        
        Section("Your Data") {
          ShareLink(item: viewModel.exportText(allShows)) {
            Label("Export History", systemImage: "square.and.arrow.up")
          }
          .disabled(allShows.isEmpty)
        }
        
        Section("App") {
          LabeledContent("Version", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
        }
      }
      .navigationTitle("Settings")
      .onAppear {
        viewModel.checkNotificationStatus()
      }
    }
  }
}

#Preview {
  SettingsView()
}
