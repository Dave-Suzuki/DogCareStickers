import SwiftUI

@Observable
class StickerStore {
    var tasks: [DogTask]
    var dayLogs: [String: DayLog]  // dateKey -> DayLog
    var dogName: String

    private let tasksKey = "dogcare_tasks"
    private let logsKey = "dogcare_logs"
    private let nameKey = "dogcare_dogname"

    init() {
        self.tasks = DogTask.defaultTasks
        self.dayLogs = [:]
        self.dogName = "Buddy"
        load()
    }

    // MARK: - Today

    var todayLog: DayLog {
        let key = DayLog.todayKey()
        return dayLogs[key] ?? DayLog(dateKey: key)
    }

    var todayCompletedCount: Int {
        todayLog.completedCount
    }

    var allTasksDoneToday: Bool {
        todayCompletedCount >= tasks.count
    }

    var morningTasks: [DogTask] {
        tasks.filter { $0.timeOfDay == .morning }
    }

    var eveningTasks: [DogTask] {
        tasks.filter { $0.timeOfDay == .evening }
    }

    // MARK: - Task Actions

    func completeTask(_ taskID: UUID, withStickerID stickerID: String, by member: FamilyMember? = nil) {
        let key = DayLog.todayKey()
        var log = dayLogs[key] ?? DayLog(dateKey: key)
        log.completedTasks[taskID] = stickerID
        log.completions[taskID] = TaskCompletion(
            stickerID: stickerID,
            memberID: member?.id,
            memberName: member?.displayName
        )
        dayLogs[key] = log
        save()
    }

    func uncompleteTask(_ taskID: UUID) {
        let key = DayLog.todayKey()
        guard var log = dayLogs[key] else { return }
        log.completedTasks.removeValue(forKey: taskID)
        log.completions.removeValue(forKey: taskID)
        dayLogs[key] = log
        save()
    }

    func completedBy(_ taskID: UUID) -> String? {
        todayLog.completedBy(taskID)
    }

    /// Get task completion stats per family member
    func memberStats() -> [(member: String, count: Int)] {
        var stats: [String: Int] = [:]
        for log in dayLogs.values {
            for completion in log.completions.values {
                let name = completion.memberName ?? "Unknown"
                stats[name, default: 0] += 1
            }
        }
        return stats.map { (member: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }

    func isTaskDoneToday(_ taskID: UUID) -> Bool {
        todayLog.isCompleted(taskID)
    }

    func stickerForTask(_ taskID: UUID) -> String? {
        todayLog.sticker(for: taskID)
    }

    func stickerDesign(for taskID: UUID) -> StickerDesign? {
        guard let stickerID = stickerForTask(taskID) else { return nil }
        return StickerDesign.find(by: stickerID)
    }

    // MARK: - History

    func log(for date: Date) -> DayLog {
        let key = DayLog.dateKey(for: date)
        return dayLogs[key] ?? DayLog(dateKey: key)
    }

    func streakDays() -> Int {
        var count = 0
        var date = Date()
        let calendar = Calendar.current
        while true {
            let key = DayLog.dateKey(for: date)
            guard let log = dayLogs[key], log.completedCount >= tasks.count else { break }
            count += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: date) else { break }
            date = prev
        }
        return count
    }

    // MARK: - Persistence

    private func save() {
        if let tasksData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(tasksData, forKey: tasksKey)
        }
        if let logsData = try? JSONEncoder().encode(dayLogs) {
            UserDefaults.standard.set(logsData, forKey: logsKey)
        }
        UserDefaults.standard.set(dogName, forKey: nameKey)
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let saved = try? JSONDecoder().decode([DogTask].self, from: data) {
            tasks = saved
        }
        if let data = UserDefaults.standard.data(forKey: logsKey),
           let saved = try? JSONDecoder().decode([String: DayLog].self, from: data) {
            dayLogs = saved
        }
        if let name = UserDefaults.standard.string(forKey: nameKey) {
            dogName = name
        }
    }
}
