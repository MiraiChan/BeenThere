//
//  OnboardingNotificationsPage.swift
//  BeenThere
//
//  Created by Almira Khafizova on 03.08.26.
//

import SwiftUI
import UserNotifications

struct OnboardingNotificationsPage: View {
  @Binding var notificationsRequested: Bool
  
  var body: some View {
    
    VStack(spacing: AppConstants.Spacing.large) {
      Spacer()
      Image(systemName: AppStrings.Icons.bellCircleFill)
        .font(.system(size: AppConstants.Icons.onboardingSize))
        .foregroundStyle(Color.accentColor)
      Text(AppStrings.placeReminders)
        .font(.largeTitle)
        .bold()
        .multilineTextAlignment(.center)
      Text(AppStrings.getNotifiedBefore)
        .font(.body)
        .foregroundStyle(Color.appSecondaryText)
        .multilineTextAlignment(.center)
      
      if notificationsRequested {
        Label(AppStrings.youreAllSet, systemImage: AppStrings.Icons.checkmarkCircleFill)
          .foregroundStyle(Color.appSuccessIcon)
          .font(.headline)
      } else {
        Button(AppStrings.enableNotifications) {
          UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
              DispatchQueue.main.async {
                notificationsRequested = granted
              }
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(Color.appSecondary)
        .foregroundStyle(Color.appPrimary)
      }
      Spacer()
      Spacer()
    }
    .padding()
  }
}
