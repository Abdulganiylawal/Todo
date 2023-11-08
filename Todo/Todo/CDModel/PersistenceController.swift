import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "TodoModel")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        let storeDescription = container.persistentStoreDescriptions.first
        storeDescription?.shouldMigrateStoreAutomatically = true
        storeDescription?.shouldInferMappingModelAutomatically = true

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Error \(error.localizedDescription)")
            }
        }
    }

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        return controller
    }()

    func save() async {
   
          let context = container.viewContext
          if context.hasChanges {
              await withCheckedContinuation { continuation in
                  context.perform {
                      do {
                          try context.save()
                          continuation.resume()
                      } catch {
                  
                          continuation.resume(throwing: error as! Never)
                      }
                  }
              }
          }
      }
}
