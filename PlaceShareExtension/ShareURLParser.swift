//
//  ShareURLParser.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 03.09.26.
//
import Foundation
import LinkPresentation
import OSLog

final class ShareURLParser {
    
    func parse(url: URL, currentPlaceName: String, currentCategory: String) async -> ShareDataResult {
        var result = ShareDataResult()
        
        guard let components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        ) else {
            return result
        }
        
        if isAppleMapsURL(url) {
            parseAppleMapsURL(components, result: &result, currentPlaceName: currentPlaceName)
            return result
        }
        
        if isGoogleMapsURL(url) {
            await parseGoogleMapsURL(
                url,
                components: components,
                result: &result,
                currentPlaceName: currentPlaceName,
                currentCategory: currentCategory
            )
            return result
        }
        
        await parseWebsiteURL(
            url,
            result: &result,
            currentPlaceName: currentPlaceName,
            currentCategory: currentCategory
        )
        return result
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
    
    private func parseAppleMapsURL(_ components: URLComponents, result: inout ShareDataResult, currentPlaceName: String) {
        if let queryItems = components.queryItems {
            if currentPlaceName.isEmpty {
                result.placeName = queryItems.first(where: { $0.name == "q" })?.value
            }
            result.address = queryItems.first(where: { $0.name == "address" })?.value
        }
    }
    
    private func parseGoogleMapsURL(
        _ url: URL,
        components: URLComponents,
        result: inout ShareDataResult,
        currentPlaceName: String,
        currentCategory: String
    ) async {
        if url.path.contains("/maps/place/") {
            parseGooglePlaceURL(url, result: &result, currentPlaceName: currentPlaceName)
            return
        }
        
        if url.path.contains("/search") {
            parseGoogleSearchURL(components, result: &result, currentPlaceName: currentPlaceName)
            return
        }
        
        result.address = url.absoluteString
        if currentCategory.isEmpty {
            result.category = "Maps"
        }
        await loadMetadataIfNeeded(for: url, result: &result, currentPlaceName: currentPlaceName)
    }
    
    private func parseGooglePlaceURL(_ url: URL, result: inout ShareDataResult, currentPlaceName: String) {
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
        
        if currentPlaceName.isEmpty {
            result.placeName = name
        }
    }
    
    private func parseGoogleSearchURL(_ components: URLComponents, result: inout ShareDataResult, currentPlaceName: String) {
        guard let query = components.queryItems?.first(where: { $0.name == "q" })?.value else {
            return
        }
        
        if currentPlaceName.isEmpty {
            result.placeName = query.replacingOccurrences(of: "+", with: " ")
        }
    }
    
    private func parseWebsiteURL(
        _ url: URL,
        result: inout ShareDataResult,
        currentPlaceName: String,
        currentCategory: String
    ) async {
        result.address = url.absoluteString
        
        if currentCategory.isEmpty {
            result.category = "Website"
        }
        await loadMetadataIfNeeded(for: url, result: &result, currentPlaceName: currentPlaceName)
    }
    
    private func loadMetadataIfNeeded(for url: URL, result: inout ShareDataResult, currentPlaceName: String) async {
        guard currentPlaceName.isEmpty && result.placeName == nil else {
            return
        }
        
        let fallbackName = url.host ?? "Shared Link"
        result.placeName = fallbackName
        
        let provider = LPMetadataProvider()
        let metadata: LPLinkMetadata? = await withCheckedContinuation { continuation in
            provider.startFetchingMetadata(for: url) { metadata, error in
                if let error {
                    AppLogger.shareViewModel.error("Failed to fetch metadata for \(url.absoluteString): \(error.localizedDescription)")
                }
                continuation.resume(returning: metadata)
            }
        }
        
        guard let title = metadata?.title, !title.isEmpty else {
            return
        }
        
        if result.placeName == fallbackName || (result.placeName?.isEmpty ?? true) {
            result.placeName = title
        }
    }
}
