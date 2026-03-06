//
//  DogCareStickersApp.swift
//  DogCareStickers
//
//  Created by DaveS on 3/5/26.
//

import SwiftUI
import CoreData

@main
struct DogCareStickersApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
