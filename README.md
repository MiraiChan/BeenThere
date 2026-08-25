# BeenThere 📍

An elegant, modern iOS application built to help families and explorers log, track, and curate their favorite spots around the city. From wishlist tracking to saving memories of visited places, BeenThere serves as your personal, private travel diary.

## Features

- **Personalized Wishlists & History:** Keep a curated list of places you plan to visit and a detailed history of the places you've already been.
- **Interactive Maps (MapKit):** Visualize your logged places on a map. View exact coordinates and drop pins instantly. 
- **Share Extension Integration:** Seamlessly save places to your wishlist directly from Safari, Apple Maps, or Google Maps using the native iOS Share Sheet. The app automatically extracts metadata (titles, URLs, and addresses) to keep logging frictionless.
- **Rich Logging:** Track dates, status, custom categories, personalized notes, interactive star ratings, and lists of activities for each location.
- **Data Persistence (SwiftData):** Built from the ground up using Apple's modern SwiftData framework for blazing fast, reliable local storage.
- **Dynamic Search & Filtering:** Quickly search through your places by name, category, or address.
- **Fully Localized UI:** Built with Apple's modern String Catalogs (`.xcstrings`), making the app fully ready for multi-language support and pluralization.

## Tech Stack & Architecture

- **Language:** Swift 5.10+
- **Framework:** SwiftUI (Declarative UI, modern state management via `@Bindable`, `@State`, `@Environment`)
- **Database:** SwiftData (Schema creation, ModelContainer, ModelContext)
- **APIs:** MapKit, UniformTypeIdentifiers, LinkPresentation
- **Extensions:** Share Extension (App Extension architecture, NSExtensionContext, App Groups for shared data containers)
- **Localization:** String Catalogs (.xcstrings)
- **Minimum iOS Version:** iOS 17.0+

## Technical Highlights (For Recruiters/Reviewers)

1. **Modern Apple Frameworks:** Demonstrates a deep understanding of the newest Apple technologies, prominently featuring **SwiftData** over CoreData for persistence, and **SwiftUI** for a highly responsive, animated, and declarative user interface.
2. **App Extensions & Data Sharing:** Includes a robust **Share Extension** that parses deep links, vCards, and metadata in real-time. It uses `LinkPresentation` to fetch URL metadata on the fly and communicates with the main app via a shared App Group container.
3. **Clean Architecture:** Separates concerns efficiently using the MVVM pattern alongside SwiftUI's environment. Strings and constants are safely abstracted, and the UI is cleanly split into modular views.
4. **Attention to UX/UI:** Focuses heavily on the user experience—utilizing native iOS components like Sheets, native Apple Maps integration, interactive star ratings, and polished lists. 
5. **Modern Localization:** Leverages the new String Catalogs for a robust and scalable approach to handling string localization, pluralization, and variable interpolation, ensuring the app is globally accessible. 

## How to Run

1. Clone this repository.
2. Open `BeenThere.xcodeproj` in Xcode 15 or later.
3. Select an iOS 17.0+ Simulator or physical device.
4. Hit `Cmd + R` to build and run the application.

*Note: To test the Share Extension, run the scheme for the extension and choose Safari or Maps as the host application when prompted.*

---

**Built with ❤️**
