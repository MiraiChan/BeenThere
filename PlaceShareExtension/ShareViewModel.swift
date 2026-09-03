//
//  ShareViewModel.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 03.09.26.
//
import Foundation
import Combine
import UniformTypeIdentifiers
import LinkPresentation
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
    
    AppLogger.shareViewModel.debug("Processing \(items.count) input items.")
    for item in items {
      processItem(item)
    }
  }
  
  // MARK: - Item Processing
  
  private func processItem(_ item: NSExtensionItem) {
    processTitle(item.attributedTitle?.string)
    processContentText(item.attributedContentText?.string)
    
    guard let attachments = item.attachments else {
      return
    }
    
    for attachment in attachments {
      processAttachment(attachment)
    }
  }
  
  private func processTitle(_ title: String?) {
    guard
      let title,
      !title.isEmpty
    else {
      return
    }
    
    let cleanTitle = cleanedText(title)
    
    guard
      !cleanTitle.hasPrefix("http"),
      placeName.isEmpty
    else {
      return
    }
    
    placeName = cleanTitle
  }
  
  private func processContentText(_ text: String?) {
    guard
      let text,
      !text.isEmpty
    else {
      return
    }
    
    parse(text: text)
  }
  
  // MARK: - Attachments
  
  private func processAttachment(_ attachment: NSItemProvider) {
    if attachment.hasItemConformingToTypeIdentifier(UTType.vCard.identifier) {
      loadVCard(from: attachment)
    } else if attachment.canLoadObject(ofClass: URL.self) {
      loadURL(from: attachment)
    } else if attachment.canLoadObject(ofClass: String.self) {
      loadString(from: attachment)
    }
  }
  
  private func loadString(from attachment: NSItemProvider) {
    _ = attachment.loadObject(ofClass: String.self) { [weak self] string, error in
      if let error {
        AppLogger.shareViewModel.error("Failed to load string attachment: \(error.localizedDescription)")
      }
      guard let string else {
        return
      }
      
      Task { @MainActor [weak self] in
        self?.parse(text: string)
      }
    }
  }
  
  private func loadURL(from attachment: NSItemProvider) {
    _ = attachment.loadObject(ofClass: URL.self) { [weak self] url, error in
      if let error {
        AppLogger.shareViewModel.error("Failed to load URL attachment: \(error.localizedDescription)")
      }
      guard let url else {
        return
      }
      
      Task { @MainActor [weak self] in
        self?.parse(url: url)
      }
    }
  }
  
  private func loadVCard(from attachment: NSItemProvider) {
    _ = attachment.loadDataRepresentation(
      forTypeIdentifier: UTType.vCard.identifier
    ) { [weak self] data, error in
      if let error {
        AppLogger.shareViewModel.error("Failed to load vCard attachment: \(error.localizedDescription)")
      }
      guard
        let data,
        let text = String(data: data, encoding: .utf8)
      else {
        return
      }
      
      Task { @MainActor [weak self] in
        self?.parse(vCard: text)
      }
    }
  }
  
  // MARK: - URL Parsing
  
  func parse(url: URL) {
    guard let components = URLComponents(
      url: url,
      resolvingAgainstBaseURL: false
    ) else {
      return
    }
    
    if isAppleMapsURL(url) {
      parseAppleMapsURL(components)
      return
    }
    
    if isGoogleMapsURL(url) {
      parseGoogleMapsURL(url, components: components)
      return
    }
    
    parseWebsiteURL(url)
  }
  
  private func isAppleMapsURL(_ url: URL) -> Bool {
    url.host?.contains("maps.apple.com") == true
  }
  
  private func isGoogleMapsURL(_ url: URL) -> Bool {
    guard let host = url.host else {
      return false
    }
    
    return host.contains("google.com") || host.contains("goo.gl")
  }
  
  private func parseAppleMapsURL(_ components: URLComponents) {
    if let queryItems = components.queryItems {
      setPlaceNameIfNeeded(
        queryItems.first(where: { $0.name == "q" })?.value
      )
      
      setAddressIfNeeded(
        queryItems.first(where: { $0.name == "address" })?.value
      )
    }
  }
  
  private func parseGoogleMapsURL(
    _ url: URL,
    components: URLComponents
  ) {
    if url.path.contains("/maps/place/") {
      parseGooglePlaceURL(url)
      return
    }
    
    if url.path.contains("/search") {
      parseGoogleSearchURL(components)
      return
    }
    
    setAddressIfNeeded(url.absoluteString)
    if category.isEmpty {
      category = "Maps"
    }
    loadMetadataIfNeeded(for: url)
  }
  
  private func parseGooglePlaceURL(_ url: URL) {
    let pathComponents = url.path.components(separatedBy: "/")
    
    guard
      let placeIndex = pathComponents.firstIndex(of: "place"),
      placeIndex + 1 < pathComponents.count
    else {
      return
    }
    
    let name = pathComponents[placeIndex + 1]
      .replacingOccurrences(of: "+", with: " ")
      .removingPercentEncoding ?? ""
    
    setPlaceNameIfNeeded(name)
  }
  
  private func parseGoogleSearchURL(_ components: URLComponents) {
    guard let query = components.queryItems?.first(where: { $0.name == "q" })?.value else {
      return
    }
    
    setPlaceNameIfNeeded(
      query.replacingOccurrences(of: "+", with: " ")
    )
  }
  
  private func parseWebsiteURL(_ url: URL) {
    setAddressIfNeeded(url.absoluteString)
    
    guard category.isEmpty else {
      loadMetadataIfNeeded(for: url)
      return
    }
    
    category = "Website"
    loadMetadataIfNeeded(for: url)
  }
  
  private func loadMetadataIfNeeded(for url: URL) {
    guard placeName.isEmpty else {
      return
    }
    
    let fallbackName = url.host ?? "Shared Link"
    placeName = fallbackName
    
    let provider = LPMetadataProvider()
    
    provider.startFetchingMetadata(for: url) { [weak self] metadata, error in
      if let error {
        AppLogger.shareViewModel.error("Failed to fetch metadata for \(url.absoluteString): \(error.localizedDescription)")
      }
      guard
        let title = metadata?.title,
        !title.isEmpty
      else {
        return
      }
      
      Task { @MainActor [weak self] in
        guard
          let self,
          self.placeName == fallbackName || self.placeName.isEmpty
        else {
          return
        }
        
        self.placeName = title
      }
    }
  }
  
  // MARK: - Text Parsing
  
  func parse(text: String) {
    let lines = text
      .components(separatedBy: .newlines)
      .map { $0.trimmingCharacters(in: .whitespaces) }
      .filter { !$0.isEmpty }
    
    for line in lines {
      parseTextLine(line)
    }
  }
  
  private func parseTextLine(_ line: String) {
    if line.hasPrefix("http") {
      parseURLLine(line)
      return
    }
    
    let cleanLine = cleanedText(line)
    
    guard !cleanLine.isEmpty else {
      return
    }
    
    setPlaceNameOrAddress(cleanLine)
  }
  
  private func parseURLLine(_ line: String) {
    setAddressIfNeeded(line)
    
    guard let url = URL(string: line) else {
      return
    }
    
    parse(url: url)
  }
  
  private func setPlaceNameOrAddress(_ value: String) {
    if placeName.isEmpty {
      placeName = value
      AppLogger.shareViewModel.debug("Parsed placeName: \(value)")
    } else if address.isEmpty && value != placeName {
      address = value
      AppLogger.shareViewModel.debug("Parsed address: \(value)")
    }
  }
  
  // MARK: - vCard Parsing
  
  func parse(vCard: String) {
    let lines = unfoldedLines(from: vCard)
    
    for line in lines {
      if line.hasPrefix("FN:") {
        parseVCardName(line)
        continue
      }
      
      if line.hasPrefix("ADR:") || line.hasPrefix("ADR;") {
        parseVCardAddress(line)
      }
    }
  }
  
  private func unfoldedLines(from vCard: String) -> [String] {
    let rawLines = vCard.components(separatedBy: .newlines)
    var result: [String] = []
    
    for line in rawLines {
      if line.hasPrefix(" ") || line.hasPrefix("\t"), !result.isEmpty {
        result[result.count - 1] += line.dropFirst()
      } else {
        result.append(line)
      }
    }
    
    return result
  }
  
  private func parseVCardName(_ line: String) {
    guard placeName.isEmpty else {
      return
    }
    
    let name = line.replacingOccurrences(of: "FN:", with: "")
    placeName = name
  }
  
  private func parseVCardAddress(_ line: String) {
    let parts = line.components(separatedBy: ":")
    
    guard parts.count >= 2 else {
      return
    }
    
    let valuePart = parts
      .dropFirst()
      .joined(separator: ":")
    
    let components = splitRespectingEscapes(valuePart, separator: ";")
    
    guard components.count >= 7 else {
      return
    }
    
    let street = components[2].trimmingCharacters(in: .whitespaces)
    let city = components[3].trimmingCharacters(in: .whitespaces)
    let zip = components[5].trimmingCharacters(in: .whitespaces)
    
    let fullAddress = [street, zip, city]
      .filter { !$0.isEmpty }
      .joined(separator: ", ")
    
    guard
      !fullAddress.isEmpty,
      address.isEmpty || address.hasPrefix("http")
    else {
      return
    }
    
    address = fullAddress
  }
  
  private func splitRespectingEscapes(_ value: String, separator: Character) -> [String] {
    var components: [String] = []
    var current = ""
    var isEscaped = false
    
    for char in value {
      if isEscaped {
        current.append(char)
        isEscaped = false
      } else if char == "\\" {
        isEscaped = true
      } else if char == separator {
        components.append(current)
        current = ""
      } else {
        current.append(char)
      }
    }
    
    components.append(current)
    return components
  }
  
  // MARK: - Helpers
  
  private func setPlaceNameIfNeeded(_ value: String?) {
    guard
      let value,
      !value.isEmpty,
      placeName.isEmpty
    else {
      return
    }
    
    placeName = value
    AppLogger.shareViewModel.debug("Parsed placeName: \(value)")
  }
  
  private func setAddressIfNeeded(_ value: String?) {
    guard
      let value,
      !value.isEmpty,
      address.isEmpty
    else {
      return
    }
    
    address = value
    AppLogger.shareViewModel.debug("Parsed address: \(value)")
  }
  
  private func cleanedText(_ text: String) -> String {
    text
      .replacingOccurrences(of: " - Google Search", with: "")
      .replacingOccurrences(of: " - Google Maps", with: "")
  }
}
