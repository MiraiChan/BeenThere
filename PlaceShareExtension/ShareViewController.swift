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
            log("No input items.")
            return 
        }
        
        for item in items {
            DispatchQueue.main.async {
                if let title = item.attributedTitle?.string, !title.isEmpty {
                    self.log("Title: \(title)")
                    let cleanTitle = title.replacingOccurrences(of: " - Google Search", with: "")
                                          .replacingOccurrences(of: " - Google Maps", with: "")
                    if !cleanTitle.starts(with: "http") && self.placeName.isEmpty { 
                        self.placeName = cleanTitle 
                    }
                }
                if let contentText = item.attributedContentText?.string, !contentText.isEmpty {
                    self.log("Content: \(contentText)")
                    self.parse(text: contentText)
                }
            }
            
            guard let attachments = item.attachments else { 
                self.log("No attachments.")
                continue 
            }
            
            for attachment in attachments {
                self.log("Types: \(attachment.registeredTypeIdentifiers.joined(separator: ", "))")
                
                if attachment.canLoadObject(ofClass: String.self) {
                    attachment.loadObject(ofClass: String.self) { [weak self] (string, error) in
                        if let text = string as? String {
                            self?.log("Loaded String: \(text.prefix(30))...")
                            DispatchQueue.main.async {
                                self?.parse(text: text)
                            }
                        }
                    }
                }
                
                if attachment.canLoadObject(ofClass: URL.self) {
                    attachment.loadObject(ofClass: URL.self) { [weak self] (url, error) in
                        if let url = url as? URL {
                            self?.log("Loaded URL: \(url.absoluteString)")
                            DispatchQueue.main.async {
                                self?.parse(url: url)
                            }
                        }
                    }
                }
                
                if attachment.hasItemConformingToTypeIdentifier(UTType.vCard.identifier) {
                    attachment.loadDataRepresentation(forTypeIdentifier: UTType.vCard.identifier) { [weak self] (data, error) in
                        if let data = data, let text = String(data: data, encoding: .utf8) {
                            self?.log("Loaded vCard Data Rep")
                            DispatchQueue.main.async { self?.parse(vCard: text) }
                        }
                    }
                }
            }
        }
    }
    
    func parse(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        if url.host?.contains("maps.apple.com") == true {
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
                let pathComponents = url.path.components(separatedBy: "/")
                if let placeIndex = pathComponents.firstIndex(of: "place"), placeIndex + 1 < pathComponents.count {
                    let name = pathComponents[placeIndex + 1].replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? ""
                    if placeName.isEmpty { placeName = name }
                }
            } else if url.path.contains("/search") {
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
        
        if placeName.isEmpty {
            let provider = LPMetadataProvider()
            provider.startFetchingMetadata(for: url) { [weak self] metadata, error in
                if let title = metadata?.title, !title.isEmpty {
                    DispatchQueue.main.async {
                        if self?.placeName.isEmpty == true {
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
            .navigationTitle("Save to Been There")
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

