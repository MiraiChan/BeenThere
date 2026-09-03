//
//  ShareVCardParser.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 03.09.26.
//
import Foundation

final class ShareVCardParser {
    
    func parse(vCard: String, currentPlaceName: String) -> ShareDataResult {
        var result = ShareDataResult()
        let lines = unfoldedLines(from: vCard)
        
        for line in lines {
            if line.hasPrefix("FN:") {
                if currentPlaceName.isEmpty && result.placeName == nil {
                    result.placeName = line.replacingOccurrences(of: "FN:", with: "")
                }
                continue
            }
            
            if line.hasPrefix("ADR:") || line.hasPrefix("ADR;") {
                if let address = parseVCardAddress(line) {
                    result.address = address
                    result.overwriteAddress = true
                }
            }
        }
        
        return result
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
    
    private func parseVCardAddress(_ line: String) -> String? {
        let parts = line.components(separatedBy: ":")
        guard parts.count >= 2 else { return nil }
        
        let valuePart = parts.dropFirst().joined(separator: ":")
        let components = splitRespectingEscapes(valuePart, separator: ";")
        
        guard components.count >= 7 else { return nil }
        
        let street = components[2].trimmingCharacters(in: .whitespaces)
        let city = components[3].trimmingCharacters(in: .whitespaces)
        let zip = components[5].trimmingCharacters(in: .whitespaces)
        
        let fullAddress = [street, zip, city]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
        
        guard !fullAddress.isEmpty else { return nil }
        
        return fullAddress
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
}
