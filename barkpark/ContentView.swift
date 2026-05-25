import SwiftUI

// MARK: - Content View (Main Tab Bar)
// This is the root view of the app, showing the bottom tab bar
// exactly as in the "Home/Map View" mockup.

struct ContentView: View {
    @StateObject private var store = ParkStore()
    @State private var selectedTab: Tab = .explore

    enum Tab {
        case explore, search, favorites, profile
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Explore (Map)
            MapExploreView()
                .environmentObject(store)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Explore")
                }
                .tag(Tab.explore)

            // Tab 2: Search (List view of parks)
            SearchListView()
                .environmentObject(store)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(Tab.search)

            // Tab 3: Favorites
            FavoritesView()
                .environmentObject(store)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .tag(Tab.favorites)

            // Tab 4: Profile (placeholder)
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(Tab.profile)
        }
        .tint(.leafGreen)  // Green accent color for selected tab
    }
}

// MARK: - Search List View
// A simple list view of all parks (alternative to map discovery)

struct SearchListView: View {
    @EnvironmentObject var store: ParkStore
    @State private var searchText: String = ""

    var filteredParks: [DogPark] {
        if searchText.isEmpty {
            return store.parks
        }
        return store.parks.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.address.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: DesignTokens.spacingLG) {
                    ForEach(filteredParks) { park in
                        NavigationLink(destination: ParkDetailView(park: park).environmentObject(store)) {
                            SearchParkRow(park: park)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, DesignTokens.spacingXL)
                .padding(.top, DesignTokens.spacingMD)
            }
            .background(Color.surface)
            .navigationTitle("Dog Parks")
            .searchable(text: $searchText, prompt: "Search parks...")
        }
    }
}

// MARK: - Search Park Row

struct SearchParkRow: View {
    let park: DogPark

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMD) {
            // Image
            ParkPlaceholderImage(
                color: park.placeholderColor,
                icon: "leaf.fill",
                size: 200
            )
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))

            // Info
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(park.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.textPrimary)

                    Spacer()

                    StarRatingDisplay(
                        rating: park.averageRating,
                        count: park.ratingCount,
                        compact: true
                    )
                }

                Text(park.address)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)

                HStack(spacing: 6) {
                    Text("\(String(format: "%.1f", park.distanceMiles)) mi")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.leafGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.leafGreen.opacity(0.12))
                        .clipShape(Capsule())

                    if park.isFenced {
                        MiniChip(text: "FENCED")
                    }

                    MiniChip(text: park.sizeCategory.rawValue.uppercased())
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(DesignTokens.spacingLG)
        .background(Color.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))
    }
}

// MARK: - Profile View (Placeholder)
// Simple placeholder for the profile tab

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: DesignTokens.spacingXL) {
                // Avatar
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.leafGreen, .leafGreenLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 36, weight: .light))
                            .foregroundColor(.white)
                    )

                Text("Dog Park Explorer")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.textPrimary)

                Text("Your ratings and photos are saved locally on this device.")
                    .font(.system(size: 15))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                // Stats
                HStack(spacing: 32) {
                    StatBubble(value: "6", label: "Parks\nNearby")
                    StatBubble(value: "0", label: "Photos\nAdded")
                    StatBubble(value: "0", label: "Ratings\nGiven")
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding(.top, 40)
            .background(Color.surface)
            .navigationTitle("Profile")
        }
    }
}

struct StatBubble: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.leafGreen)

            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
        .padding(.vertical, DesignTokens.spacingLG)
        .background(Color.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))
    }
}

