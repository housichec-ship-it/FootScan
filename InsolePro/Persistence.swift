//
//  Persistence.swift
//  InsolePro
//
//  Created by Анатолий on 26/12/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Preview data should never crash the app: log and continue with empty data.
            let nsError = error as NSError
            print("Persistence preview save failed: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "InsolePro")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Avoid crashing on launch: fall back to an in-memory store and log the error.
                print("Persistent store load failed, falling back to in-memory store: \(error), \(error.userInfo)")
                let description = NSPersistentStoreDescription()
                description.type = NSInMemoryStoreType
                container.persistentStoreDescriptions = [description]
                container.loadPersistentStores { _, retryError in
                    if let retryError = retryError as NSError? {
                        print("In-memory store setup failed: \(retryError), \(retryError.userInfo)")
                    }
                }
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
