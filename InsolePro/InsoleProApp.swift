//
//  InsoleProApp.swift
//  InsolePro
//
//  Created by Анатолий on 26/12/2025.
//

import SwiftUI
import CoreData

@main
struct InsoleProApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
