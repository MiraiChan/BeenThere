//
//  AttendedView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 27.06.26.
//

import SwiftUI
import SwiftData

struct AttendedView: View {
  @Query private var shows: [Show] = []
  @Environment(\.modelContext) private var modelContext
  var body: some View {
    NavigationStack {
      List(shows) { show in
        Text(show.artistName)
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
