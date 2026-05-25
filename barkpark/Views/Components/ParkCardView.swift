import SwiftUI

// MARK: - Park Card View
// The floating card that appears at the bottom of the map
// when a park pin is tapped. Matches the design mockup.

struct ParkCardView: View {
    let park: DogPark
    var onDetailsTap: () -> Void

    var body: some View {
        HStack(spacing: DesignTokens.spacingLG) {
            // Park placeholder image (left side)
            ParkPlaceholderImage(
                color: park.placeholderColor,
                icon: "leaf.fill",
                size: 80
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusSM))

            // Park info (right side)
            VStack(alignment: .leading, spacing: 6) {
                // Distance pill + Rating
                HStack {
                    Text("\(String(format: "%.1f", park.distanceMiles)) mi")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.leafGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.leafGreen.opacity(0.12))
                        .clipShape(Capsule())

                    Spacer()

                    StarRatingDisplay(
                        rating: park.averageRating,
                        count: park.ratingCount,
                        compact: true
                    )
                }

                // Park name
                Text(park.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                // Attribute chips
                HStack(spacing: 6) {
                    if park.isFenced {
                        MiniChip(text: "FENCED")
                    }
                    MiniChip(text: park.sizeCategory.rawValue.uppercased())
                }

                // Description + Details button
                HStack {
                    Text(park.description)
                        .font(.system(size: 11))
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)

                    Spacer()

                    Button(action: onDetailsTap) {
                        Text("Details")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                LinearGradient(
                                    colors: [.leafGreen, .leafGreenLight],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(DesignTokens.spacingLG)
        .background(Color.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))
        .shadow(
            color: DesignTokens.shadowColor,
            radius: DesignTokens.shadowRadius,
            x: 0,
            y: DesignTokens.shadowY
        )
    }
}

// MARK: - Mini Chip
// Small attribute tags (FENCED, ALL SIZES, etc.)

struct MiniChip: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .bold))
            .tracking(0.5)
            .foregroundColor(.textSecondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.surfaceContainerHigh)
            .clipShape(Capsule())
    }
}

// MARK: - Park Placeholder Image
// Generates a beautiful gradient placeholder with an icon
// since we don't have real park photos

struct ParkPlaceholderImage: View {
    let color: PlaceholderColor
    var icon: String = "leaf.fill"
    var size: CGFloat = 200

    var body: some View {
        ZStack {
            LinearGradient(
                colors: color.colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: icon)
                .font(.system(size: size * 0.25, weight: .light))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(width: size, height: size)
    }
}

