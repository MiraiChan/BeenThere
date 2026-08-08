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
    ("map.fill", .purple, "Your Family Places", "Log every place you've visited. Build a record of your family's favorite spots."),
    ("star.circle.fill", .pink, "Every Detail Captured", "Activities, ratings, notes - everything that made each visit unforgettable."),
    ("calendar", .blue, "Never miss a place", "Save upcoming places and keep track of what's on your radar.")
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
          
          OnboardingPageView(icon: pages[index].icon, color: pages[index].color, title: pages[index].title, description: pages[index].description)
            .tag(index)
        }
        
        OnboardingNotificationsPage(notificationsRequested: $notificationsRequested)
          .tag(pages.count)
      }
      .tabViewStyle(.page(indexDisplayMode: .always))
      .animation(.easeInOut, value: currentPage)
      
      Button(action: advance) {
        Text(isLastPage ? "Let's go!" : "Continue")
          .font(.headline)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.accentColor)
          .foregroundStyle(.white)
          .clipShape(RoundedRectangle(cornerRadius: 16))
      }
      .padding(.horizontal)
      .padding(.bottom, 32)
    }
  }
}

#Preview {
  OnboardingView()
}
