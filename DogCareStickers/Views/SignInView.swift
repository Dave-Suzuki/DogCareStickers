import SwiftUI

struct SignInView: View {
    @Environment(AuthManager.self) private var auth
    @State private var name = ""
    @State private var email = ""
    @State private var showSignIn = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "FFF8F0"), Color(hex: "F5E6D3")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                // App logo area
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "FFD93D"), Color(hex: "F97316")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .shadow(color: Color(hex: "F97316").opacity(0.3), radius: 12, y: 6)

                        Text("🐶")
                            .font(.system(size: 52))
                    }

                    Text("Dog Care Stickers")
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(hex: "8B7355"))

                    Text("Take care of your pup together\nas a family!")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                }

                Spacer()

                // Quick family member switcher (if members exist)
                if !auth.familyMembers.isEmpty {
                    VStack(spacing: 12) {
                        Text("Welcome back!")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "8B7355"))

                        ForEach(auth.familyMembers) { member in
                            Button {
                                auth.switchUser(to: member)
                            } label: {
                                HStack(spacing: 12) {
                                    // Avatar
                                    ZStack {
                                        Circle()
                                            .fill(Color(hex: member.colorHex))
                                            .frame(width: 40, height: 40)
                                        Text(member.initials)
                                            .font(.system(size: 15, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                    }

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(member.displayName)
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundColor(.primary)
                                        Text(member.email)
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundColor(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(Color(hex: member.colorHex))
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(.white)
                                        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                // Sign in button
                VStack(spacing: 12) {
                    Button {
                        showSignIn = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 18, weight: .semibold))
                            Text(auth.familyMembers.isEmpty ? "Get Started" : "Add Family Member")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "3B82F6"), Color(hex: "2563EB")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: Color(hex: "3B82F6").opacity(0.3), radius: 8, y: 4)
                    }

                    Text("Sign in so the family can see who helped!")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(Color(.systemGray))
                }
                .padding(.horizontal, 32)

                Spacer()
                    .frame(height: 40)
            }
        }
        .sheet(isPresented: $showSignIn) {
            SignInFormSheet(onSignIn: { signedName, signedEmail in
                auth.signIn(name: signedName, email: signedEmail)
            })
        }
    }
}

// MARK: - Sign In Form Sheet

struct SignInFormSheet: View {
    let onSignIn: (String, String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var email = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "FFF8F0")
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("Who's helping today?")
                        .font(.system(size: 24, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(hex: "8B7355"))

                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Your Name")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "8B7355"))
                            TextField("e.g. Mom, Dad, Sarah...", text: $name)
                                .font(.system(size: 16, design: .rounded))
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.white)
                                        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                                )
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "8B7355"))
                            TextField("your@email.com", text: $email)
                                .font(.system(size: 16, design: .rounded))
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.white)
                                        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
                                )
                        }
                    }
                    .padding(.horizontal)

                    Button {
                        onSignIn(name.trimmingCharacters(in: .whitespaces),
                                 email.trimmingCharacters(in: .whitespaces))
                        dismiss()
                    } label: {
                        Text("Join the Family!")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "22C55E"), Color(hex: "16A34A")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty ||
                              email.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(name.trimmingCharacters(in: .whitespaces).isEmpty ||
                             email.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top, 32)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(.systemGray3))
                    }
                }
            }
        }
    }
}

#Preview("Sign In - Empty") {
    SignInView()
        .environment(AuthManager())
}

#Preview("Sign In Form") {
    SignInFormSheet(onSignIn: { name, email in
        print("Signed in: \(name), \(email)")
    })
}
