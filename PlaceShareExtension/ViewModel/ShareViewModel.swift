//
//  ShareViewModel.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 03.09.26.
//
import Foundation
import Combine
import OSLog

@MainActor
final class ShareViewModel: ObservableObject {
  
  @Published var placeName = ""
  @Published var address = ""
  @Published var category = ""
  
  let extensionContext: NSExtensionContext?
  
  init(extensionContext: NSExtensionContext?) {
    self.extensionContext = extensionContext
  }
  
  func loadSharedData() {
    guard let items = extensionContext?.inputItems as? [NSExtensionItem] else {
      AppLogger.shareViewModel.warning("No input items found in extension context.")
      return
    }
    
    Task {
      let parser = ShareDataParser()
      let data = await parser.parse(inputItems: items)
      
      self.placeName = data.placeName
      self.address = data.address
      self.category = data.category
    }
  }
}
