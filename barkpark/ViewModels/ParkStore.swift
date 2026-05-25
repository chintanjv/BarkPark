import Foundation
import SwiftUI
import MapKit

// MARK: - ParkStore
// This is the "brain" of the app. It holds all the parks data,
// handles filtering, ratings, favorites, and photo storage.
// It's an ObservableObject so SwiftUI views automatically update
// when any @Published property changes.

class ParkStore: ObservableObject {

    // @Published means: when this changes, all views watching it will redraw
    @Published var parks: [DogPark]
    @Published var filter: ParkFilter = ParkFilter()
    @Published var selectedPark: DogPark? = nil
    @Published var showingFilter: Bool = false
    @Published var showingRating: Bool = false
    @Published var searchText: String = ""

    // Map region centered on San Jose
    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3382, longitude: -121.8863),
        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    )

    init() {
        self.parks = MockData.parks
        loadSavedData()
    }

    // MARK: - Filtered Parks
    // Returns parks that match the current filter criteria

    var filteredParks: [DogPark] {
        var result = parks

        // Filter by search text
        if !searchText.isEmpty {
            result = result.filter { park in
                park.name.localizedCaseInsensitiveContains(searchText) ||
                park.address.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Filter by distance
        result = result.filter { $0.distanceMiles <= filter.maxDistanceMiles }

        // Filter by amenities
        if !filter.selectedAmenities.isEmpty {
            result = result.filter { park in
                let parkAmenityNames = Set(park.amenities.map { $0.name })
                return filter.selectedAmenities.isSubset(of: parkAmenityNames)
            }
        }

        // Filter by dog size
        if let size = filter.selectedSize {
            result = result.filter { $0.sizeCategory == size || $0.sizeCategory == .allSizes }
        }

        // Filter by fenced requirement
        if filter.requireFenced {
            result = result.filter { $0.isFenced }
        }

        return result
    }

    // MARK: - Actions

    /// Add a star rating (1-5) to a park
    func addRating(_ rating: Int, to parkID: UUID) {
        guard let index = parks.firstIndex(where: { $0.id == parkID }) else { return }
        parks[index].ratings.append(rating)
        saveData()
    }

    /// Toggle favorite status for a park
    func toggleFavorite(for parkID: UUID) {
        guard let index = parks.firstIndex(where: { $0.id == parkID }) else { return }
        parks[index].isFavorite.toggle()
        saveData()
    }

    /// Add a vibe vote to a park
    func addVibeVote(_ vibe: String, to parkID: UUID) {
        guard let index = parks.firstIndex(where: { $0.id == parkID }) else { return }
        parks[index].vibeVotes[vibe, default: 0] += 1
        saveData()
    }

    /// Cast a thumbs up/down vote on a quick check item
    func voteOnAmenity(_ question: String, thumbsUp: Bool, parkID: UUID) {
        guard let index = parks.firstIndex(where: { $0.id == parkID }) else { return }
        var vote = parks[index].amenityVotes[question] ?? AmenityVote(thumbsUp: 0, thumbsDown: 0)
        if thumbsUp {
            vote.thumbsUp += 1
        } else {
            vote.thumbsDown += 1
        }
        parks[index].amenityVotes[question] = vote
        saveData()
    }

    /// Add a user photo (as Data) to a park
    func addPhoto(_ data: Data, to parkID: UUID) {
        guard let index = parks.firstIndex(where: { $0.id == parkID }) else { return }
        parks[index].userPhotoData.append(data)
        saveData()
    }

    /// Reset all filters to defaults
    func resetFilters() {
        filter = ParkFilter()
    }

    /// Get favorite parks
    var favoritedParks: [DogPark] {
        parks.filter { $0.isFavorite }
    }

    // MARK: - Persistence (UserDefaults)
    // We save ratings, favorites, votes, and photos to UserDefaults
    // so they persist between app launches.
    // NOTE: For a production app you'd use Core Data or files,
    // but UserDefaults is perfect for our MVP.

    private func saveData() {
        // Save ratings
        var ratingsDict: [String: [Int]] = [:]
        var favoritesDict: [String: Bool] = [:]
        for park in parks {
            ratingsDict[park.name] = park.ratings
            favoritesDict[park.name] = park.isFavorite
        }
        if let encoded = try? JSONEncoder().encode(ratingsDict) {
            UserDefaults.standard.set(encoded, forKey: "parkRatings")
        }
        if let encoded = try? JSONEncoder().encode(favoritesDict) {
            UserDefaults.standard.set(encoded, forKey: "parkFavorites")
        }
    }

    private func loadSavedData() {
        // Load saved ratings
        if let data = UserDefaults.standard.data(forKey: "parkRatings"),
           let ratingsDict = try? JSONDecoder().decode([String: [Int]].self, from: data) {
            for (index, park) in parks.enumerated() {
                if let savedRatings = ratingsDict[park.name] {
                    parks[index].ratings = savedRatings
                }
            }
        }
        // Load saved favorites
        if let data = UserDefaults.standard.data(forKey: "parkFavorites"),
           let favoritesDict = try? JSONDecoder().decode([String: Bool].self, from: data) {
            for (index, park) in parks.enumerated() {
                if let isFav = favoritesDict[park.name] {
                    parks[index].isFavorite = isFav
                }
            }
        }
    }
}

