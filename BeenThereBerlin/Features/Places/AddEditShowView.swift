//
//  AddEditShowView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 30.06.26.
//

import SwiftUI
import SwiftData
import MapKit

struct AddEditShowView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: AddEditShowViewModel
  @FocusState private var isSearchFocused: Bool
  
  let existingPlace: FamilyPlace?
  
  init(place: FamilyPlace? = nil, initialStatus: VisitStatus = .wishlist) {
    self.existingPlace = place
    self._viewModel = State(initialValue: AddEditShowViewModel(place: place, initialStatus: initialStatus))
  }
  var body: some View {
    @Bindable var vm = viewModel
    
    NavigationStack {
      Form {
        Section(AppStrings.findLocation) {
          TextField(AppStrings.searchAppleMaps, text: Binding(
            get: { vm.searchQuery },
            set: { vm.updateSearchQuery($0) }
          ), prompt: Text(AppStrings.searchAppleMaps).foregroundColor(Color.appSecondary.opacity(0.6)))
          .foregroundStyle(Color.appPrimary)
          .tint(Color.accentColor)
          .listRowBackground(
            Color.appSecondary.opacity(vm.searchQuery.isEmpty ? 0.1 : 0.9)
          )
          .focused($isSearchFocused)
          
          if !vm.searchResults.isEmpty {
            ForEach(vm.searchResults, id: \.self) { result in
              Button(action: {
                vm.select(completion: result)
              }) {
                VStack(alignment: .leading) {
                  Text(result.title)
                    .foregroundStyle(Color.appSecondary)
                  if !result.subtitle.isEmpty {
                    Text(result.subtitle)
                      .font(.caption)
                      .foregroundStyle(.secondary)
                  }
                }
              }
            }
          }
        }
        .appRowBackground()
        
        Section(AppStrings.placeInfo) {
          TextField(AppStrings.name, text: $vm.placeName)
          TextField(AppStrings.category, text: $vm.category)
          TextField(AppStrings.address, text: $vm.address)
          DatePicker(AppStrings.date, selection: $vm.date, displayedComponents: .date)
          Picker(AppStrings.status, selection: $vm.status) {
            ForEach(VisitStatus.allCases, id:\.self) { status in
              Text(status.localizedTitle)
                .tag(status)
            }
          }
        }
        .appRowBackground()
        
        if viewModel.status == .visited {
          Section(AppStrings.rating) {
            StarRatingView(rating: $vm.rating)
              .padding(.vertical, 4)
          }
          .appRowBackground()
        }
        
        Section(AppStrings.notes) {
          TextField(AppStrings.addNotesPlaceholder, text: $vm.notes, axis: .vertical)
            .lineLimit(3...6)
        }
        .appRowBackground()
        
        Section(AppStrings.activities) {
          ForEach(viewModel.activities.indices, id: \.self) { index in
            HStack {
              Text(AppStrings.number(index + 1))
                .foregroundStyle(.secondary)
                .frame(width: 28, alignment: .leading)
              Text(viewModel.activities[index])
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
              Button(role: .destructive) {
                viewModel.activities.remove(at: index)
              } label: {
                Label("", systemImage: "trash")
                  .symbolRenderingMode(.palette)
                  .foregroundStyle(Color.appPrimary)
              }
              .tint(.accentColor)
            }
          }
          .onMove {
            viewModel.activities.move(fromOffsets: $0, toOffset: $1)
          }
          
          TextField(AppStrings.addActivity, text: $vm.newActivityEntry)
          Button(AppStrings.add) {
            viewModel.addSetlistEntry()
          }
          .disabled(viewModel.newActivityEntry
            .trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .appRowBackground()
      }
      
      .onAppear {
        isSearchFocused = true
      }
      
      .scrollContentBackground(.hidden)
      .background(Color.appPrimary)
      .navigationTitle(existingPlace == nil ? AppStrings.addPlace : AppStrings.editPlace)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(AppStrings.cancel) { dismiss() }
            .tint(Color.appSecondary)
        }
        ToolbarItem(placement: .confirmationAction) {
          Button(AppStrings.save) {
            viewModel.save(to: modelContext, existing: existingPlace)
            dismiss()
          }
          .disabled(!viewModel.isValid)
        }
      }
    }
  }
}

#Preview {
  AddEditShowView()
}
