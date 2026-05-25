import SwiftUI
import PhotosUI

// MARK: - Park Detail View
// The full park information screen, matching the "Park Detail Page" mockup.
// Shows: back nav, title, rating, photos, features, amenities, highlights,
// about section, and rate/photo action buttons.

struct ParkDetailView: View {
    let park: DogPark
    @EnvironmentObject var store: ParkStore
    @Environment(\.dismiss) var dismiss
    @State private var showRating = false
    @State private var showPhotoPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil

    // Get the live park data from the store (so it updates after rating)
    private var livePark: DogPark {
        store.parks.first(where: { $0.id == park.id }) ?? park
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: DesignTokens.spacingXL) {

                // === HEADER: Title + Rating + Address ===
                headerSection

                // === PHOTO GALLERY ===
                photoGallerySection

                // === FEATURES (Fenced, Separated Sections) ===
                featuresSection

                // === AMENITIES GRID ===
                amenitiesSection

                // === TOP HIGHLIGHTS ===
                highlightsSection

                // === ABOUT ===
                aboutSection

                // === ACTION BUTTONS ===
                actionButtonsSection

                Spacer(minLength: 40)
            }
            .padding(.top, 8)
        }
        .background(Color.surface)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.textPrimary)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textPrimary)
                    }
                    Button(action: {
                        store.toggleFavorite(for: park.id)
                    }) {
                        Image(systemName: livePark.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(livePark.isFavorite ? .dangerRed : .textPrimary)
                    }
                }
            }
        }
        .sheet(isPresented: $showRating) {
            RatingView(park: livePark)
                .environmentObject(store)
        }
        .onChange(of: selectedPhotoItem) { newValue in
            handlePhotoSelection(newValue)
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Park name (display-lg from design system)
            Text(livePark.name)
                .font(.system(size: 38, weight: .bold))
                .tracking(-0.5)  // Negative letter-spacing for editorial look
                .foregroundColor(.textPrimary)
                .padding(.leading, DesignTokens.spacingXL)
                .padding(.trailing, DesignTokens.spacingLG)

            // Rating + Distance row
            HStack(spacing: DesignTokens.spacingMD) {
                StarRatingDisplay(rating: livePark.averageRating, count: livePark.ratingCount)

                Text("•")
                    .foregroundColor(.textSecondary)

                HStack(spacing: 3) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.leafGreen)
                    Text("\(String(format: "%.1f", livePark.distanceMiles)) mi")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(.leading, DesignTokens.spacingXL)

            // Address
            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.system(size: 11))
                    .foregroundColor(.textSecondary)
                Text("\(livePark.address) • \(livePark.walkTimeMinutes) mins away")
                    .font(.system(size: 13))
                    .foregroundColor(.textSecondary)
            }
            .padding(.leading, DesignTokens.spacingXL)
        }
    }

    // MARK: - Photo Gallery Section

    private var photoGallerySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignTokens.spacingMD) {
                // Main placeholder image
                ParkPlaceholderImage(
                    color: livePark.placeholderColor,
                    icon: "pawprint.fill",
                    size: 240
                )
                .frame(width: 280, height: 240)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))
                .overlay(
                    // "Community Photo" pill overlay
                    HStack(spacing: 4) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 10))
                        Text("Community Photo")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.textPrimary.opacity(0.5))
                    .clipShape(Capsule())
                    .padding(12),
                    alignment: .bottomLeading
                )

                // Additional placeholder images
                ParkPlaceholderImage(
                    color: PlaceholderColor.allCases.randomElement() ?? .blue,
                    icon: "leaf.fill",
                    size: 240
                )
                .frame(width: 160, height: 240)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))

                // User photos
                ForEach(Array(livePark.userPhotoData.enumerated()), id: \.offset) { index, data in
                    if let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 160, height: 240)
                            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))
                    }
                }
            }
            .padding(.horizontal, DesignTokens.spacingXL)
        }
    }

    // MARK: - Features Section (Fenced, Separated Sections)

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMD) {
            if livePark.isFenced {
                FeatureRow(icon: "checkmark.shield.fill", text: "Fenced", color: .leafGreen)
            }
            if livePark.hasSeparatedSections {
                FeatureRow(icon: "square.split.2x1.fill", text: "Separated Sections", color: .skyBlue)
            }
        }
        .padding(.horizontal, DesignTokens.spacingXL)
    }

    // MARK: - Amenities Section

    private var amenitiesSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingLG) {
            // Section header
            HStack {
                Text("Amenities")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.textPrimary)
                Spacer()
                Text("See all")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.leafGreen)
            }
            .padding(.horizontal, DesignTokens.spacingXL)

            // 2-column grid of amenity cards
            let columns = [
                GridItem(.flexible(), spacing: DesignTokens.spacingMD),
                GridItem(.flexible(), spacing: DesignTokens.spacingMD)
            ]

            LazyVGrid(columns: columns, spacing: DesignTokens.spacingMD) {
                ForEach(livePark.amenities) { amenity in
                    AmenityCard(amenity: amenity)
                }
            }
            .padding(.horizontal, DesignTokens.spacingXL)
        }
    }

    // MARK: - Highlights Section

    private var highlightsSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMD) {
            Text("TOP HIGHLIGHTS")
                .font(.system(size: 11, weight: .bold))
                .tracking(1.2)
                .foregroundColor(.textSecondary)
                .padding(.horizontal, DesignTokens.spacingXL)

            ChipFlowView(
                items: livePark.highlights,
                selected: []
            )
            .padding(.horizontal, DesignTokens.spacingXL)
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMD) {
            Text("About")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.textPrimary)

            Text(livePark.description)
                .font(.system(size: 15))
                .foregroundColor(.textSecondary)
                .lineSpacing(5)
        }
        .padding(.horizontal, DesignTokens.spacingXL)
    }

    // MARK: - Action Buttons

    private var actionButtonsSection: some View {
        HStack(spacing: DesignTokens.spacingMD) {
            // Rate This Park button
            Button(action: { showRating = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 13))
                    Text("Rate This Park")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .buttonStyle(PrimaryButtonStyle())

            // Add Photo button
            PhotosPicker(
                selection: $selectedPhotoItem,
                matching: .images
            ) {
                HStack(spacing: 6) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 13))
                    Text("Add Photo")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .buttonStyle(SecondaryButtonStyle())
        }
        .padding(.horizontal, DesignTokens.spacingXL)
    }

    // MARK: - Photo Handling

    private func handlePhotoSelection(_ item: PhotosPickerItem?) {
        guard let item = item else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                if case .success(let data) = result, let data = data {
                    store.addPhoto(data, to: park.id)
                }
            }
        }
    }
}

