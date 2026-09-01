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
  
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([FamilyPlace.self])
    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: false,
      groupContainer: .identifier("group.AlmiraKhafizova.BeenThere")
    )
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  var body: some Scene {
    WindowGroup {
      if hasCompletedOnboarding {
        MainTabView()
      } else {
        OnboardingView()
      }
    }
    .modelContainer(sharedModelContainer)
  }
}
