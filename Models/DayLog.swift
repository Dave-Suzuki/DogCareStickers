import Foundation

struct DayLog: Identifiable, Codable {
    var id: String { dateKey }
    let dateKey: String
    var completedTasks: [UUID: String]  // taskID -> sticker emoji

    init(dateKey: String, completedTasks: [UUID: String] = [:]) {
        self.dateKey = dateKey
        self.completedTasks = completedTasks
    }

    var completedCount: Int { completedTasks.count }

    func isCompleted(_ taskID: UUID) -> Bool {
        completedTasks[taskID] != nil
    }

    func sticker(for taskID: UUID) -> String? {
        completedTasks[taskID]
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
