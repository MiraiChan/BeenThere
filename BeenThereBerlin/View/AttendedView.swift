//
//  AttendedView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 27.06.26.
//

import SwiftUI
import SwiftData

struct AttendedView: View {
  @Query(sort: \Show.date, order: .reverse) private var allShows: [Show] = []
  @Environment(\.modelContext) private var modelContext
  @State private var viewModel = AttendedViewModel()
  var body: some View {
    @Bindable var vm = viewModel
    NavigationStack {
      Group {
        if viewModel.filteredShows(allShows).isEmpty {
          ContentUnavailableView("No Results", systemImage: "magnifyingglass")
        } else {
          List {
            ForEach(viewModel.filteredShows(allShows)) { show in
              Text(show.artistName)
            }
            .onDelete { indexSet in
              let shows = viewModel.filteredShows(allShows)
              for index in indexSet {
                viewModel.delete(shows[index], context: modelContext)
              }
            }
          }
        }
      }
      .navigationTitle("Attended")
      .toolbar {
        Button("Add show!",
               systemImage: "plus") {
          modelContext.insert(Show(artistName: "Radiohead", venueName: "Madison", city: "New York", date: .now, status: .attended))
        }
      }
    }
  }
}

#Preview {
  AttendedView().modelContainer(for: Show.self, inMemory: true)
}
