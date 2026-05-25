import SwiftUI

// MARK: - Rating View
// The "Rating & Contribution Flow" screen from the mockup.
// Presented as a sheet from the Park Detail View.
// Includes: star rating, vibe tags, quick check voting, notes, and submit.

struct RatingView: View {
    let park: DogPark
    @EnvironmentObject var store: ParkStore
    @Environment(\.dismiss) var dismiss

    @State private var starRating: Int = 0
    @State private var selectedVibes: Set<String> = []
    @State private var quickCheckVotes: [String: Bool?] = [:]  // nil = no vote, true = up, false = down
    @State private var quickNote: String = ""
    @State private var hasSubmitted: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: DesignTokens.spacingXXL) {

                    // === DOG AVATAR ===
                    dogAvatarSection

                    // === QUESTION ===
                    Text("How was your visit to\n**\(park.name)**?")
                        .font(.system(size: 22))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.textPrimary)

                    // === STAR RATING ===
                    starRatingSection

                    // === DESCRIBE THE VIBE ===
                    vibeSection

                    // === QUICK CHECK ===
                    quickCheckSection

                    // === QUICK NOTE ===
                    quickNoteSection

                    // === SUBMIT BUTTON ===
                    submitButton

                    // Footer message
                    Text("Your feedback helps improve \(park.name) for everyone.")
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal, DesignTokens.spacingXL)
                .padding(.top, DesignTokens.spacingLG)
            }
            .background(Color.surface)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.textPrimary)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Rate \(park.name)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textPrimary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Dog avatar in nav
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: park.placeholderColor.colors,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "pawprint.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        )
                }
            }
        }
    }

    // MARK: - Dog Avatar Section

    private var dogAvatarSection: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: park.placeholderColor.colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 80, height: 80)
            .overlay(
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 30, weight: .light))
                    .foregroundColor(.white.opacity(0.7))
            )
            .shadow(color: Color.leafGreen.opacity(0.2), radius: 16, y: 8)
    }

    // MARK: - Star Rating Section

    private var starRatingSection: some View {
        VStack(spacing: 8) {
            StarRatingView(rating: $starRating, starSize: 40, spacing: 12)

            Text("TAP TO RATE")
                .font(.system(size: 10, weight: .bold))
                .tracking(1.5)
                .foregroundColor(.textSecondary)
        }
    }

    // MARK: - Vibe Tags Section

    private var vibeSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMD) {
            Text("DESCRIBE THE VIBE")
                .font(.system(size: 11, weight: .bold))
                .tracking(1.2)
                .foregroundColor(.textSecondary)

            ChipFlowView(
                items: vibeTags,
                selected: selectedVibes,
                onTap: { vibe in
                    if selectedVibes.contains(vibe) {
                        selectedVibes.remove(vibe)
                    } else {
                        selectedVibes.insert(vibe)
                    }
                }
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Quick Check Section

    private var quickCheckSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMD) {
            Text("QUICK CHECK")
                .font(.system(size: 11, weight: .bold))
                .tracking(1.2)
                .foregroundColor(.textSecondary)

            VStack(spacing: DesignTokens.spacingSM) {
                ForEach(quickCheckItems) { item in
                    QuickCheckRow(
                        item: item,
                        vote: quickCheckVotes[item.question] ?? nil,
                        onVote: { isUp in
                            quickCheckVotes[item.question] = isUp
                        }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Quick Note Section

    private var quickNoteSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMD) {
            Text("ADD A QUICK NOTE (OPTIONAL)")
                .font(.system(size: 11, weight: .bold))
                .tracking(1.2)
                .foregroundColor(.textSecondary)

            TextField("Anything else we should know?", text: $quickNote)
                .font(.system(size: 15))
                .padding(DesignTokens.spacingLG)
                .background(Color.surfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Submit Button

    private var submitButton: some View {
        Button(action: submitRating) {
            HStack(spacing: 8) {
                Text("Submit Rating")
                    .font(.system(size: 17, weight: .semibold))
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 14))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: starRating > 0 ? [.leafGreen, .leafGreenLight] : [.surfaceContainerHighest, .surfaceContainerHighest],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Capsule())
        }
        .disabled(starRating == 0)
        .scaleEffect(starRating > 0 ? 1.0 : 0.98)
        .animation(.easeInOut(duration: 0.2), value: starRating)
    }

    // MARK: - Submit Logic

    private func submitRating() {
        guard starRating > 0 else { return }

        // Save star rating
        store.addRating(starRating, to: park.id)

        // Save vibe votes
        for vibe in selectedVibes {
            store.addVibeVote(vibe, to: park.id)
        }

        // Save quick check votes
        for (question, vote) in quickCheckVotes {
            if let isUp = vote {
                store.voteOnAmenity(question, thumbsUp: isUp, parkID: park.id)
            }
        }

        dismiss()
    }
}

// MARK: - Quick Check Row

struct QuickCheckRow: View {
    let item: QuickCheckItem
    var vote: Bool?
    var onVote: (Bool) -> Void

    var body: some View {
        HStack {
            // Icon + Question
            HStack(spacing: DesignTokens.spacingMD) {
                Image(systemName: item.icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(item.color)
                    .frame(width: 32, height: 32)
                    .background(item.color.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(item.question)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.textPrimary)
            }

            Spacer()

            // Thumbs up/down buttons
            HStack(spacing: DesignTokens.spacingSM) {
                Button(action: { onVote(true) }) {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 15))
                        .foregroundColor(vote == true ? .white : .textSecondary)
                        .frame(width: 36, height: 36)
                        .background(vote == true ? Color.leafGreen.opacity(0.8) : Color.surfaceContainerHigh)
                        .clipShape(Circle())
                }

                Button(action: { onVote(false) }) {
                    Image(systemName: "hand.thumbsdown.fill")
                        .font(.system(size: 15))
                        .foregroundColor(vote == false ? .white : .textSecondary)
                        .frame(width: 36, height: 36)
                        .background(vote == false ? Color.dangerRed.opacity(0.8) : Color.surfaceContainerHigh)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, DesignTokens.spacingLG)
        .padding(.vertical, DesignTokens.spacingMD)
        .background(Color.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))
    }
}

