import Foundation
import CoreLocation
import SwiftUI

// MARK: - Dog Park Model
// The main data structure representing a dog park

struct DogPark: Identifiable {
    let id: UUID
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let distanceMiles: Double
    let walkTimeMinutes: Int
    let isFenced: Bool
    let hasSeparatedSections: Bool
    let sizeCategory: DogSizeCategory
    let amenities: [Amenity]
    let highlights: [String]
    let description: String
    let placeholderColor: PlaceholderColor  // Used for generated placeholder images
    var ratings: [Int]                       // Array of 1-5 star ratings
    var amenityVotes: [String: AmenityVote]  // Votes for amenity quality
    var vibeVotes: [String: Int]             // How many times each vibe tag was selected
    var userPhotoData: [Data]                // Photos added by user (stored as Data)
    var isFavorite: Bool

    // Computed: average star rating
    var averageRating: Double {
        guard !ratings.isEmpty else { return 0 }
        return Double(ratings.reduce(0, +)) / Double(ratings.count)
    }

    // Computed: total number of ratings
    var ratingCount: Int {
        return ratings.count
    }

    // Computed: CLLocationCoordinate2D for MapKit
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Supporting Types

enum DogSizeCategory: String, CaseIterable {
    case smallDogs = "Small Dogs"
    case largeDogs = "Large Dogs"
    case allSizes = "All Sizes"

    var icon: String {
        switch self {
        case .smallDogs: return "hare.fill"
        case .largeDogs: return "pawprint.fill"
        case .allSizes: return "pawprint.circle.fill"
        }
    }
}

struct Amenity: Identifiable, Hashable {
    let id: UUID
    let name: String
    let icon: String       // SF Symbol name
    let subtitle: String

    init(name: String, icon: String, subtitle: String = "") {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.subtitle = subtitle
    }
}

struct AmenityVote {
    var thumbsUp: Int
    var thumbsDown: Int
}

// Placeholder colors for generated park images
enum PlaceholderColor: CaseIterable {
    case green, blue, orange, purple, teal

    var colors: [Color] {
        switch self {
        case .green:  return [Color(hex: "34C759"), Color(hex: "006E28")]
        case .blue:   return [Color(hex: "5AC8FA"), Color(hex: "0058BC")]
        case .orange: return [Color(hex: "FF9500"), Color(hex: "FF6B00")]
        case .purple: return [Color(hex: "AF52DE"), Color(hex: "7B2FBE")]
        case .teal:   return [Color(hex: "5AC8FA"), Color(hex: "30B0C7")]
        }
    }
}

// MARK: - Filter Model
// Tracks the current filter state

struct ParkFilter {
    var maxDistanceMiles: Double = 20.0
    var selectedAmenities: Set<String> = []
    var selectedSize: DogSizeCategory? = nil
    var requireFenced: Bool = false
}

// MARK: - Predefined Amenities
// The master list of amenities available across all parks

struct AmenityList {
    static let all: [Amenity] = [
        Amenity(name: "Water Fountain", icon: "drop.fill", subtitle: "Dual height stations"),
        Amenity(name: "Dog Wash", icon: "drop.circle.fill", subtitle: "Self-service station"),
        Amenity(name: "Shade", icon: "sun.max.fill", subtitle: "Covered pavilions"),
        Amenity(name: "Off-leash", icon: "figure.walk", subtitle: "Fully secure area"),
        Amenity(name: "Agility", icon: "figure.run", subtitle: "Equipment available"),
        Amenity(name: "Parking", icon: "car.fill", subtitle: "Free lot"),
        Amenity(name: "Restrooms", icon: "building.2.fill", subtitle: "On-site facilities"),
        Amenity(name: "Lighting", icon: "lightbulb.fill", subtitle: "Evening hours"),
    ]
}

// MARK: - Quick Check Items (for Rating flow)
struct QuickCheckItem: Identifiable {
    let id = UUID()
    let question: String
    let icon: String
    let color: Color
}

let quickCheckItems: [QuickCheckItem] = [
    QuickCheckItem(question: "Fresh Water?", icon: "drop.fill", color: .skyBlue),
    QuickCheckItem(question: "Good Shade?", icon: "leaf.fill", color: .leafGreen),
    QuickCheckItem(question: "Clean Area?", icon: "sparkles", color: .orange),
]

// MARK: - Vibe Tags (for Rating flow)
let vibeTags: [String] = [
    "Clean", "Crowded", "Well-maintained",
    "Spacious", "Great Community", "Quiet",
    "Friendly Dogs", "Good for Puppies"
]
