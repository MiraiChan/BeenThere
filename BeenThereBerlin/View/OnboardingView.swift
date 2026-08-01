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
  
  private let pages: [(icon: String, color: Color, title: String, description: String)]
  
    var body: some View {
        
    }
}

#Preview {
    OnboardingView()
}
