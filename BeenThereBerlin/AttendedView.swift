//
//  AttendedView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 27.06.26.
//

import SwiftUI

struct AttendedView: View {
  @State private var shows: [Show] = []
  var body: some View {
    NavigationStack {
      List(shows) { show in
        Text(show.artistName)
      }
      .navigationTitle("Attended")
      .toolbar {
        Button("Add show!",
               systemImage: "plus") {
          shows.append(Show(artistName: "Radiohead", venueName: "Madison", city: "New York", date: .now, status: .attended))
        }
      }
    }
  }
}

#Preview {
  AttendedView()
}
