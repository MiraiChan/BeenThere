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
      Form {
        Section(AppStrings.yourStats) {
          LabeledContent(AppStrings.placesVisited, value: "\(viewModel.attendedCount(allPlaces))")
          LabeledContent(AppStrings.wishlist, value: "\(viewModel.upcomingCount(allPlaces))")
          LabeledContent(AppStrings.visitedThisYear, value: "\(viewModel.seenThisYear(allPlaces))")
          if let topArtist = viewModel.topArtist(allPlaces) {
            LabeledContent(AppStrings.topCategory, value: topArtist)
          }
        }
        .appRowBackground()
          
          Section(AppStrings.notifications) {
            Toggle(
              AppStrings.showReminders,
              isOn: Binding(
                get: { viewModel.notificationsEnabled },
                set: { enabled in
                  if enabled {
                    viewModel.requestNotificationPermission()
                  } else {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                      UIApplication.shared.open(url)
                    }
                  }
                }
              )
            )
            .tint(Color.accentColor)
          }
          .appRowBackground()
          
          Section(AppStrings.yourData) {
            ShareLink(item: viewModel.exportText(allPlaces)) {
              Label(AppStrings.exportHistory, systemImage: AppStrings.Icons.squareAndArrowUp)
            }
            .disabled(allPlaces.isEmpty)
            .foregroundStyle(Color.accentColor)
          }
          .appRowBackground()
          
          Section(AppStrings.app) {
            LabeledContent(AppStrings.version, value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
            Link(AppStrings.privacyPolicy, destination: URL(string: AppStrings.privacyPolicyURL)!)
            Link(AppStrings.termsOfUse, destination: URL(string: AppStrings.termsOfUseURL)!)
          }
          .appRowBackground()
        }
        .scrollContentBackground(.hidden)
        .background(Color.appPrimary)
        .navigationTitle(AppStrings.settings)
        .onAppear {
          viewModel.checkNotificationStatus()
        }
      }
    }
  }
