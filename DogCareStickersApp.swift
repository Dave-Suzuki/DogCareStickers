import SwiftUI

@main
struct DogCareStickersApp: App {
    @State private var store = StickerStore()

    var body: some Scene {
        WindowGroup {
            DogCareContentView()
                .environment(store)
        }
    }
}
