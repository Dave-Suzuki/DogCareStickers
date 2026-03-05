import SwiftUI

struct WeeklyProgressView: View {
    @Environment(StickerStore.self) private var store

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "F5E6D3")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        streakBanner
                        weekGrid
                        statsSection
                        stickerCollection
                    }
                    .padding()
                }
            }
            .navigationTitle("My Progress")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Streak

    private var streakBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Streak")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                HStack(spacing: 6) {
                    Text("🔥")
                        .font(.system(size: 26))
                    Text("\(store.streakDays()) days")
                        .font(.system(size: 26, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            Spacer()
            Text(streakEmoji)
                .font(.system(size: 44))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "F97316"), Color(hex: "EF4444")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }

    private var streakEmoji: String {
        let streak = store.streakDays()
        if streak >= 7 { return "🏆" }
        if streak >= 3 { return "⭐" }
        if streak >= 1 { return "🌟" }
        return "🐾"
    }

    // MARK: - Week Grid

    private var weekGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundColor(Color(hex: "8B7355"))

            HStack(spacing: 6) {
                ForEach(weekDates, id: \.self) { date in
                    dayColumn(for: date)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }

    private func dayColumn(for date: Date) -> some View {
        let log = store.log(for: date)
        let isToday = Calendar.current.isDateInToday(date)
        let allDone = log.completedCount >= store.tasks.count && !store.tasks.isEmpty

        return VStack(spacing: 6) {
            Text(dayAbbrev(date))
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(isToday ? Color(hex: "F97316") : Color(.systemGray))

            ZStack {
                Circle()
                    .fill(allDone
                          ? Color(hex: "22C55E").opacity(0.15)
                          : Color(.systemGray6))
                    .frame(width: 42, height: 42)

                if allDone {
                    // Show a gold star sticker for all-done days
                    if let goldStar = StickerDesign.find(by: "super_star_gold") {
                        StickerView(design: goldStar, size: .small)
                    }
                } else if log.completedCount > 0 {
                    // Show count with color
                    Text("\(log.completedCount)")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(hex: "F97316"))
                } else {
                    Circle()
                        .fill(Color(.systemGray4))
                        .frame(width: 6, height: 6)
                }
            }

            // Mini progress dots
            HStack(spacing: 2) {
                ForEach(0..<min(store.tasks.count, 7), id: \.self) { i in
                    Circle()
                        .fill(i < log.completedCount
                              ? Color(hex: allDone ? "22C55E" : "F97316")
                              : Color(.systemGray5))
                        .frame(width: 4, height: 4)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isToday ? Color(hex: "F97316") : Color.clear, lineWidth: 2)
        )
    }

    private var weekDates: [Date] {
        let calendar = Calendar.current
        let today = Date()
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return []
        }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
    }

    private func dayAbbrev(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f.string(from: date)
    }

    // MARK: - Stats

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fun Stats")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundColor(Color(hex: "8B7355"))

            HStack(spacing: 10) {
                statCard(title: "Total\nStickers", value: "\(totalStickers)",
                         colors: [Color(hex: "FFD93D"), Color(hex: "F97316")])
                statCard(title: "Day\nStreak", value: "\(store.streakDays())",
                         colors: [Color(hex: "FF6B6B"), Color(hex: "EF4444")])
                statCard(title: "Done\nToday", value: "\(store.todayCompletedCount)",
                         colors: [Color(hex: "22C55E"), Color(hex: "16A34A")])
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }

    private func statCard(title: String, value: String, colors: [Color]) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
                )
            Text(title)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(Color(.systemGray))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemGray6).opacity(0.6))
        )
    }

    // MARK: - Sticker Collection

    private var stickerCollection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My Sticker Collection")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundColor(Color(hex: "8B7355"))

            if earnedStickerDesigns.isEmpty {
                VStack(spacing: 8) {
                    Text("🐾")
                        .font(.system(size: 36))
                    Text("Complete tasks to earn stickers!")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Color(.systemGray))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            } else {
                let columns = [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                ]
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(earnedStickerDesigns) { design in
                        StickerView(design: design, size: .medium)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }

    private var earnedStickerDesigns: [StickerDesign] {
        var designs: [StickerDesign] = []
        for log in store.dayLogs.values {
            for stickerID in log.completedTasks.values {
                if let design = StickerDesign.find(by: stickerID),
                   !designs.contains(design) {
                    designs.append(design)
                }
            }
        }
        return designs
    }

    private var totalStickers: Int {
        store.dayLogs.values.reduce(0) { $0 + $1.completedCount }
    }
}

#Preview {
    WeeklyProgressView()
        .environment(StickerStore())
}