// MARK: - Feature Row Component

struct FeatureRow: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: DesignTokens.spacingMD) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.textPrimary)
        }
        .padding(.horizontal, DesignTokens.spacingLG)
        .padding(.vertical, DesignTokens.spacingMD)
        .background(Color.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))
    }
}

// MARK: - Amenity Card Component

struct AmenityCard: View {
    let amenity: Amenity

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: amenity.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.skyBlue)

            Text(amenity.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textPrimary)
                .lineLimit(1)

            if !amenity.subtitle.isEmpty {
                Text(amenity.subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignTokens.spacingLG)
        .background(Color.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))
    }
}

// MARK: - Chip Flow View
// Wrapping chip layout for tags (works on iOS 16)

struct ChipFlowView: View {
    let items: [String]
    var selected: Set<String> = []
    var onTap: ((String) -> Void)? = nil

    var body: some View {
        // Simple wrapping using multiple HStacks
        VStack(alignment: .leading, spacing: 8) {
            // Split items into rows of ~3
            ForEach(chunked(items, size: 3), id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { item in
                        chipView(for: item)
                    }
                }
            }
        }
    }

    private func chipView(for item: String) -> some View {
        let isSelected = selected.contains(item)
        return Text(item)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(isSelected ? .white : .textPrimary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color.leafGreen : Color.surfaceContainerHigh)
            .clipShape(Capsule())
            .onTapGesture {
                onTap?(item)
            }
    }

    // Helper to split array into chunks
    private func chunked(_ array: [String], size: Int) -> [[String]] {
        stride(from: 0, to: array.count, by: size).map {
            Array(array[$0..<min($0 + size, array.count)])
        }
    }
}

