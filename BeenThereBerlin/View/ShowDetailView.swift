//
//  ShowDetailView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 28.07.26.
//

import SwiftUI

struct ShowDetailView: View {
  @Bindable var show: Show
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @State private var showingEditSheet = false
  @State private var showingDeleteAlert = false
  @State private var newSetlistEntry = ""
  
    var body: some View {
      List {
        Section("Show Info") {
          LabeledContent("Artist", value: show.artistName)
          LabeledContent("Venue", value: show.venueName)
          LabeledContent("Location", value: show.location)
          LabeledContent("Date", value: show.date.formatted(date: .long, time: .omitted))
          LabeledContent("Status", value: show.status.rawValue.capitalized)
        }
      }
    }
}
