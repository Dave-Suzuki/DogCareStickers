import SwiftUI

struct DogCareContentView: View {
    @Environment(StickerStore.self) private var store

    var body: some View {
        TabView {
            DailyTasksView()
                .tabItem {
                    Label("My Jobs", systemImage: "pawprint.fill")
                }

            WeeklyProgressView()
                .tabItem {
                    Label("Progress", systemImage: "star.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(Color(hex: "F97316"))
    }
}

#Preview {
    DogCareContentView()
        .environment(StickerStore())
}
