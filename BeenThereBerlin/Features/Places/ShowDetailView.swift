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
  @State private var newActivityEntry = AppStrings.empty
  
  var body: some View {
    List {
      if let lat = place.latitude, let lon = place.longitude {
        Section {
          ZStack(alignment: .topTrailing) {
            Map(initialPosition: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))) {
              Marker(place.placeName, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            }
            
            Button {
              if let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(lat),\(lon)") {
                UIApplication.shared.open(url)
              }
            } label: {
              Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                .font(.title2)
                .foregroundColor(.white)
                .padding(10)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
          }
          .frame(height: 200)
          .listRowInsets(EdgeInsets())
        }
      }
      
      Section(AppStrings.placeInfo) {
        LabeledContent(AppStrings.name, value: place.placeName)
        LabeledContent(AppStrings.category, value: place.category)
        if let url = URL(string: place.address), let scheme = url.scheme, ["http", "https"].contains(scheme.lowercased()) {
          LabeledContent(AppStrings.address) {
            Link(url.host ?? String(localized: AppStrings.website), destination: url)
              .lineLimit(1)
          }
        } else {
          LabeledContent(AppStrings.address, value: place.address)
        }
        LabeledContent(AppStrings.date, value: place.date.formatted(date: .long, time: .omitted))
        LabeledContent(AppStrings.status, value: place.status.rawValue.capitalized)
      }
      
      if place.status == .visited {
        Section(AppStrings.rating) {
          StarRatingView(
            rating: Binding(
              get: { place.rating ?? 0 },
              set: { place.rating = $0 > 0 ? $0 : nil }
            )
          )
          .allowsHitTesting(false)
        }
      }
      
      Section(AppStrings.notes) {
        if let notes = place.notes,
           !notes.isEmpty {
          Text(notes)
        } else {
          Text(AppStrings.noNotesAdded)
            .foregroundStyle(.secondary)
        }
      }
      
      Section(AppStrings.activities) {
        if place.activities.isEmpty {
          Text(AppStrings.noActivitiesAdded)
            .foregroundStyle(.secondary)
        } else {
          ForEach(Array(place.activities.enumerated()), id: \.offset) { index, activity in
            
            HStack {
              Text(AppStrings.number(index + 1))
                .foregroundStyle(.secondary)
                .frame(width: 28, alignment: .leading)
              Text(activity)
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
          TextField(AppStrings.addActivityLowercase, text: $newActivityEntry)
          Button(AppStrings.add) {
            let trimmed = newActivityEntry
              .trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty else { return }
            place.activities.append(trimmed)
            newActivityEntry = AppStrings.empty
          }
          .disabled(newActivityEntry.trimmingCharacters(in: .whitespaces).isEmpty)
        }
      }
    }
    .scrollContentBackground(.hidden)
    .background(Color.appPrimary)
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Menu {
          Button(AppStrings.editPlace) {
            showingEditSheet = true
          }
          Divider()
          Button(AppStrings.deletePlaceTitle, role: .destructive) {
            showingDeleteAlert = true
          }
        } label: {
          Image(systemName: AppStrings.Icons.ellipsisCircle)
        }
      }
    }
    .sheet(isPresented: $showingEditSheet) {
      AddEditShowView(place: place)
    }
    .alert(AppStrings.deletePlaceQuestion, isPresented: $showingDeleteAlert) {
      Button(AppStrings.delete, role: .destructive) {
        modelContext.delete(place)
        dismiss()
      }
      Button(AppStrings.cancel, role: .cancel) {}
    } message: {
      Text(AppStrings.permanentlyRemove(place.placeName))
    }
  }
}
