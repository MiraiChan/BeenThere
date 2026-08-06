//
//  EmptyStateView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 06.08.26.
//

import SwiftUI

struct EmptyStateView: View {
  let icon: String
  let title: String
  let message: String
  
    var body: some View {
      ContentUnavailableView(title, systemImage: icon, description: Text(message))
    }
}
