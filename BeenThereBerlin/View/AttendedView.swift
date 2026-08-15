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
          EmptyStateView(icon: AppStrings.Icons.map, title: viewModel.searchText.isEmpty ? AppStrings.noPlacesYet : AppStrings.noResults, message: viewModel.searchText.isEmpty ? AppStrings.startLogging : AppStrings.trySearching)
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
      .navigationTitle(AppStrings.visited)
      .searchable(text: $vm.searchText, prompt: AppStrings.searchPlaceholder)
      .navigationDestination(for: FamilyPlace.self) { place in
        ShowDetailView(place: place)
      }
      .toolbar {
        Button(AppStrings.addPlaceExclamation,
               systemImage: AppStrings.Icons.plus) {
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
