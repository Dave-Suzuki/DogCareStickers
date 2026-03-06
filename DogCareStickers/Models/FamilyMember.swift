import Foundation

struct FamilyMember: Identifiable, Codable, Hashable {
    let id: String          // Google user ID
    var displayName: String
    var email: String
    var avatarURL: String?  // Google profile photo URL

    var initials: String {
        let parts = displayName.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
        }
        return String(displayName.prefix(2)).uppercased()
    }

    // Color assigned based on hash of ID for consistent avatar colors
    var colorHex: String {
        let colors = ["FF6B6B", "F97316", "22C55E", "3B82F6", "A855F7",
                       "EC4899", "14B8A6", "EAB308"]
        let index = abs(id.hashValue) % colors.count
        return colors[index]
    }
}
