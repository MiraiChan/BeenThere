//
//  UpcomingView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 29.06.26.
//

import SwiftUI
import SwiftData

struct UpcomingView: View {
  @Query(sort: \Show.date) private var allShows: [Show]
  @Environment(\.modelContext)  private var modelContext
  @State private var viewModel = UpcomingViewModel()
  
    var body: some View {
        @Bindable var vm = viewModel
      
      NavigationStack {
        Group{}
      }
    }
}

#Preview {
    UpcomingView()
}
