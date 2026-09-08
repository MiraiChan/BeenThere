//
//  OnboardingPageView.swift
//  BeenThere
//
//  Created by Almira Khafizova on 02.08.26.
//

import SwiftUI

struct OnboardingPageView: View {
  let icon: String
  let color: Color
  let title: LocalizedStringResource
  let description: LocalizedStringResource
  
  var body: some View {
    VStack(spacing: AppConstants.Spacing.large) {
      Spacer()
      Image(systemName: icon)
        .font(.system(size: AppConstants.Icons.onboardingSize))
        .foregroundStyle(color)
      Text(title)
        .font(.largeTitle)
        .bold()
        .multilineTextAlignment(.center)
      Text(description)
        .font(.body)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
      Spacer()
      Spacer()
    }
    .padding()
  }
}
