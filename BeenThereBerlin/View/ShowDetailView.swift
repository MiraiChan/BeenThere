//
//  ShowDetailView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 28.07.26.
//

import SwiftUI
import SwiftData
import MapKit

struct ShowDetailView: View {
  @Bindable var place: FamilyPlace
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @State private var showingEditSheet = false
  @State private var showingDeleteAlert = false
  @State private var newActivityEntry = ""
  
  var body: some View {
    List {
      if let lat = place.latitude, let lon = place.longitude {
        Section {
          Map(initialPosition: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))) {
            Marker(place.placeName, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
          }
          .frame(height: 200)
          .listRowInsets(EdgeInsets())
        }
      }
      
      Section("Place Info") {
        LabeledContent("Name", value: place.placeName)
        LabeledContent("Category", value: place.category)
        LabeledContent("Address", value: place.address)
        LabeledContent("Date", value: place.date.formatted(date: .long, time: .omitted))
        LabeledContent("Status", value: place.status.rawValue.capitalized)
      }
      
      if place.status == .visited {
        Section("Rating") {
          StarRatingView(
            rating: Binding(
              get: { place.rating ?? 0 },
              set: { place.rating = $0 > 0 ? $0 : nil }
            )
          )
        }
      }
      
      Section("Notes") {
        if let notes = place.notes,
           !notes.isEmpty {
          Text(notes)
        } else {
          Text("No notes added!")
            .foregroundStyle(.secondary)
        }
      }
      
      Section("Activities") {
        if place.activities.isEmpty {
          Text("No Activities Added")
            .foregroundStyle(.secondary)
        } else {
          ForEach(place.activities.indices, id: \.self) { index in
            
            HStack {
              Text("\(index + 1)")
                .foregroundStyle(.secondary)
                .frame(width: 28, alignment: .leading)
              Text(place.activities[index])
            }
          }
          .onDelete { indexSet in
            place.activities.remove(atOffsets: indexSet)
          }
          .onMove { source, destination in
            place.activities.move(fromOffsets: source, toOffset: destination)
          }
        }
        HStack {
          TextField("Add activity", text: $newActivityEntry)
          Button("Add") {
            let trimmed = newActivityEntry
              .trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { return }
            place.activities.append(trimmed)
            newActivityEntry = ""
          }
          .disabled(newActivityEntry.trimmingCharacters(in: .whitespaces).isEmpty)
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Menu {
          Button("Edit Place") {
            showingEditSheet = true
          }
          Divider()
          Button("Delete Place", role: .destructive) {
            showingDeleteAlert = true
          }
        } label: {
          Image(systemName: "ellipsis.circle")
        }
      }
    }
    .sheet(isPresented: $showingEditSheet) {
      AddEditShowView(place: place)
    }
    .alert("Delete Place?", isPresented: $showingDeleteAlert) {
      Button("Delete", role: .destructive) {
        modelContext.delete(place)
        dismiss()
      }
      Button("Cancel", role: .cancel) {}
    } message: {
      Text("This will permanently remove \(place.placeName) from your history")
    }
  }
}
