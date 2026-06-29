//
//  BeenThereBerlinApp.swift
//  BeenThereBerlin
//
//  Created by Almira Khafizova on 27.06.26.
//

import SwiftUI
import SwiftData

@main
struct BeenThereBerlinApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: Show.self)
    }
}
