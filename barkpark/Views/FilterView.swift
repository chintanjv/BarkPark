import SwiftUI

// MARK: - Filter View
// The "Filter Bottom Sheet" from the mockup.
// Presented as a sheet from the Map screen.
// Includes: distance slider, amenity chips, dog size selector, show parks button.

struct FilterView: View {
    @EnvironmentObject var store: ParkStore
    @Environment(\.dismiss) var dismiss

    // Local state so changes only apply when user taps "Show Parks"
    @State private var localFilter: ParkFilter = ParkFilter()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // === TOP IMAGE BLEED ===
                ZStack(alignment: .bottom) {
                    // Gradient placeholder for top image
                    LinearGradient(
                        colors: [.leafGreenLight.opacity(0.3), .leafGreen.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 140)
                    .overlay(
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 40, weight: .ultraLight))
                            .foregroundColor(.leafGreen.opacity(0.3))
                    )
                }

                // === FILTER CONTENT ===
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: DesignTokens.spacingXL) {

                        // Header
                        HStack {
                            Text("Filters")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.textPrimary)

                            Spacer()

                            Button("Reset") {
                                localFilter = ParkFilter()
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.leafGreen)
                        }

                        // === DISTANCE SLIDER ===
                        distanceSection

                        // === AMENITIES CHIPS ===
                        amenitiesSection

                        // === DOG FRIENDLINESS ===
                        dogFriendlinessSection

                        // === FENCED TOGGLE ===
                        fencedSection

                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, DesignTokens.spacingXL)
                    .padding(.top, DesignTokens.spacingXL)
                }

                // === SHOW PARKS BUTTON ===
                showParksButton
            }
            .background(Color.surface)
            .navigationBarHidden(true)
            .onAppear {
                localFilter = store.filter
            }
        }
    }

    // MARK: - Distance Section

    private var distanceSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMD) {
            HStack {
                Text("Distance Radius")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(Int(localFilter.maxDistanceMiles)) miles")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.leafGreen)
            }

            Slider(value: $localFilter.maxDistanceMiles, in: 1...20, step: 1)
                .tint(.leafGreen)

            HStack {
                Text("1 mi")
                    .font(.system(size: 11))
                    .foregroundColor(.textSecondary)
                Spacer()
                Text("20 mi")
                    .font(.system(size: 11))
                    .foregroundColor(.textSecondary)
            }
        }
    }

    // MARK: - Amenities Section

    private var amenitiesSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMD) {
            Text("Amenities")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.textPrimary)

            ChipFlowView(
                items: AmenityList.all.map { $0.name },
                selected: localFilter.selectedAmenities,
                onTap: { name in
                    if localFilter.selectedAmenities.contains(name) {
                        localFilter.selectedAmenities.remove(name)
                    } else {
                        localFilter.selectedAmenities.insert(name)
                    }
                }
            )
        }
    }

    // MARK: - Dog Friendliness Section

    private var dogFriendlinessSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingMD) {
            Text("Dog Friendliness")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.textPrimary)

            HStack(spacing: DesignTokens.spacingSM) {
                ForEach(DogSizeCategory.allCases, id: \.self) { size in
                    let isSelected = localFilter.selectedSize == size
                    Text(size.rawValue)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(isSelected ? .white : .textPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(isSelected ? Color.leafGreen : Color.surfaceContainerHigh)
                        .clipShape(Capsule())
                        .onTapGesture {
                            if localFilter.selectedSize == size {
                                localFilter.selectedSize = nil
                            } else {
                                localFilter.selectedSize = size
                            }
                        }
                }
            }
        }
    }

    // MARK: - Fenced Toggle

    private var fencedSection: some View {
        HStack {
            HStack(spacing: DesignTokens.spacingMD) {
                Image(systemName: "checkmark.shield.fill")
                    .foregroundColor(.leafGreen)
                Text("Fenced only")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.textPrimary)
            }

            Spacer()

            Toggle("", isOn: $localFilter.requireFenced)
                .tint(.leafGreen)
                .labelsHidden()
        }
        .padding(DesignTokens.spacingLG)
        .background(Color.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.radiusMD))
    }

    // MARK: - Show Parks Button

    private var showParksButton: some View {
        Button(action: {
            store.filter = localFilter
            dismiss()
        }) {
            HStack(spacing: 8) {
                Text("Show \(store.filteredParks.count) Parks")
                    .font(.system(size: 17, weight: .semibold))
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: [.leafGreen, .leafGreenLight],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Capsule())
        }
        .padding(.horizontal, DesignTokens.spacingXL)
        .padding(.vertical, DesignTokens.spacingLG)
        .background(Color.surface)
    }
}

