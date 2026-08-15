//
//  OnboardingNotificationsPage.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 03.08.26.
//

import SwiftUI
import UserNotifications

struct OnboardingNotificationsPage: View {
  @Binding var notificationsRequested: Bool
  
  var body: some View {
    
    VStack(spacing: 24) {
      Spacer()
      Image(systemName: "bell.circle.fill")
        .font(.system(size: 90))
        .foregroundStyle(.orange)
      Text(AppStrings.placeReminders)
        .font(.largeTitle)
        .bold()
        .multilineTextAlignment(.center)
      Text(AppStrings.getNotifiedBefore)
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
      
      if notificationsRequested {
        Label(AppStrings.youreAllSet, systemImage: "checkmark.circle.fill")
          .foregroundStyle(.green)
          .font(.headline)
      } else {
        Button(AppStrings.enableNotifications) {
          UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
              DispatchQueue.main.async {
                notificationsRequested = true
              }
            }
        }
        .buttonStyle(.borderedProminent)
      }
      Spacer()
      Spacer()
    }
    .padding()
  }
}
