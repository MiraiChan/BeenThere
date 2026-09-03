//
//  ShareTextParser.swift
//  PlaceShareExtension
//
//  Created by Almira Khafizova on 03.09.26.
//
import Foundation

final class ShareTextParser {
    
    func parse(
        text: String,
        currentPlaceName: String,
        currentAddress: String
    ) -> ShareDataResult {
        var result = ShareDataResult()
        var tempPlaceName = currentPlaceName
        var tempAddress = currentAddress
        
        let lines = text
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        for line in lines {
            if line.hasPrefix("http") {
                if tempAddress.isEmpty {
                    result.address = line
                    tempAddress = line
                }
                
                if let url = URL(string: line) {
                    result.foundURLs.append(url)
                }
            } else {
                let cleanLine = line.cleanedForSharing()
                guard !cleanLine.isEmpty else { continue }
                
                if tempPlaceName.isEmpty {
                    result.placeName = cleanLine
                    tempPlaceName = cleanLine
                } else if tempAddress.isEmpty && cleanLine != tempPlaceName {
                    result.address = cleanLine
                    tempAddress = cleanLine
                }
            }
        }
        
        return result
    }
}
