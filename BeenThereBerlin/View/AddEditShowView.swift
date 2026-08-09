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
  
  let existingPlace: FamilyPlace?
  
  init(place: FamilyPlace? = nil, initialStatus: VisitStatus = .wishlist) {
    self.existingPlace = place
    self._viewModel = State(initialValue: AddEditShowViewModel(place: place, initialStatus: initialStatus))
  }
  var body: some View {
    @Bindable var vm = viewModel
    
    NavigationStack {
      Form {
        Section("Find Location") {
          TextField("Search Apple Maps...", text: Binding(
            get: { vm.searchQuery },
            set: { vm.updateSearchQuery($0) }
          ))
          
          if !vm.searchResults.isEmpty {
            ForEach(vm.searchResults, id: \.self) { result in
              Button(action: {
                vm.select(completion: result)
              }) {
                VStack(alignment: .leading) {
                  Text(result.title)
                    .foregroundStyle(.primary)
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
        
        Section("Place Info") {
          TextField("Name", text: $vm.placeName)
          TextField("Category", text: $vm.category)
          TextField("Address", text: $vm.address)
          DatePicker("Date", selection: $vm.date, displayedComponents: .date)
          Picker("Status", selection: $vm.status) {
            ForEach(VisitStatus.allCases, id:\.self) { status in
              Text(status.rawValue.capitalized)
                .tag(status)
            }
          }
        }
        
        if viewModel.status == .visited {
          Section("Rating") {
            StarRatingView(rating: $vm.rating)
              .padding(.vertical, 4)
          }
        }
        
        Section("Notes") {
          TextField("Add notes...", text: $vm.notes, axis: .vertical)
            .lineLimit(3...6)
        }
        
        Section("Activities") {
          ForEach(viewModel.activities.indices, id: \.self) { index in
            HStack {
              Text("\(index + 1)")
                .foregroundStyle(.secondary)
                .frame(width: 28, alignment: .leading)
              Text(viewModel.activities[index])
            }
          }
          .onDelete {
            viewModel.activities.remove(atOffsets: $0)
          }
          .onMove {
            viewModel.activities.move(fromOffsets: $0, toOffset: $1)
          }
          
          TextField("Add Activity" , text: $vm.newActivityEntry)
          Button("Add") {
            viewModel.addSetlistEntry()
          }
          .disabled(viewModel.newActivityEntry
            .trimmingCharacters(in: .whitespaces).isEmpty)
        }
      }
      .navigationTitle(existingPlace == nil ? "Add Place" : "Edit Place")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
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
