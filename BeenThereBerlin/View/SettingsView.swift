//
//  SettingsView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 29.06.26.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
  @Query private var allPlaces: [FamilyPlace]
  @State private var viewModel = SettingsViewModel()
  
  var body: some View {
    NavigationStack {
      Form{
        Section("Your Stats") {
          LabeledContent("Places Visited", value: "\(viewModel.attendedCount(allPlaces))")
          LabeledContent("Wishlist", value: "\(viewModel.upcomingCount(allPlaces))")
          LabeledContent("Visited this year", value: "\(viewModel.seenThisYear(allPlaces))")
          if let topArtist = viewModel.topArtist(allPlaces) {
            LabeledContent("Top Category", value: topArtist)
          }
        }
          
          Section("Notifications") {
            Toggle(
              "Show Reminders",
              isOn: Binding(
                get: { viewModel.notificationsEnabled },
                set: { enabled in
                  if enabled {
                    viewModel.requestNotificationPermission()
                  }
                }
              )
            )
          }
          
          Section("Your Data") {
            ShareLink(item: viewModel.exportText(allPlaces)) {
              Label("Export History", systemImage: "square.and.arrow.up")
            }
            .disabled(allPlaces.isEmpty)
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
