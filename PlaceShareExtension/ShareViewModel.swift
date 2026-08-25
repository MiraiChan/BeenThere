import SwiftUI
import UniformTypeIdentifiers
import LinkPresentation
import Social
import Combine

class ShareViewModel: ObservableObject {
    @Published var placeName: String = ""
    @Published var address: String = ""
    @Published var category: String = ""
    
    let extensionContext: NSExtensionContext?
    
    init(extensionContext: NSExtensionContext?) {
        self.extensionContext = extensionContext
    }
    
    func log(_ message: String) {
        #if DEBUG
        print("ShareExtension: \(message)")
        #endif
    }
    
    func loadSharedData() {
        guard let items = extensionContext?.inputItems as? [NSExtensionItem] else { 
            return 
        }
        
        for item in items {
            DispatchQueue.main.async {
                if let title = item.attributedTitle?.string, !title.isEmpty {
                    let cleanTitle = title.replacingOccurrences(of: " - Google Search", with: "")
                                          .replacingOccurrences(of: " - Google Maps", with: "")
                    if !cleanTitle.starts(with: "http") && self.placeName.isEmpty { 
                        self.placeName = cleanTitle 
                    }
                }
                if let contentText = item.attributedContentText?.string, !contentText.isEmpty {
                    self.parse(text: contentText)
                }
            }
            
            guard let attachments = item.attachments else { 
                continue 
            }
            
            for attachment in attachments {
                if attachment.canLoadObject(ofClass: String.self) {
                    attachment.loadObject(ofClass: String.self) { [weak self] (string, error) in
                        if let text = string as? String {
                            DispatchQueue.main.async {
                                self?.parse(text: text)
                            }
                        }
                    }
                }
                
                if attachment.canLoadObject(ofClass: URL.self) {
                    attachment.loadObject(ofClass: URL.self) { [weak self] (url, error) in
                        if let url = url as? URL {
                            DispatchQueue.main.async {
                                self?.parse(url: url)
                            }
                        }
                    }
                }
                
                if attachment.hasItemConformingToTypeIdentifier(UTType.vCard.identifier) {
                    attachment.loadDataRepresentation(forTypeIdentifier: UTType.vCard.identifier) { [weak self] (data, error) in
                        if let data = data, let text = String(data: data, encoding: .utf8) {
                            DispatchQueue.main.async { self?.parse(vCard: text) }
                        }
                    }
                }
            }
        }
    }
    
    func parse(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        var isMapLink = false
        
        if url.host?.contains("maps.apple.com") == true {
            isMapLink = true
            if let queryItems = components.queryItems {
                if let q = queryItems.first(where: { $0.name == "q" })?.value {
                    if placeName.isEmpty { placeName = q }
                }
                if let addr = queryItems.first(where: { $0.name == "address" })?.value {
                    if address.isEmpty { address = addr }
                }
            }
        } else if url.host?.contains("google.com") == true || url.host?.contains("goo.gl") == true {
            if url.path.contains("/maps/place/") {
                isMapLink = true
                let pathComponents = url.path.components(separatedBy: "/")
                if let placeIndex = pathComponents.firstIndex(of: "place"), placeIndex + 1 < pathComponents.count {
                    let name = pathComponents[placeIndex + 1].replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? ""
                    if placeName.isEmpty { placeName = name }
                }
            } else if url.path.contains("/search") {
                isMapLink = true
                if let queryItems = components.queryItems {
                    if let q = queryItems.first(where: { $0.name == "q" })?.value {
                        if placeName.isEmpty { placeName = q.replacingOccurrences(of: "+", with: " ") }
                    }
                }
            }
        }
        if address.isEmpty {
            address = url.absoluteString
        }
        
        if !isMapLink && category.isEmpty {
            category = "Website"
        }
        
        if placeName.isEmpty {
            let fallbackName = url.host ?? "Shared Link"
            placeName = fallbackName
            
            let provider = LPMetadataProvider()
            provider.startFetchingMetadata(for: url) { [weak self] metadata, error in
                if let title = metadata?.title, !title.isEmpty {
                    DispatchQueue.main.async {
                        if self?.placeName == fallbackName || self?.placeName.isEmpty == true {
                            self?.placeName = title
                        }
                    }
                }
            }
        }
    }
    
    func parse(text: String) {
        let lines = text.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        
        for line in lines {
            if line.starts(with: "http") { 
                if address.isEmpty { address = line }
                if let url = URL(string: line) {
                    parse(url: url)
                }
                continue 
            }
            
            let cleanLine = line.replacingOccurrences(of: " - Google Search", with: "")
                                .replacingOccurrences(of: " - Google Maps", with: "")
            
            if placeName.isEmpty {
                placeName = cleanLine
            } else if address.isEmpty && cleanLine != placeName {
                address = cleanLine
            }
        }
    }
    
    func parse(vCard: String) {
        let lines = vCard.components(separatedBy: .newlines)
        for line in lines {
            if line.starts(with: "FN:") {
                let name = line.replacingOccurrences(of: "FN:", with: "")
                if placeName.isEmpty { placeName = name }
            } else if line.contains("ADR") {
                let parts = line.components(separatedBy: ":")
                if parts.count >= 2 {
                    let valuePart = parts[1...].joined(separator: ":")
                    let components = valuePart.components(separatedBy: ";")
                    if components.count >= 7 {
                        let street = components[2].trimmingCharacters(in: .whitespaces)
                        let city = components[3].trimmingCharacters(in: .whitespaces)
                        let zip = components[5].trimmingCharacters(in: .whitespaces)
                        let fullAddress = [street, zip, city].filter { !$0.isEmpty }.joined(separator: ", ")
                        if !fullAddress.isEmpty {
                            // Only replace the address if it was empty or if it was just a URL
                            if address.isEmpty || address.starts(with: "http") {
                                address = fullAddress
                            }
                        }
                    }
                }
            }
        }
    }
}
