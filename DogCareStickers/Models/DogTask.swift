import SwiftUI

enum TaskTime: String, Codable {
    case morning
    case evening
}

struct DogTask: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var emoji: String
    var description: String
    var colorHex: String
    var timeOfDay: TaskTime

    init(id: UUID = UUID(), title: String, emoji: String, description: String,
         colorHex: String = "F97316", timeOfDay: TaskTime = .morning) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.description = description
        self.colorHex = colorHex
        self.timeOfDay = timeOfDay
    }

    var color: Color { Color(hex: colorHex) }

    static let defaultTasks: [DogTask] = [
        // Morning tasks
        DogTask(title: "Feed the dog", emoji: "🍖",
                description: "Give your pup breakfast!",
                colorHex: "F97316", timeOfDay: .morning),
        DogTask(title: "Fresh water", emoji: "💧",
                description: "Fill up the water bowl!",
                colorHex: "3B82F6", timeOfDay: .morning),
        DogTask(title: "Morning walk", emoji: "🦮",
                description: "Take your dog for a walk!",
                colorHex: "22C55E", timeOfDay: .morning),

        // Evening tasks
        DogTask(title: "Brush fur", emoji: "🪮",
                description: "Keep them looking fluffy!",
                colorHex: "A855F7", timeOfDay: .evening),
        DogTask(title: "Play & cuddle", emoji: "🎾",
                description: "Fetch, belly rubs, fun time!",
                colorHex: "EC4899", timeOfDay: .evening),
        DogTask(title: "Clean up", emoji: "🧹",
                description: "Pick up after your dog!",
                colorHex: "14B8A6", timeOfDay: .evening),
        DogTask(title: "Training", emoji: "🐾",
                description: "Practice sit, stay, or tricks!",
                colorHex: "EAB308", timeOfDay: .evening),
    ]

    static var morningTasks: [DogTask] {
        defaultTasks.filter { $0.timeOfDay == .morning }
    }

    static var eveningTasks: [DogTask] {
        defaultTasks.filter { $0.timeOfDay == .evening }
    }
}
