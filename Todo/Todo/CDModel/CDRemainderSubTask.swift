//
//  CDRemainderSubTask.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 15/02/2024.
//

import Foundation
import CoreData

extension CDRemainderSubTasks{
    public var id: UUID {
       return id_ ?? UUID()
   }
   
   public override func awakeFromInsert() {
       self.id_ = UUID()
   }
    
    var createdDate:Date{
        get{
           createdDate_ ?? Date()
        }set{
            createdDate_ = Date()
        }
    }
    
    var subTaskName:String{
        get{
           subTaskName_ ?? ""
        }set{
            subTaskName_ = newValue
        }
    }
    
    static func fetch(predicate: NSPredicate? = nil) -> NSFetchRequest<CDRemainderSubTasks> {
        let request: NSFetchRequest<CDRemainderSubTasks> = CDRemainderSubTasks.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainderSubTasks.createdDate_, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func delete(subTask:CDRemainderSubTasks){
        guard let context = subTask.managedObjectContext else{return}
        context.delete(subTask)
        Task{
            await PersistenceController.shared.save()
        }
    }
    
    convenience init(context:NSManagedObjectContext,subTaskName:String) {
        self.init(context: context)
        self.createdDate = Date()
        self.subTaskName = subTaskName
    }
}

extension CDRemainderSubTasks:Comparable{
    public static func < (lhs: CDRemainderSubTasks, rhs: CDRemainderSubTasks) -> Bool {
        return lhs.subTaskName < rhs.subTaskName
    }
}
