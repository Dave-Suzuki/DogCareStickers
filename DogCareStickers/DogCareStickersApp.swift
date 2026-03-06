import SwiftUI

@main
struct DogCareStickersApp: App {
    @State private var store = StickerStore()
    @State private var auth = AuthManager()

    var body: some Scene {
        WindowGroup {
            Group {
                if auth.isSignedIn {
                    DogCareContentView()
                } else {
                    SignInView()
                }
            }
            .environment(store)
            .environment(auth)
        }
    }
}
   
