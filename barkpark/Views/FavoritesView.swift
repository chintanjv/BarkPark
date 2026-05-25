import SwiftUI

// MARK: - Favorites View
// Shows all parks the user has marked as favorites.
// Accessible from the bottom tab bar.

struct FavoritesView: View {
    @EnvironmentObject var store: ParkStore

    var body: some View {
        NavigationStack {
            Group {
                if store.favoritedParks.isEmpty {
                    // Empty state
                    VStack(spacing: DesignTokens.spacingLG) {
                        Image(systemName: "heart")
                            .font(.system(size: 48, weight: .light))
                            .foregroundColor(.surfaceContainerHigh)

                        Text("No Favorites Yet")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.textPrimary)

                        Text("Tap the heart icon on any park\nto save it here.")
                            .font(.system(size: 15))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: DesignTokens.spacingLG) {
                            ForEach(store.favoritedParks) { park in
                                NavigationLink(destination: ParkDetailView(park: park).environmentObject(store)) {
                                    FavoritesParkRow(park: park)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, DesignTokens.spacingXL)
                        .padding(.top, DesignTokens.spacingLG)
                    }
                }
            }
            .background(Color.surface)
            .navigationTitle("Favorites")
        }
    }
}

// MARK: - Favorites Park Row

struct FavoritesParkRow: View {
    let park: DogPark

    var body: some View {
        HStack(spacing: DesignTokens.spacingLG) {
            // Placeholder image
            ParkPlaceholderImage(
                color: park.placeholderColor,
                icon: "leaf.fill",
                size: 70
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusSM))

            VStack(alignment: .leading, spacing: 4) {
                Text(park.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)

                Text(park.address)
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    StarRatingDisplay(
                        rating: park.averageRating,
                        count: park.ratingCount,
                        compact: true
                    )

                    Text("•")
                        .foregroundColor(.textSecondary)

                    Text("\(String(format: "%.1f", park.distanceMiles)) mi")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.surfaceContainerHigh)
        }
        .padding(DesignTokens.spacingLG)
        .background(Color.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))
    }
}

