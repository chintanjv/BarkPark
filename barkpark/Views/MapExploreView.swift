import SwiftUI
import MapKit

// MARK: - Map Explore View
// The main screen of the app. Shows a map with dog park pins,
// a search bar at the top, and a floating card when a pin is tapped.

struct MapExploreView: View {
    @EnvironmentObject var store: ParkStore
    @State private var selectedParkForDetail: DogPark? = nil
    @State private var navigateToDetail: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // === MAP ===
                Map(
                    coordinateRegion: $store.mapRegion,
                    showsUserLocation: true,
                    annotationItems: store.filteredParks
                ) { park in
                    MapAnnotation(coordinate: park.coordinate) {
                        // Custom pin marker
                        ParkMapPin(
                            isSelected: store.selectedPark?.id == park.id,
                            name: park.name
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                store.selectedPark = park
                            }
                        }
                    }
                }
                .ignoresSafeArea(edges: .top)

                // === SEARCH BAR OVERLAY ===
                VStack(spacing: 0) {
                    SearchBarView(
                        text: $store.searchText,
                        onFilterTap: { store.showingFilter = true }
                    )
                    .padding(.horizontal, DesignTokens.spacingLG)
                    .padding(.top, 8)

                    Spacer()
                }

                // === FLOATING PARK CARD (bottom) ===
                if let park = store.selectedPark {
                    VStack {
                        Spacer()
                        ParkCardView(park: park) {
                            selectedParkForDetail = park
                            navigateToDetail = true
                        }
                        .padding(.horizontal, DesignTokens.spacingLG)
                        .padding(.bottom, 12)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .sheet(isPresented: $store.showingFilter) {
                FilterView()
                    .environmentObject(store)
            }
            // Navigation to park detail (iOS 16 NavigationStack API)
            .navigationDestination(isPresented: $navigateToDetail) {
                if let park = selectedParkForDetail {
                    ParkDetailView(park: park)
                        .environmentObject(store)
                } else {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Custom Map Pin
// The green pin marker shown on the map for each park

struct ParkMapPin: View {
    var isSelected: Bool
    var name: String

    var body: some View {
        VStack(spacing: 2) {
            // Pin bubble
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.leafGreen, .leafGreenLight],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(
                        width: isSelected ? 44 : 32,
                        height: isSelected ? 44 : 32
                    )
                    .shadow(color: Color.leafGreen.opacity(0.3), radius: 8, y: 4)

                Image(systemName: "pawprint.fill")
                    .font(.system(size: isSelected ? 18 : 13, weight: .semibold))
                    .foregroundColor(.white)
            }

            // Name label (shown when selected)
            if isSelected {
                Text(name.uppercased())
                    .font(.system(size: 8, weight: .bold))
                    .tracking(0.5)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.leafGreen)
                    .clipShape(Capsule())
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Search Bar
// Floating search bar at the top of the map

struct SearchBarView: View {
    @Binding var text: String
    var onFilterTap: () -> Void

    var body: some View {
        HStack(spacing: DesignTokens.spacingSM) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.textSecondary)

            TextField("Search by park name or location", text: $text)
                .font(.system(size: 15))
                .foregroundColor(.textPrimary)

            Button(action: onFilterTap) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .padding(8)
                    .background(Color.surfaceContainerHigh)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, DesignTokens.spacingLG)
        .padding(.vertical, DesignTokens.spacingMD)
        .background(
            Color.surfaceContainerLowest.opacity(0.92)
        )
        .clipShape(Capsule())
        .shadow(color: DesignTokens.shadowColor, radius: 20, y: 6)
    }
}

