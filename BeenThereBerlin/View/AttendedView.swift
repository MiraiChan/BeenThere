//
//  AttendedView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 27.06.26.
//

import SwiftUI
import SwiftData

struct AttendedView: View {
  @Query(sort: \FamilyPlace.date, order: .reverse) private var allPlaces: [FamilyPlace] = []
  @Environment(\.modelContext) private var modelContext
  @State private var viewModel = AttendedViewModel()
  var body: some View {
    @Bindable var vm = viewModel
    NavigationStack {
      Group {
        if viewModel.filteredShows(allPlaces).isEmpty {
          EmptyStateView(icon: "map", title: viewModel.searchText.isEmpty ? "No Places Yet" : "No Results", message: viewModel.searchText.isEmpty ? "Start logging for the places you've been to" : "Try Searching for something else")
        } else {
          List {
            ForEach(viewModel.filteredShows(allPlaces)) { place in
              NavigationLink(value: place) {
                ShowRowView(place: place)
              }
            }
            .onDelete { indexSet in
              let places = viewModel.filteredShows(allPlaces)
              for index in indexSet {
                viewModel.delete(places[index], context: modelContext)
              }
            }
          }
        }
      }
      .navigationTitle("Visited")
      .searchable(text: $vm.searchText, prompt: "Places, Categories, Addresses")
      .navigationDestination(for: FamilyPlace.self) { place in
        ShowDetailView(place: place)
      }
      .toolbar {
        Button("Add place!",
               systemImage: "plus") {
          viewModel.showingAddSheet = true
        }
      }
      .sheet(isPresented: $vm.showingAddSheet) {
        AddEditShowView(initialStatus: .visited)
      }
    }
  }
}

#Preview {
  AttendedView().modelContainer(for: FamilyPlace.self, inMemory: true)
}
