import SwiftUI

// MARK: - Design System Colors
// Based on "The Liquid Sanctuary" design specification
// These colors create the premium, editorial-grade experience

extension Color {
    // === Core Surface Colors ===
    // Used for backgrounds and layering (no hard borders!)
    static let surface = Color(hex: "F9F9FE")              // Global background
    static let surfaceContainerLow = Color(hex: "F3F3F8")   // Section background
    static let surfaceContainerLowest = Color(hex: "FFFFFF") // Card background (lifted)
    static let surfaceContainerHigh = Color(hex: "E8E8ED")   // Unselected chips
    static let surfaceContainerHighest = Color(hex: "E2E2E7") // Secondary buttons

    // === Brand Colors ===
    static let leafGreen = Color(hex: "006E28")             // Primary actions
    static let leafGreenLight = Color(hex: "34C759")        // Gradient end
    static let skyBlue = Color(hex: "0058BC")               // Utility/discovery

    // === Text Colors ===
    static let textPrimary = Color(hex: "1A1C1F")           // Headlines
    static let textSecondary = Color(hex: "46464B")          // Metadata/body

    // === Utility ===
    static let ghostBorder = Color(hex: "BCCBB8").opacity(0.15) // Subtle edge
    static let ratingGold = Color(hex: "FFB800")            // Star ratings
    static let dangerRed = Color(hex: "FF3B30")             // Negative votes
}

// MARK: - Hex Color Initializer
// Lets us use hex strings like Color(hex: "006E28")
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Design Tokens
// Centralized spacing, radius, and shadow values

struct DesignTokens {
    // Spacing scale (used instead of borders for separation)
    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 12
    static let spacingLG: CGFloat = 16
    static let spacingXL: CGFloat = 24
    static let spacingXXL: CGFloat = 32

    // Border radius (never less than 20 for major containers)
    static let radiusSM: CGFloat = 12
    static let radiusMD: CGFloat = 20
    static let radiusLG: CGFloat = 32
    static let radiusXL: CGFloat = 48
    static let radiusFull: CGFloat = 9999  // Pill shape

    // Ambient shadow (not pure black - 6% opacity)
    static let shadowColor = Color.textPrimary.opacity(0.06)
    static let shadowRadius: CGFloat = 40
    static let shadowY: CGFloat = 12
}

// MARK: - Primary Gradient Button Style
// Creates the "Liquid" gradient CTA from the design spec

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [.leafGreen, .leafGreenLight],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Secondary Button Style
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.textPrimary)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.surfaceContainerHighest)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
