import SwiftUI

// MARK: - Star Rating View (Interactive)
// Shows 5 stars that the user can tap to select a rating.
// Used in the Rating flow screen.

struct StarRatingView: View {
    @Binding var rating: Int  // The currently selected rating (1-5)
    var maxRating: Int = 5
    var starSize: CGFloat = 36
    var spacing: CGFloat = 8

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .font(.system(size: starSize, weight: .medium))
                    .foregroundColor(star <= rating ? .ratingGold : Color.surfaceContainerHigh)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            rating = star
                        }
                    }
            }
        }
    }
}

// MARK: - Star Rating Display (Read-Only)
// Shows the average rating with a star icon.
// Used on cards and detail views.

struct StarRatingDisplay: View {
    var rating: Double
    var count: Int
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: compact ? 11 : 13, weight: .semibold))
                .foregroundColor(.ratingGold)

            Text(String(format: "%.1f", rating))
                .font(.system(size: compact ? 12 : 14, weight: .bold))
                .foregroundColor(.textPrimary)

            if count > 0 {
                Text("(\(count))")
                    .font(.system(size: compact ? 11 : 13, weight: .regular))
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

