//
//  AddEditShowView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 30.06.26.
//

import SwiftUI
import SwiftData

struct AddEditShowView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: AddEditShowViewModel
  
  let existingShow: Show?
  
  init(show: Show? = nil, initialStatus: ShowStatus = .upcoming) {
    self.existingShow = show
    self._viewModel = State(initialValue: AddEditShowViewModel(show: show, initialStatus: initialStatus))
  }
  var body: some View {
    @Bindable var vm = viewModel
    
    NavigationStack {
      Form {
        Section("Show Info") {
          TextField("Artist", text: $vm.artistName)
          TextField("Venue", text: $vm.venueName)
          TextField("Location", text: $vm.location)
          DatePicker("Date", selection: $vm.date, displayedComponents: .date)
          Picker("Status", selection: $vm.status) {
            ForEach(ShowStatus.allCases, id:\.self) { status in
              Text(status.rawValue.capitalized)
                .tag(status)
            }
          }
        }
        
        Section("Notes") {
          TextField("Add notes...", text: $vm.notes, axis: .vertical)
            .lineLimit(3...6)
        }
        
        Section("Setlist") {
          ForEach(viewModel.setlist.indices, id: \.self) { index in
            HStack {
              Text("\(index + 1)")
                .foregroundStyle(.secondary)
                .frame(width: 28, alignment: .leading)
              Text(viewModel.setlist[index])
            }
          }
          .onDelete {
            viewModel.setlist.remove(atOffsets: $0)
          }
          .onMove {
            viewModel.setlist.move(fromOffsets: $0, toOffset: $1)
          }
          
          TextField("Add Song" , text: $vm.newSetlistEntry)
          Button("Add") {
            viewModel.addSetlistEntry()
          }
          .disabled(viewModel.newSetlistEntry
            .trimmingCharacters(in: .whitespaces).isEmpty)
        }
      }
      .navigationTitle(existingShow == nil ? "Add Show" : "Edit Show")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
            viewModel.save(to: modelContext, existing: existingShow)
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
