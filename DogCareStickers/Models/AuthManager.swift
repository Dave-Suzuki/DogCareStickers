import SwiftUI
import AuthenticationServices

// Google Sign-In manager for family member tracking.
// NOTE: To enable real Google Sign-In, add the GoogleSignIn SPM package
// and configure your Google Cloud project with an OAuth client ID.
// For now this uses a lightweight local auth approach that can be
// swapped for Google Sign-In when the SDK is integrated.

@Observable
class AuthManager {
    var currentUser: FamilyMember?
    var familyMembers: [FamilyMember] = []
    var isSignedIn: Bool { currentUser != nil }

    private let currentUserKey = "dogcare_current_user"
    private let familyKey = "dogcare_family_members"

    init() {
        load()
    }

    // MARK: - Sign In / Out

    /// Sign in with name and email (local auth for now).
    /// Replace this with GIDSignIn.sharedInstance.signIn() when Google SDK is added.
    func signIn(name: String, email: String) {
        let id = email.lowercased() // use email as stable ID
        let member = FamilyMember(id: id, displayName: name, email: email)
        currentUser = member

        // Add to family if not already a member
        if !familyMembers.contains(where: { $0.id == id }) {
            familyMembers.append(member)
        }
        save()
    }

    func signOut() {
        currentUser = nil
        save()
    }

    /// Switch to a different family member (quick switch)
    func switchUser(to member: FamilyMember) {
        currentUser = member
        save()
    }

    /// Remove a family member
    func removeMember(_ member: FamilyMember) {
        familyMembers.removeAll { $0.id == member.id }
        if currentUser?.id == member.id {
            currentUser = nil
        }
        save()
    }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(data, forKey: currentUserKey)
        } else {
            UserDefaults.standard.removeObject(forKey: currentUserKey)
        }
        if let data = try? JSONEncoder().encode(familyMembers) {
            UserDefaults.standard.set(data, forKey: familyKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: currentUserKey),
           let user = try? JSONDecoder().decode(FamilyMember.self, from: data) {
            currentUser = user
        }
        if let data = UserDefaults.standard.data(forKey: familyKey),
           let members = try? JSONDecoder().decode([FamilyMember].self, from: data) {
            familyMembers = members
        }
    }
}
