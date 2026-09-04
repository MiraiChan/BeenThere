import Foundation

public enum AppStrings {
  // Shared
  public static let cancel: LocalizedStringResource = "Cancel"
  public static let save: LocalizedStringResource = "Save"
  public static let delete: LocalizedStringResource = "Delete"
  public static let done: LocalizedStringResource = "Done"
  public static let name: LocalizedStringResource = "Name"
  public static let category: LocalizedStringResource = "Category"
  public static let address: LocalizedStringResource = "Address"
  public static let website: LocalizedStringResource = "Website"
  public static let date: LocalizedStringResource = "Date"
  public static let status: LocalizedStringResource = "Status"
  public static let notes: LocalizedStringResource = "Notes"
  public static let rating: LocalizedStringResource = "Rating"
  public static let add: LocalizedStringResource = "Add"
  public static let addActivity: LocalizedStringResource = "Add Activity"
  public static let addActivityLowercase: LocalizedStringResource = "Add activity"
  public static let activities: LocalizedStringResource = "Activities"
  public static let placeInfo: LocalizedStringResource = "Place Info"
  public static let editPlace: LocalizedStringResource = "Edit Place"
  public static let addPlace: LocalizedStringResource = "Add Place"
  
  // AddEditShowView
  public static let findLocation: LocalizedStringResource = "Find Location"
  public static let searchAppleMaps: LocalizedStringResource = "Search Apple Maps..."
  public static let addNotesPlaceholder: LocalizedStringResource = "Add notes..."
  public static func number(_ value: Int) -> LocalizedStringResource {
    return LocalizedStringResource("\(value)")
  }
  
  // AttendedView
  public static let visited: LocalizedStringResource = "Visited"
  public static let addPlaceExclamation: LocalizedStringResource = "Add place!"
  public static let searchPlaceholder: LocalizedStringResource = "Places, Categories, Addresses"
  public static let noPlacesYet: LocalizedStringResource = "No Places Yet"
  public static let noResults: LocalizedStringResource = "No Results"
  public static let startLogging: LocalizedStringResource = "Start logging for the places you've been to"
  public static let trySearching: LocalizedStringResource = "Try Searching for something else"
  
  // MainTabView
  public static let settings: LocalizedStringResource = "Settings"
  public static let wishlist: LocalizedStringResource = "Wishlist"
  
  // MarkAttendedSheet
  public static let markAsVisited: LocalizedStringResource = "Mark as Visited"
  public static let optionalRating: LocalizedStringResource = "Optional - you can always add rating later"
  public static func howWas(_ placeName: String) -> LocalizedStringResource {
    return LocalizedStringResource("How was \(placeName)?")
  }
  
  // Onboarding
  public static let enableNotifications: LocalizedStringResource = "Enable Notifications"
  public static let getNotifiedBefore: LocalizedStringResource = "Get notified before upcoming places so you're always ready!"
  public static let placeReminders: LocalizedStringResource = "Place Reminders"
  public static let youreAllSet: LocalizedStringResource = "You're all set!"
  public static let letsGo: LocalizedStringResource = "Let's go!"
  public static let continueBtn: LocalizedStringResource = "Continue"
  public static let neverMissAPlace: LocalizedStringResource = "Never miss a place"
  public static let saveUpcomingPlaces: LocalizedStringResource = "Save upcoming places and keep track of what's on your radar."
  public static let yourFamilyPlaces: LocalizedStringResource = "Your Family Places"
  public static let logEveryPlace: LocalizedStringResource =
  "Log every place you've visited. Build a record of your family's favorite spots."
  public static let everyDetailCaptured: LocalizedStringResource = "Every Detail Captured"
  public static let activitiesRatingsNotes: LocalizedStringResource =
  "Activities, ratings, notes - everything that made each visit unforgettable."
  
  // SettingsView
  public static let app: LocalizedStringResource = "App"
  public static let exportHistory: LocalizedStringResource = "Export History"
  public static let notifications: LocalizedStringResource = "Notifications"
  public static let placesVisited: LocalizedStringResource = "Places Visited"
  public static let privacyPolicy: LocalizedStringResource = "Privacy Policy"
  public static let showReminders: LocalizedStringResource = "Show Reminders"
  public static let termsOfUse: LocalizedStringResource = "Terms of Use"
  public static let topCategory: LocalizedStringResource = "Top Category"
  public static let version: LocalizedStringResource = "Version"
  public static let visitedThisYear: LocalizedStringResource = "Visited this year"
  public static let yourData: LocalizedStringResource = "Your Data"
  public static let yourStats: LocalizedStringResource = "Your Stats"
  
  // ShowDetailView
  public static let deletePlaceTitle: LocalizedStringResource = "Delete Place"
  public static let deletePlaceQuestion: LocalizedStringResource = "Delete Place?"
  public static let noActivitiesAdded: LocalizedStringResource = "No Activities Added"
  public static let noNotesAdded: LocalizedStringResource = "No notes added!"
  public static func permanentlyRemove(_ placeName: String) -> LocalizedStringResource {
    return LocalizedStringResource("This will permanently remove \(placeName) from your history")
  }
  
  // ShowRowView
  public static let hyphen: LocalizedStringResource = "-"
  public static let bullet: LocalizedStringResource = "•"
  
  // UpcomingView
  public static let nothingComingUp: LocalizedStringResource = "Nothing coming up"
  public static let savePlacesPlanning: LocalizedStringResource = "Save places you're planning to visit"
  
  // SettingsViewModel
  public static let myPlacesHistoryTitle: LocalizedStringResource = "My BeenThereBerlin Places History\n\n"
  public static let noPlacesLogged: LocalizedStringResource = "No Places Logged"
  
  // Share Extension
  public static let placeDetails: LocalizedStringResource = "Place Details"
  public static let categoryExample: LocalizedStringResource = "Category (e.g., Park, Museum)"
  public static let saveToBeenThere: LocalizedStringResource = "Save to BeenThere"
  public static let unknownPlace: LocalizedStringResource = "Unknown Place"
  public static let uncategorized: LocalizedStringResource = "Uncategorized"
  
  // System Images & Icons
  public enum Icons {
    public static let ellipsisCircle = "ellipsis.circle"
    public static let bellCircleFill = "bell.circle.fill"
    public static let checkmarkCircleFill = "checkmark.circle.fill"
    public static let figureWalk = "figure.walk"
    public static let star = "star"
    public static let gear = "gear"
    public static let squareAndArrowUp = "square.and.arrow.up"
    public static let plus = "plus"
    public static let starFill = "star.fill"
    public static let map = "map"
    public static let calendar = "calendar"
    public static let mapFill = "map.fill"
    public static let starCircleFill = "star.circle.fill"
  }
  
  // Empty string
  public static let empty = ""
  
  // URLs
  public static let googleMapsSearch = "https://www.google.com/maps/search/?api=1&query="
  public static let privacyPolicyURL = "https://miraichan.github.io/beenthere-privacy-policy/"
  public static let termsOfUseURL = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
}
