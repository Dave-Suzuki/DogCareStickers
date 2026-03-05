import SwiftUI

struct SettingsView: View {
    @Environment(StickerStore.self) private var store
    @State private var editingName = ""
    @State private var showingNameEdit = false

    var body: some View {
        @Bindable var store = store

        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("🐶")
                            .font(.system(size: 40))
                        VStack(alignment: .leading) {
                            Text(store.dogName)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                            Text("Your best friend!")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button("Edit") {
                            editingName = store.dogName
                            showingNameEdit = true
                        }
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                    .padding(.vertical, 4)
                }

                Section("About") {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Label("Made with", systemImage: "heart.fill")
                            .foregroundColor(.pink)
                        Spacer()
                        Text("love for dogs 🐾")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("⚙️ Settings")
            .alert("Dog's Name", isPresented: $showingNameEdit) {
                TextField("Name", text: $editingName)
                Button("Save") {
                    if !editingName.trimmingCharacters(in: .whitespaces).isEmpty {
                        store.dogName = editingName
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("What's your dog's name?")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(StickerStore())
}
