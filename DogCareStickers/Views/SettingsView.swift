import SwiftUI

struct SettingsView: View {
    @Environment(StickerStore.self) private var store
    @Environment(AuthManager.self) private var auth
    @State private var editingName = ""
    @State private var showingNameEdit = false
    @State private var showAddMember = false

    var body: some View {
        @Bindable var store = store

        NavigationStack {
            List {
                // Dog section
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

                // Current user section
                if let user = auth.currentUser {
                    Section("Signed In As") {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: user.colorHex))
                                    .frame(width: 40, height: 40)
                                Text(user.initials)
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(user.displayName)
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                Text(user.email)
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Family members section
                Section("Family Members") {
                    ForEach(auth.familyMembers) { member in
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: member.colorHex))
                                    .frame(width: 32, height: 32)
                                Text(member.initials)
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(member.displayName)
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                Text(member.email)
                                    .font(.system(size: 11, design: .rounded))
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            if member.id == auth.currentUser?.id {
                                Text("You")
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Capsule().fill(Color(hex: member.colorHex)))
                            } else {
                                Button("Switch") {
                                    auth.switchUser(to: member)
                                }
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                            }
                        }
                        .padding(.vertical, 2)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            auth.removeMember(auth.familyMembers[index])
                        }
                    }

                    Button {
                        showAddMember = true
                    } label: {
                        Label("Add Family Member", systemImage: "person.badge.plus")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                }

                // Helper leaderboard
                let stats = store.memberStats()
                if !stats.isEmpty {
                    Section("Who's Helping Most?") {
                        ForEach(Array(stats.enumerated()), id: \.element.member) { index, stat in
                            HStack {
                                Text(index == 0 ? "🏆" : index == 1 ? "🥈" : "🥉")
                                    .font(.system(size: 20))
                                Text(stat.member)
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                Spacer()
                                Text("\(stat.count) tasks")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                // Sign out
                Section {
                    Button(role: .destructive) {
                        auth.signOut()
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.forward")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
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
            .navigationTitle("Settings")
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
            .sheet(isPresented: $showAddMember) {
                SignInFormSheet(onSignIn: { name, email in
                    auth.signIn(name: name, email: email)
                })
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(StickerStore())
        .environment(AuthManager())
}
