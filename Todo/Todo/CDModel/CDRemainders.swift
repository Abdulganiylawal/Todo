//
//  CDRemainders.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 11/10/2023.
//

import Foundation
import CoreData

extension CDRemainder{
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
    
    var title:String{
        get{
           title_ ?? ""
        }set{
            title_ = newValue
        }
    }
    
    var notes:String{
        get{
           notes_ ?? ""
        }set{
            notes_ = newValue
        }
    }
    
    var subTasks:Set<CDRemainderSubTasks>{
        get{
            (subTask as? Set<CDRemainderSubTasks>) ?? []
        }
        set{
            subTask = newValue as NSSet
        }
    }
    
    static func delete(remainder:CDRemainder){
        guard let context = remainder.managedObjectContext else {return}
        
        for subTask in remainder.subTasks{
            CDRemainderSubTasks.delete(subTask: subTask)
        }
        
        CDRemainderSchedule.delete(schedule: remainder.schedule_!)
        context.delete(remainder)
        Task{
            await PersistenceController.shared.save()
        }
    }
    
    static func fetch(predicate: NSPredicate? = nil) -> NSFetchRequest<CDRemainder> {
        let request: NSFetchRequest<CDRemainder> = CDRemainder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.title_, ascending: true)]
        request.predicate = predicate
        return request
    }

    
    convenience init(context:NSManagedObjectContext,title:String,notes:String){
        self.init(context: context)
        self.title = title
        self.notes = notes
        self.createdDate = Date()
        self.schedule_ = CDRemainderSchedule(repeatCycle: "", date: "", time: "", duration: 0.0, endTime: "", context: context)
    }
}
