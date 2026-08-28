//
//  ShareViewController.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 28.08.26.
//

import UIKit
import SwiftUI
import SwiftData
import UniformTypeIdentifiers
import Social
import Combine
import LinkPresentation

class ShareViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let contentView = ShareExtensionView(extensionContext: self.extensionContext)
    let hostingController = UIHostingController(rootView: contentView)
    
    self.addChild(hostingController)
    self.view.addSubview(hostingController.view)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
    
    hostingController.didMove(toParent: self)
  }
}

struct ShareExtensionView: View {
  @StateObject private var viewModel: ShareViewModel
  
  init(extensionContext: NSExtensionContext?) {
    _viewModel = StateObject(wrappedValue: ShareViewModel(extensionContext: extensionContext))
  }
  
  var body: some View {
    NavigationStack {
      Form {
        Section(header: Text("Place Details")) {
          TextField("Name", text: $viewModel.placeName)
          TextField("Address", text: $viewModel.address)
        }
        
        Section(header: Text("Category")) {
          TextField("Category (e.g., Park, Museum)", text: $viewModel.category)
        }
      }
      .navigationTitle("Save to BeenThere")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            viewModel.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Save") {
            savePlace()
          }
          .disabled(viewModel.placeName.isEmpty)
        }
      }
    }
    .onAppear {
      viewModel.loadSharedData()
    }
  }
  
  func savePlace() {
    do {
      let schema = Schema([FamilyPlace.self])
      let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, groupContainer: .identifier("group.AlmiraKhafizova.BeenThere"))
      let sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
      
      let context = ModelContext(sharedModelContainer)
      let newPlace = FamilyPlace(placeName: viewModel.placeName.isEmpty ? "Unknown Place" : viewModel.placeName,
                                 category: viewModel.category.isEmpty ? "Uncategorized" : viewModel.category,
                                 address: viewModel.address,
                                 date: .now,
                                 status: .wishlist)
      
      context.insert(newPlace)
      try context.save()
      
      viewModel.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    } catch {
      viewModel.log("Failed to save: \(error.localizedDescription)")
      print("Failed to create container or save: \(error)")
    }
  }
}
