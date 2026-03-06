import SwiftUI

struct DailyTasksView: View {
    @Environment(StickerStore.self) private var store
    @Environment(AuthManager.self) private var auth
    @State private var selectedTaskID: UUID?
    @State private var showStickerPicker = false
    @State private var showCelebration = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Board background
                Color(hex: "F5E6D3")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Chart board header
                        chartHeader

                        // Progress bar
                        progressBar

                        // Morning section
                        taskSection(
                            title: "Morning",
                            icon: "sunrise.fill",
                            color: Color(hex: "F97316"),
                            tasks: store.morningTasks
                        )

                        // Evening section
                        taskSection(
                            title: "Evening",
                            icon: "sunset.fill",
                            color: Color(hex: "8B5CF6"),
                            tasks: store.eveningTasks
                        )

                        // Streak banner
                        if store.streakDays() > 0 {
                            streakBanner
                        }

                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showStickerPicker) {
                StickerPickerView { stickerID in
                    if let taskID = selectedTaskID {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            store.completeTask(taskID, withStickerID: stickerID, by: auth.currentUser)
                        }
                        if store.allTasksDoneToday {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showCelebration = true
                            }
                        }
                    }
                }
            }
            .overlay {
                if showCelebration {
                    celebrationOverlay
                }
            }
        }
    }

    // MARK: - Chart Header

    private var chartHeader: some View {
        VStack(spacing: 8) {
            // Board title banner
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "FF6B6B"), Color(hex: "FFD93D")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 60)

                HStack {
                    Text(store.dogBreed.icon)
                        .font(.system(size: 32))

                    VStack(alignment: .leading, spacing: 0) {
                        Text("My Jobs To Do")
                            .font(.system(size: 22, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        Text("for \(store.dogName)")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                    }

                    Spacer()

                    // Date badge
                    VStack(spacing: 0) {
                        Text(dayOfWeek)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "FF6B6B"))
                        Text(dayNumber)
                            .font(.system(size: 18, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "FF6B6B"))
                    }
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    )
                }
                .padding(.horizontal, 16)
            }

            // Greeting with current user
            HStack(spacing: 6) {
                if let user = auth.currentUser {
                    ZStack {
                        Circle()
                            .fill(Color(hex: user.colorHex))
                            .frame(width: 24, height: 24)
                        Text(user.initials)
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                Text(greetingForTimeOfDay)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(Color(hex: "8B7355"))
            }
        }
    }

    private var dayOfWeek: String {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f.string(from: Date()).uppercased()
    }

    private var dayNumber: String {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f.string(from: Date())
    }

    private var greetingForTimeOfDay: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            return "Good morning! Let's take care of \(store.dogName)!"
        } else if hour < 17 {
            return "Good afternoon! How's \(store.dogName) doing?"
        } else {
            return "Good evening! Finish up \(store.dogName)'s care!"
        }
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Today's Progress")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "8B7355"))
                Spacer()
                Text("\(store.todayCompletedCount) of \(store.tasks.count) done")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(Color(hex: "8B7355").opacity(0.7))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .frame(height: 16)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: store.allTasksDoneToday
                                    ? [Color(hex: "22C55E"), Color(hex: "16A34A")]
                                    : [Color(hex: "FFD93D"), Color(hex: "F97316")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * progressFraction, height: 16)
                        .animation(.spring(response: 0.5), value: progressFraction)
                }
            }
            .frame(height: 16)

            // Mini sticker row showing earned stickers
            if store.todayCompletedCount > 0 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(store.tasks) { task in
                            if let design = store.stickerDesign(for: task.id) {
                                StickerView(design: design, size: .small)
                            }
                        }
                    }
                }
                .frame(height: 38)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.6))
        )
    }

    private var progressFraction: CGFloat {
        guard !store.tasks.isEmpty else { return 0 }
        return CGFloat(store.todayCompletedCount) / CGFloat(store.tasks.count)
    }

    // MARK: - Task Section

    private func taskSection(title: String, icon: String, color: Color, tasks: [DogTask]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Section header
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)

                Text(title)
                    .font(.system(size: 15, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)

                // Count badge
                let doneCount = tasks.filter { store.isTaskDoneToday($0.id) }.count
                if doneCount > 0 {
                    Text("\(doneCount)/\(tasks.count)")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(.white))
                }

                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
            )

            // Task rows
            VStack(spacing: 8) {
                ForEach(tasks) { task in
                    TaskRowView(
                        task: task,
                        isCompleted: store.isTaskDoneToday(task.id),
                        stickerDesign: store.stickerDesign(for: task.id),
                        completedByName: store.completedBy(task.id),
                        onTap: {
                            selectedTaskID = task.id
                            showStickerPicker = true
                        },
                        onUndo: {
                            withAnimation(.spring(response: 0.3)) {
                                store.uncompleteTask(task.id)
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Streak Banner

    private var streakBanner: some View {
        HStack(spacing: 10) {
            Text("🔥")
                .font(.system(size: 28))

            VStack(alignment: .leading, spacing: 2) {
                Text("\(store.streakDays()) Day Streak!")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                Text("Keep it going, superstar!")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
            }

            Spacer()

            Text(streakEmoji)
                .font(.system(size: 36))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "F97316"), Color(hex: "EF4444")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        )
    }

    private var streakEmoji: String {
        let streak = store.streakDays()
        if streak >= 7 { return "🏆" }
        if streak >= 3 { return "⭐" }
        return "🌟"
    }

    // MARK: - Celebration

    private var celebrationOverlay: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { showCelebration = false }

            VStack(spacing: 20) {
                // Scattered stickers around the edges
                ZStack {
                    ForEach(0..<6, id: \.self) { i in
                        let designs = StickerDesign.allStickers
                        let design = designs[i % designs.count]
                        StickerView(design: design, size: .medium)
                            .rotationEffect(.degrees(Double.random(in: -20...20)))
                            .offset(
                                x: CGFloat.random(in: -100...100),
                                y: CGFloat.random(in: -60...60)
                            )
                            .opacity(0.6)
                    }

                    VStack(spacing: 12) {
                        Text("🎉\(store.dogBreed.icon)🎉")
                            .font(.system(size: 50))

                        Text("SUPER STAR!")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "FFD93D"), Color(hex: "F97316"), Color(hex: "EF4444")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text("\(store.dogName) is SO happy!\nAll tasks done today!")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(.systemGray))
                    }
                }

                Button {
                    showCelebration = false
                } label: {
                    Text("Yay! 🎉")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 48)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "FF6B6B"), Color(hex: "F97316")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: Color(hex: "FF6B6B").opacity(0.4), radius: 8, y: 4)
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 24)
            )
            .padding(32)
            .transition(.scale.combined(with: .opacity))
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showCelebration)
    }
}

#Preview {
    DailyTasksView()
        .environment(StickerStore())
        .environment(AuthManager())
}
