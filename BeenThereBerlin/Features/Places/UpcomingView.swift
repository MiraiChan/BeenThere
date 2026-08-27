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
          EmptyStateView(icon: AppStrings.Icons.calendar, title: AppStrings.nothingComingUp, message: AppStrings.savePlacesPlanning)
        } else {
          List {
            ForEach(viewModel.filteredShows(allPlaces)) { place in
              NavigationLink(value: place) {
                ShowRowView(place: place)
              }
              .swipeActions(edge: .leading) {
                Button(AppStrings.visited) {
                  viewModel.showToMarkAttended = place
                }
                .tint(.green)
              }
              .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button {
                  viewModel.delete(place, context: modelContext)
                } label: {
                  Label(AppStrings.delete, systemImage: "trash")
                }
                .tint(.accentColor)
                .foregroundStyle(Color.appPrimary)
              }
            }
          }
          .scrollContentBackground(.hidden)
        }
      }
      .background(Color.appPrimary)
      .navigationTitle(AppStrings.wishlist)
      .navigationDestination(for: FamilyPlace.self) { place in
        ShowDetailView(place: place)
      }
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button(AppStrings.addPlace, systemImage: AppStrings.Icons.plus) {
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
