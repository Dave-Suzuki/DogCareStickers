import SwiftUI

enum StickerPattern: String, Codable, CaseIterable {
    case rays
    case stripes
    case dots
    case stars
    case hearts
    case sparkles
    case zigzag
    case none
}

enum StickerSheet: String, CaseIterable {
    case motivational = "You're Amazing!"
    case dogTheme = "Dog Lover"
    case funShapes = "Fun & Colorful"
    case superKid = "Super Kid"
}

struct StickerDesign: Identifiable, Hashable {
    let id: String
    let label: String
    let icon: String         // SF Symbol name
    let emoji: String        // fallback emoji for the center
    let bgColors: [Color]
    let pattern: StickerPattern
    let borderColor: Color
    let sheet: StickerSheet

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: StickerDesign, rhs: StickerDesign) -> Bool { lhs.id == rhs.id }

    // MARK: - All Stickers

    static let allStickers: [StickerDesign] = motivational + dogTheme + funShapes + superKid

    static func find(by id: String) -> StickerDesign? {
        allStickers.first { $0.id == id }
    }

    static func stickers(for sheet: StickerSheet) -> [StickerDesign] {
        allStickers.filter { $0.sheet == sheet }
    }

    // MARK: - Motivational Sheet

    static let motivational: [StickerDesign] = [
        StickerDesign(
            id: "great_job_red", label: "Great\nJob!", icon: "hand.thumbsup.fill",
            emoji: "👍", bgColors: [Color(hex: "FF6B6B"), Color(hex: "EE5A24")],
            pattern: .rays, borderColor: .white, sheet: .motivational
        ),
        StickerDesign(
            id: "super_star_gold", label: "Super\nStar!", icon: "star.fill",
            emoji: "⭐", bgColors: [Color(hex: "FFD93D"), Color(hex: "FF9F1C")],
            pattern: .sparkles, borderColor: .white, sheet: .motivational
        ),
        StickerDesign(
            id: "awesome_purple", label: "Awesome!", icon: "bolt.fill",
            emoji: "⚡", bgColors: [Color(hex: "A855F7"), Color(hex: "7C3AED")],
            pattern: .stars, borderColor: .white, sheet: .motivational
        ),
        StickerDesign(
            id: "way_to_go_blue", label: "Way\nTo Go!", icon: "trophy.fill",
            emoji: "🏆", bgColors: [Color(hex: "3B82F6"), Color(hex: "1D4ED8")],
            pattern: .rays, borderColor: .white, sheet: .motivational
        ),
        StickerDesign(
            id: "fantastic_green", label: "Fantastic!", icon: "sparkles",
            emoji: "✨", bgColors: [Color(hex: "22C55E"), Color(hex: "16A34A")],
            pattern: .dots, borderColor: .white, sheet: .motivational
        ),
        StickerDesign(
            id: "well_done_teal", label: "Well\nDone!", icon: "checkmark.seal.fill",
            emoji: "✅", bgColors: [Color(hex: "14B8A6"), Color(hex: "0D9488")],
            pattern: .stripes, borderColor: .white, sheet: .motivational
        ),
        StickerDesign(
            id: "brilliant_orange", label: "Brilliant!", icon: "sun.max.fill",
            emoji: "☀️", bgColors: [Color(hex: "FB923C"), Color(hex: "EA580C")],
            pattern: .rays, borderColor: .white, sheet: .motivational
        ),
        StickerDesign(
            id: "number_one_pink", label: "#1\nHelper!", icon: "medal.fill",
            emoji: "🥇", bgColors: [Color(hex: "EC4899"), Color(hex: "DB2777")],
            pattern: .hearts, borderColor: .white, sheet: .motivational
        ),
    ]

    // MARK: - Dog Theme Sheet

    static let dogTheme: [StickerDesign] = [
        StickerDesign(
            id: "pawsome_orange", label: "Pawsome!", icon: "pawprint.fill",
            emoji: "🐾", bgColors: [Color(hex: "F97316"), Color(hex: "EA580C")],
            pattern: .dots, borderColor: .white, sheet: .dogTheme
        ),
        StickerDesign(
            id: "good_boy_blue", label: "Good\nBoy!", icon: "dog.fill",
            emoji: "🐶", bgColors: [Color(hex: "60A5FA"), Color(hex: "3B82F6")],
            pattern: .stars, borderColor: .white, sheet: .dogTheme
        ),
        StickerDesign(
            id: "bone_treat_yellow", label: "Treat\nTime!", icon: "cross.vial.fill",
            emoji: "🦴", bgColors: [Color(hex: "FBBF24"), Color(hex: "F59E0B")],
            pattern: .zigzag, borderColor: .white, sheet: .dogTheme
        ),
        StickerDesign(
            id: "best_friend_pink", label: "Best\nFriend!", icon: "heart.fill",
            emoji: "❤️", bgColors: [Color(hex: "F472B6"), Color(hex: "EC4899")],
            pattern: .hearts, borderColor: .white, sheet: .dogTheme
        ),
        StickerDesign(
            id: "dog_parent_green", label: "Dog\nParent!", icon: "figure.and.child.holdinghands",
            emoji: "🧑‍🤝‍🧑", bgColors: [Color(hex: "4ADE80"), Color(hex: "22C55E")],
            pattern: .rays, borderColor: .white, sheet: .dogTheme
        ),
        StickerDesign(
            id: "woof_red", label: "Woof\nWoof!", icon: "speaker.wave.3.fill",
            emoji: "📢", bgColors: [Color(hex: "F87171"), Color(hex: "EF4444")],
            pattern: .stripes, borderColor: .white, sheet: .dogTheme
        ),
        StickerDesign(
            id: "walkies_teal", label: "Walkies!", icon: "figure.walk",
            emoji: "🦮", bgColors: [Color(hex: "2DD4BF"), Color(hex: "14B8A6")],
            pattern: .dots, borderColor: .white, sheet: .dogTheme
        ),
        StickerDesign(
            id: "puppy_love_purple", label: "Puppy\nLove!", icon: "heart.circle.fill",
            emoji: "💜", bgColors: [Color(hex: "C084FC"), Color(hex: "A855F7")],
            pattern: .sparkles, borderColor: .white, sheet: .dogTheme
        ),
    ]

    // MARK: - Fun Shapes Sheet

    static let funShapes: [StickerDesign] = [
        StickerDesign(
            id: "rainbow_multi", label: "Rainbow!", icon: "rainbow",
            emoji: "🌈", bgColors: [Color(hex: "F472B6"), Color(hex: "A78BFA"), Color(hex: "60A5FA")],
            pattern: .stripes, borderColor: .white, sheet: .funShapes
        ),
        StickerDesign(
            id: "rocket_blue", label: "Blast\nOff!", icon: "airplane",
            emoji: "🚀", bgColors: [Color(hex: "818CF8"), Color(hex: "6366F1")],
            pattern: .stars, borderColor: .white, sheet: .funShapes
        ),
        StickerDesign(
            id: "lightning_yellow", label: "Zap!", icon: "bolt.fill",
            emoji: "⚡", bgColors: [Color(hex: "FDE047"), Color(hex: "FACC15")],
            pattern: .zigzag, borderColor: .white, sheet: .funShapes
        ),
        StickerDesign(
            id: "fire_orange", label: "On\nFire!", icon: "flame.fill",
            emoji: "🔥", bgColors: [Color(hex: "FB923C"), Color(hex: "F97316")],
            pattern: .rays, borderColor: .white, sheet: .funShapes
        ),
        StickerDesign(
            id: "crown_gold", label: "King!", icon: "crown.fill",
            emoji: "👑", bgColors: [Color(hex: "FCD34D"), Color(hex: "F59E0B")],
            pattern: .sparkles, borderColor: .white, sheet: .funShapes
        ),
        StickerDesign(
            id: "gem_emerald", label: "Gem!", icon: "diamond.fill",
            emoji: "💎", bgColors: [Color(hex: "34D399"), Color(hex: "10B981")],
            pattern: .dots, borderColor: .white, sheet: .funShapes
        ),
        StickerDesign(
            id: "music_pink", label: "Groovy!", icon: "music.note",
            emoji: "🎵", bgColors: [Color(hex: "F9A8D4"), Color(hex: "F472B6")],
            pattern: .stripes, borderColor: .white, sheet: .funShapes
        ),
        StickerDesign(
            id: "party_multi", label: "Party!", icon: "party.popper.fill",
            emoji: "🎉", bgColors: [Color(hex: "FB7185"), Color(hex: "E11D48")],
            pattern: .hearts, borderColor: .white, sheet: .funShapes
        ),
    ]

    // MARK: - Super Kid Sheet

    static let superKid: [StickerDesign] = [
        StickerDesign(
            id: "hero_red", label: "Hero!", icon: "shield.fill",
            emoji: "🦸", bgColors: [Color(hex: "EF4444"), Color(hex: "DC2626")],
            pattern: .rays, borderColor: .white, sheet: .superKid
        ),
        StickerDesign(
            id: "champion_blue", label: "Champ!", icon: "trophy.fill",
            emoji: "🏆", bgColors: [Color(hex: "3B82F6"), Color(hex: "2563EB")],
            pattern: .stars, borderColor: .white, sheet: .superKid
        ),
        StickerDesign(
            id: "smart_green", label: "So\nSmart!", icon: "brain.head.profile.fill",
            emoji: "🧠", bgColors: [Color(hex: "4ADE80"), Color(hex: "16A34A")],
            pattern: .dots, borderColor: .white, sheet: .superKid
        ),
        StickerDesign(
            id: "kind_pink", label: "So\nKind!", icon: "hands.and.sparkles.fill",
            emoji: "🤗", bgColors: [Color(hex: "F9A8D4"), Color(hex: "EC4899")],
            pattern: .hearts, borderColor: .white, sheet: .superKid
        ),
        StickerDesign(
            id: "brave_purple", label: "Brave!", icon: "flag.fill",
            emoji: "🚩", bgColors: [Color(hex: "A78BFA"), Color(hex: "8B5CF6")],
            pattern: .zigzag, borderColor: .white, sheet: .superKid
        ),
        StickerDesign(
            id: "caring_teal", label: "Caring!", icon: "heart.text.square.fill",
            emoji: "💚", bgColors: [Color(hex: "5EEAD4"), Color(hex: "14B8A6")],
            pattern: .sparkles, borderColor: .white, sheet: .superKid
        ),
        StickerDesign(
            id: "wow_amber", label: "WOW!", icon: "exclamationmark.3",
            emoji: "😮", bgColors: [Color(hex: "FBBF24"), Color(hex: "D97706")],
            pattern: .rays, borderColor: .white, sheet: .superKid
        ),
        StickerDesign(
            id: "perfect_rose", label: "Perfect!", icon: "seal.fill",
            emoji: "💯", bgColors: [Color(hex: "FB7185"), Color(hex: "F43F5E")],
            pattern: .stripes, borderColor: .white, sheet: .superKid
        ),
    ]
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
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
