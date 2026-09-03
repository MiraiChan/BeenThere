//
//  AppLogger.swift
//  BeenThere
//
//  Created by Almira Khafizova on 03.09.26.
//
import OSLog

enum AppLogger {
  static let shareViewModel = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "BeenThere",
    category: "ShareViewModel"
  )
  
  static let shareDataParser = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "BeenThere",
    category: "ShareDataParser"
  )
  
  static let addEditShowViewModel = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "BeenThere",
    category: "AddEditShowViewModel"
  )
}
