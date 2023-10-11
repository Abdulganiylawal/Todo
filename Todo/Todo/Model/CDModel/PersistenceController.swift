//
//  PersistenceController.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 11/10/2023.
//

import Foundation
import CoreData

struct PersistenceController{
    
    static let shared = PersistenceController()
    
    let container:NSPersistentContainer
    
    init(inMemory:Bool = false) {
        self.container = NSPersistentContainer(name: "TodoModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { descriptor, error in
            if let error = error as? NSError{
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    static var preview:PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        return controller
    }()
    
    func save(){
        let context = container.viewContext
        
        guard context.hasChanges else{return}
        do{
          try  context.save()
        }catch{
            print("\(error)")
        }
       
    }
}
