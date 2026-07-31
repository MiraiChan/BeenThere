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
      
      if show.status == .attended {
        Section("Rating") {
          StarRatingView(rating: Binding(get: { show.rating ?? 0 }, set: {show.rating = $0 > 0 ? $0 : nil}))
        }
      }
      
      Section("Notes") {
        if let notes = show.notes,
           !notes.isEmpty {
          Text(notes)
        } else {
          Text("No notes added!")
            .foregroundStyle(.secondary)
        }
      }
      
      Section("Setlist") {
        if show.setlist.isEmpty {
          Text("No Songs Added")
            .foregroundStyle(.secondary)
        } else {
          ForEach(show.setlist.indices, id: \.self) { index in
            
            HStack {
              Text("\(index + 1)")
                .foregroundStyle(.secondary)
                .frame(width: 28, alignment: .leading)
              Text(show.setlist[index])
            }
          }
          .onDelete { indexSet in
            show.setlist.remove(atOffsets: indexSet)
          }
          .onMove { source, destination in
            show.setlist.move(fromOffsets: source, toOffset: destination)
          }
        }
        HStack {
          TextField("Add song", text: $newSetlistEntry)
          Button("Add") {
            let trimmed = newSetlistEntry
              .trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { return }
            show.setlist.append(trimmed)
            newSetlistEntry = ""
          }
          .disabled(newSetlistEntry)
        }
      }
    }
  }
}
