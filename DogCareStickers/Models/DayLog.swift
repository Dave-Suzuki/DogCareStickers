import Foundation

/// Tracks who completed a task and which sticker they chose
struct TaskCompletion: Codable {
    let stickerID: String
    let memberID: String?   // nil for legacy entries before family feature
    let memberName: String?
    let completedAt: Date

    init(stickerID: String, memberID: String? = nil, memberName: String? = nil) {
        self.stickerID = stickerID
        self.memberID = memberID
        self.memberName = memberName
        self.completedAt = Date()
    }
}

struct DayLog: Identifiable, Codable {
    var id: String { dateKey }
    let dateKey: String
    var completedTasks: [UUID: String]            // taskID -> stickerID (backward compat)
    var completions: [UUID: TaskCompletion]       // taskID -> full completion info

    init(dateKey: String, completedTasks: [UUID: String] = [:], completions: [UUID: TaskCompletion] = [:]) {
        self.dateKey = dateKey
        self.completedTasks = completedTasks
        self.completions = completions
    }

    var completedCount: Int { completedTasks.count }

    func isCompleted(_ taskID: UUID) -> Bool {
        completedTasks[taskID] != nil
    }

    func sticker(for taskID: UUID) -> String? {
        completedTasks[taskID]
    }

    func completion(for taskID: UUID) -> TaskCompletion? {
        completions[taskID]
    }

    /// Who completed a specific task
    func completedBy(_ taskID: UUID) -> String? {
        completions[taskID]?.memberName
    }

    static func todayKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    static func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
