import Foundation

// MARK: - Mock Data
// 6 sample dog parks near San Jose, CA
// These are used as the initial data when the app launches

struct MockData {
    static let parks: [DogPark] = [
        DogPark(
            id: UUID(),
            name: "Barker Ridge Park",
            address: "1234 Park Ave, San Jose, CA 95110",
            latitude: 37.3382,
            longitude: -121.8863,
            distanceMiles: 0.5,
            walkTimeMinutes: 4,
            isFenced: true,
            hasSeparatedSections: true,
            sizeCategory: .allSizes,
            amenities: [
                AmenityList.all[0], // Water Fountain
                AmenityList.all[1], // Dog Wash
                AmenityList.all[2], // Shade
                AmenityList.all[3], // Off-leash
            ],
            highlights: ["Clean", "Spacious", "Quiet"],
            description: "Barker Ridge is a premium neighborhood sanctuary designed for active dogs and their owners. Featuring panoramic views of the ridge and specialized agility equipment, it provides a safe, serene environment for socialization.",
            placeholderColor: .green,
            ratings: [5, 4, 5, 5, 4, 5, 4, 5, 5, 4],
            amenityVotes: [
                "Fresh Water?": AmenityVote(thumbsUp: 42, thumbsDown: 3),
                "Good Shade?": AmenityVote(thumbsUp: 38, thumbsDown: 7),
                "Clean Area?": AmenityVote(thumbsUp: 35, thumbsDown: 10),
            ],
            vibeVotes: ["Clean": 24, "Spacious": 18, "Quiet": 15],
            userPhotoData: [],
            isFavorite: true
        ),

        DogPark(
            id: UUID(),
            name: "Willow Glen Paws",
            address: "567 Lincoln Ave, San Jose, CA 95125",
            latitude: 37.3083,
            longitude: -121.8950,
            distanceMiles: 1.2,
            walkTimeMinutes: 15,
            isFenced: true,
            hasSeparatedSections: false,
            sizeCategory: .smallDogs,
            amenities: [
                AmenityList.all[0], // Water Fountain
                AmenityList.all[2], // Shade
                AmenityList.all[5], // Parking
            ],
            highlights: ["Friendly Dogs", "Good for Puppies"],
            description: "A cozy, shaded dog park in the heart of Willow Glen. Perfect for small breeds and puppies, with friendly regulars and a welcoming community vibe.",
            placeholderColor: .blue,
            ratings: [4, 4, 3, 5, 4, 4, 5],
            amenityVotes: [
                "Fresh Water?": AmenityVote(thumbsUp: 28, thumbsDown: 5),
                "Good Shade?": AmenityVote(thumbsUp: 30, thumbsDown: 2),
                "Clean Area?": AmenityVote(thumbsUp: 20, thumbsDown: 8),
            ],
            vibeVotes: ["Friendly Dogs": 20, "Good for Puppies": 16],
            userPhotoData: [],
            isFavorite: false
        ),

        DogPark(
            id: UUID(),
            name: "Golden Meadow Run",
            address: "890 Los Gatos Blvd, Los Gatos, CA 95032",
            latitude: 37.2358,
            longitude: -121.9624,
            distanceMiles: 3.8,
            walkTimeMinutes: 45,
            isFenced: true,
            hasSeparatedSections: true,
            sizeCategory: .allSizes,
            amenities: [
                AmenityList.all[0], // Water Fountain
                AmenityList.all[1], // Dog Wash
                AmenityList.all[2], // Shade
                AmenityList.all[3], // Off-leash
                AmenityList.all[4], // Agility
                AmenityList.all[5], // Parking
            ],
            highlights: ["Well-maintained", "Spacious", "Great Community"],
            description: "A sprawling off-leash paradise nestled in the Los Gatos foothills. Features a full agility course, separated small and large dog areas, and a self-service dog wash station.",
            placeholderColor: .orange,
            ratings: [5, 5, 4, 5, 5, 5, 4, 5, 5, 5, 4, 5],
            amenityVotes: [
                "Fresh Water?": AmenityVote(thumbsUp: 55, thumbsDown: 2),
                "Good Shade?": AmenityVote(thumbsUp: 48, thumbsDown: 5),
                "Clean Area?": AmenityVote(thumbsUp: 50, thumbsDown: 3),
            ],
            vibeVotes: ["Well-maintained": 30, "Spacious": 25, "Great Community": 22],
            userPhotoData: [],
            isFavorite: false
        ),

        DogPark(
            id: UUID(),
            name: "Fetch Field",
            address: "234 Campbell Ave, Campbell, CA 95008",
            latitude: 37.2872,
            longitude: -121.9500,
            distanceMiles: 2.1,
            walkTimeMinutes: 25,
            isFenced: false,
            hasSeparatedSections: false,
            sizeCategory: .largeDogs,
            amenities: [
                AmenityList.all[0], // Water Fountain
                AmenityList.all[3], // Off-leash
                AmenityList.all[5], // Parking
                AmenityList.all[7], // Lighting
            ],
            highlights: ["Spacious", "Great Community"],
            description: "An open-field dog park ideal for large, active breeds. Great for fetch and frisbee with plenty of room to run. Evening lighting extends play hours.",
            placeholderColor: .teal,
            ratings: [4, 3, 4, 4, 3, 4, 5],
            amenityVotes: [
                "Fresh Water?": AmenityVote(thumbsUp: 18, thumbsDown: 10),
                "Good Shade?": AmenityVote(thumbsUp: 8, thumbsDown: 20),
                "Clean Area?": AmenityVote(thumbsUp: 15, thumbsDown: 12),
            ],
            vibeVotes: ["Spacious": 14, "Great Community": 10],
            userPhotoData: [],
            isFavorite: false
        ),

        DogPark(
            id: UUID(),
            name: "Wagging Tails Garden",
            address: "456 Mission Blvd, Santa Clara, CA 95050",
            latitude: 37.3541,
            longitude: -121.9552,
            distanceMiles: 4.5,
            walkTimeMinutes: 50,
            isFenced: true,
            hasSeparatedSections: true,
            sizeCategory: .allSizes,
            amenities: [
                AmenityList.all[0], // Water Fountain
                AmenityList.all[1], // Dog Wash
                AmenityList.all[2], // Shade
                AmenityList.all[4], // Agility
                AmenityList.all[6], // Restrooms
            ],
            highlights: ["Clean", "Well-maintained", "Quiet"],
            description: "A beautifully landscaped garden-style dog park with mature trees, covered seating areas, and well-maintained turf. Features agility equipment and a dedicated puppy zone.",
            placeholderColor: .purple,
            ratings: [5, 4, 5, 4, 5, 4, 4, 5],
            amenityVotes: [
                "Fresh Water?": AmenityVote(thumbsUp: 32, thumbsDown: 4),
                "Good Shade?": AmenityVote(thumbsUp: 40, thumbsDown: 1),
                "Clean Area?": AmenityVote(thumbsUp: 38, thumbsDown: 5),
            ],
            vibeVotes: ["Clean": 20, "Well-maintained": 18, "Quiet": 12],
            userPhotoData: [],
            isFavorite: false
        ),

        DogPark(
            id: UUID(),
            name: "Sunnyvale Bark Yard",
            address: "789 Mathilda Ave, Sunnyvale, CA 94086",
            latitude: 37.3688,
            longitude: -122.0363,
            distanceMiles: 6.2,
            walkTimeMinutes: 70,
            isFenced: true,
            hasSeparatedSections: false,
            sizeCategory: .smallDogs,
            amenities: [
                AmenityList.all[0], // Water Fountain
                AmenityList.all[2], // Shade
                AmenityList.all[5], // Parking
                AmenityList.all[6], // Restrooms
                AmenityList.all[7], // Lighting
            ],
            highlights: ["Friendly Dogs", "Clean", "Good for Puppies"],
            description: "A compact but well-equipped bark yard in central Sunnyvale. Excellent for small dogs and puppies with soft turf, ample shade, and evening lighting for after-work visits.",
            placeholderColor: .green,
            ratings: [4, 4, 5, 3, 4, 4],
            amenityVotes: [
                "Fresh Water?": AmenityVote(thumbsUp: 22, thumbsDown: 6),
                "Good Shade?": AmenityVote(thumbsUp: 25, thumbsDown: 3),
                "Clean Area?": AmenityVote(thumbsUp: 20, thumbsDown: 7),
            ],
            vibeVotes: ["Friendly Dogs": 15, "Clean": 12, "Good for Puppies": 10],
            userPhotoData: [],
            isFavorite: false
        ),
    ]
}

