import Foundation

struct DogBreed: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let icon: String      // Emoji representation
    let description: String

    static let allBreeds: [DogBreed] = [
        DogBreed(id: "poodle_teddy", name: "Toy Poodle (Teddy Bear Cut)", icon: "🧸", description: "Fluffy & adorable"),
        DogBreed(id: "poodle", name: "Poodle", icon: "🐩", description: "Elegant & smart"),
        DogBreed(id: "golden", name: "Golden Retriever", icon: "🦮", description: "Loyal & friendly"),
        DogBreed(id: "shiba", name: "Shiba Inu", icon: "🐕", description: "Bold & spirited"),
        DogBreed(id: "corgi", name: "Corgi", icon: "🐶", description: "Short legs, big heart"),
        DogBreed(id: "husky", name: "Husky", icon: "🐺", description: "Adventurous & vocal"),
        DogBreed(id: "frenchie", name: "French Bulldog", icon: "🐾", description: "Playful & charming"),
        DogBreed(id: "dachshund", name: "Dachshund", icon: "🌭", description: "Little but mighty"),
        DogBreed(id: "beagle", name: "Beagle", icon: "🐕‍🦺", description: "Curious & merry"),
        DogBreed(id: "lab", name: "Labrador", icon: "🏅", description: "Gentle & outgoing"),
        DogBreed(id: "chihuahua", name: "Chihuahua", icon: "👑", description: "Tiny but fierce"),
        DogBreed(id: "mutt", name: "Mixed / Rescue", icon: "❤️", description: "One of a kind"),
        DogBreed(id: "other", name: "Other", icon: "🐶", description: "Every dog is special"),
    ]

    static func find(by id: String) -> DogBreed? {
        allBreeds.first { $0.id == id }
    }
}
