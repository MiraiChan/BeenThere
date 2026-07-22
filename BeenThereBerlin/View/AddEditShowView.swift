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
    }
}

#Preview {
    AddEditShowView()
}
