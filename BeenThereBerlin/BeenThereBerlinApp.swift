//
//  BeenThereBerlinApp.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 27.06.26.
//

import SwiftUI
import SwiftData

@main
struct BeenThereBerlinApp: App {
  
  @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
  var body: some Scene {
    WindowGroup {
      if hasCompletedOnboarding {
        MainTabView()
      } else {
        OnboardingView()
      }
    }
    .modelContainer(for: Show.self)
  }
}
