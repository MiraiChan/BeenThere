//
//  ShowDetailView.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 28.07.26.
//

import SwiftUI

struct ShowDetailView: View {
  @Bindable var show: Show
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @State private var showingEditSheet = false
  @State private var showingDeleteAlert = false
  @State private var newSetlistEntry = ""
  
  @Environment
    var body: some View {
        
    }
}
