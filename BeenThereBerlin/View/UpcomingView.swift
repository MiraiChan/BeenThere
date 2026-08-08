//
//  UpcomingView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 29.06.26.
//

import SwiftUI
import SwiftData

struct UpcomingView: View {
  @Query(sort: \FamilyPlace.date) private var allPlaces: [FamilyPlace]
  @Environment(\.modelContext)  private var modelContext
  @State private var viewModel = UpcomingViewModel()
  
  var body: some View {
    @Bindable var vm = viewModel
    
    NavigationStack {
      Group{
        if viewModel.filteredShows(allPlaces).isEmpty {
          EmptyStateView(icon: "calendar", title: "Nothing coming up", message: "Save places you're planning to visit")
        } else {
          List {
            ForEach(viewModel.filteredShows(allPlaces)) { place in
              NavigationLink(value: place) {
                ShowRowView(place: place)
              }
              .swipeActions(edge: .leading) {
                Button("Visited") {
                  viewModel.showToMarkAttended = place
                }
                .tint(.green)
              }
            }
            .onDelete {
              indexSet in
              
              let places = viewModel.filteredShows(allPlaces)
              for index in indexSet {
                viewModel.delete(places[index], context: modelContext)
              }
            }
          }
        }
      }
      .navigationTitle("Wishlist")
      .navigationDestination(for: FamilyPlace.self) { place in
        ShowDetailView(place: place)
      }
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button("Add Place", systemImage: "plus") {
            viewModel.showingAddSheet = true
          }
        }
      }
      .sheet(isPresented: $vm.showingAddSheet) {
        AddEditShowView(initialStatus: .wishlist)
      }
      .sheet(item: $vm.showToMarkAttended) {
        place in
        MarkAttendedSheet(place: place, viewModel: viewModel)
      }
    }
  }
}

#Preview {
  UpcomingView()
}
