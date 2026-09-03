//
//  ShareDataParser.swift
//  PlaceShareExtension
//
//  Created by Almira Khafizova on 03.09.26.
//
import Foundation
import LinkPresentation
import UniformTypeIdentifiers
import OSLog

struct ShareDataResult {
    var placeName: String?
    var address: String?
    var category: String?
    var overwriteAddress: Bool = false
    var foundURLs: [URL] = []
}

final class ShareDataParser {
    
    private var placeName = ""
    private var address = ""
    private var category = ""
    
    private let textParser = ShareTextParser()
    private let urlParser = ShareURLParser()
    private let vCardParser = ShareVCardParser()
    
    func parse(inputItems: [NSExtensionItem]) async -> ShareData {
        AppLogger.shareViewModel.debug("Processing \(inputItems.count) input items.")
        
        for item in inputItems {
            await processItem(item)
        }
        
        return ShareData(
            placeName: placeName,
            address: address,
            category: category
        )
    }
    
    // MARK: - Item Processing
    
    private func processItem(_ item: NSExtensionItem) async {
        processTitle(item.attributedTitle?.string)
        await processContentText(item.attributedContentText?.string)
        
        guard let attachments = item.attachments else {
            return
        }
        
        for attachment in attachments {
            await processAttachment(attachment)
        }
    }
    
    private func processTitle(_ title: String?) {
        guard let title, !title.isEmpty else { return }
        
        let cleanTitle = title.cleanedForSharing()
        
        guard !cleanTitle.hasPrefix("http"), placeName.isEmpty else { return }
        
        placeName = cleanTitle
    }
    
    private func processContentText(_ text: String?) async {
        guard let text, !text.isEmpty else { return }
        
        let result = textParser.parse(
            text: text,
            currentPlaceName: placeName,
            currentAddress: address
        )
        await apply(result)
    }
    
    // MARK: - Attachments
    
    private func processAttachment(_ attachment: NSItemProvider) async {
        if attachment.hasItemConformingToTypeIdentifier(UTType.vCard.identifier) {
            await loadVCard(from: attachment)
        } else if attachment.canLoadObject(ofClass: URL.self) {
            await loadURL(from: attachment)
        } else if attachment.canLoadObject(ofClass: String.self) {
            await loadString(from: attachment)
        }
    }
    
    private func loadString(from attachment: NSItemProvider) async {
        let string: String? = await withCheckedContinuation { continuation in
            _ = attachment.loadObject(ofClass: String.self) { string, error in
                if let error {
                    AppLogger.shareViewModel.error("Failed to load string attachment: \(error.localizedDescription)")
                }
                continuation.resume(returning: string)
            }
        }
        
        if let string {
            let result = textParser.parse(
                text: string,
                currentPlaceName: placeName,
                currentAddress: address
            )
            await apply(result)
        }
    }
    
    private func loadURL(from attachment: NSItemProvider) async {
        let url: URL? = await withCheckedContinuation { continuation in
            _ = attachment.loadObject(ofClass: URL.self) { url, error in
                if let error {
                    AppLogger.shareViewModel.error("Failed to load URL attachment: \(error.localizedDescription)")
                }
                continuation.resume(returning: url)
            }
        }
        
        if let url {
            let result = await urlParser.parse(
                url: url,
                currentPlaceName: placeName,
                currentCategory: category
            )
            await apply(result)
        }
    }
    
    private func loadVCard(from attachment: NSItemProvider) async {
        let text: String? = await withCheckedContinuation { continuation in
            _ = attachment.loadDataRepresentation(
                forTypeIdentifier: UTType.vCard.identifier
            ) { data, error in
                if let error {
                    AppLogger.shareViewModel.error("Failed to load vCard attachment: \(error.localizedDescription)")
                }
                if let data, let text = String(data: data, encoding: .utf8) {
                    continuation.resume(returning: text)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
        
        if let text {
            let result = vCardParser.parse(vCard: text, currentPlaceName: placeName)
            await apply(result)
        }
    }
    
    // MARK: - Helpers
    
    private func apply(_ result: ShareDataResult) async {
        if let name = result.placeName, !name.isEmpty, placeName.isEmpty {
            placeName = name
            AppLogger.shareViewModel.debug("Parsed placeName: \(name)")
        }
        
        if let addr = result.address, !addr.isEmpty {
            if address.isEmpty || (result.overwriteAddress && address.hasPrefix("http")) {
                address = addr
                AppLogger.shareViewModel.debug("Parsed address: \(addr)")
            }
        }
        
        if let cat = result.category, !cat.isEmpty, category.isEmpty {
            category = cat
        }
        
        for url in result.foundURLs {
            let urlResult = await urlParser.parse(
                url: url,
                currentPlaceName: placeName,
                currentCategory: category
            )
            await apply(urlResult)
        }
    }
}

extension String {
    func cleanedForSharing() -> String {
        self
            .replacingOccurrences(of: " - Google Search", with: "")
            .replacingOccurrences(of: " - Google Maps", with: "")
    }
}
