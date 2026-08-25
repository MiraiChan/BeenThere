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
  
  private let pages: [(icon: String, color: Color, title: LocalizedStringResource, description: LocalizedStringResource)] = [
    (AppStrings.Icons.mapFill, .appSecondary, AppStrings.yourFamilyPlaces, AppStrings.logEveryPlace),
    (AppStrings.Icons.starCircleFill, .appSecondary, AppStrings.everyDetailCaptured, AppStrings.activitiesRatingsNotes),
    (AppStrings.Icons.calendar, .appSecondary, AppStrings.neverMissAPlace, AppStrings.saveUpcomingPlaces)
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
        Text(isLastPage ? AppStrings.letsGo : AppStrings.continueBtn)
          .font(.headline)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.appBackgroundAccent)
          .foregroundStyle(Color.appButtonWhite)
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
