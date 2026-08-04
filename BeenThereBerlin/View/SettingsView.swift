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
          //stats rows
        }
        
        Section("Notifications") {
          //reminders toggle
        }
        
        Section("Your Data") {
          //share link
        }
        
        Section("App") {
        }
      }
    }
  }
}

#Preview {
  SettingsView()
}
