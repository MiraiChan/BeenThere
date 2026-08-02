//
//  OnboardingView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 01.08.26.
//

import SwiftUI
import UserNotifications

struct OnboardingView: View {
  @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
  @State private var currentPage = 0
  @State private var notificationsRequested = false
  
  private let pages: [(icon: String, color: Color, title: String, description: String)] = [
    ("ticket.fill", .purple, "Your Concert History", "Log every show you've been to. Build a record of your live music journey"),
    ("music.microphone.circle.fill", .pink, "Every Detail Caprured", "Set lists, ratings, notes - everything that made each night unforgettable."),
    ("calendar", .blue, "Never miss a show", "Save upcoming concerts and keep track of what's on your radar")
  ]
  
  private var isLastPage: Bool {
    currentPage == pages.count
  }
  
  private func advance() {
    if isLastPage {
      hasCompletedOnboarding = true
    } else {
      withAnimation { currentPage += 1 }
    }
  }
  
  var body: some View {
    VStack {
      TabView(selection: $currentPage) {
        ForEach(pages.indices, id: \.self) { index in
          
          OnboardingPageView()
            .tag(index)
        }
        OnboardingNotificationsPage(notificationsRequested: $notificationsRequested)
          .tag(pages.count)
      }
      .tabViewStyle(.page(indexDisplayMode: .always))
      .animation(.easeInOut, value: currentPage)
    }
  }
}

#Preview {
  OnboardingView()
}
