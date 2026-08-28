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
    hostingController.view.backgroundColor = .clear
    
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
        Section(header: Text(AppStrings.placeDetails)) {
          TextField(AppStrings.name, text: $viewModel.placeName)
          TextField(AppStrings.address, text: $viewModel.address)
        }
        .appRowBackground()
        
        Section(header: Text(AppStrings.category)) {
          TextField(AppStrings.categoryExample, text: $viewModel.category)
        }
        .appRowBackground()
      }
      .scrollContentBackground(.hidden)
      .background(Color.appPrimary)
      .navigationTitle(Text(AppStrings.saveToBeenThere))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(AppStrings.cancel) {
            viewModel.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
          }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button(AppStrings.save) {
            savePlace()
          }
          .disabled(viewModel.placeName.isEmpty)
          .tint(Color(red: 0.733, green: 0.035, blue: 0.043))
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
      let newPlace = FamilyPlace(placeName: viewModel.placeName.isEmpty ? String(localized: AppStrings.unknownPlace) : viewModel.placeName,
                                 category: viewModel.category.isEmpty ? String(localized: AppStrings.uncategorized) : viewModel.category,
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

fileprivate extension View {
  func appRowBackground() -> some View {
    listRowBackground(
      Rectangle()
        .fill(.thinMaterial)
    )
  }
}

fileprivate extension Color {
  static let appPrimary = Color(UIColor { traitCollection in
    if traitCollection.userInterfaceStyle == .dark {
      return UIColor(red: 0x0F / 255.0, green: 0x0F / 255.0, blue: 0x12 / 255.0, alpha: 1.0)
    } else {
      return UIColor(red: 0xF9 / 255.0, green: 0xF4 / 255.0, blue: 0xEE / 255.0, alpha: 1.0)
    }
  })
}
