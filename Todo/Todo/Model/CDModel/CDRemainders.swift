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
    
    var schedule: Date{
        get{
            schedule_ ?? Date()
        }
        set{
            schedule_ = newValue
        }
    }
    
    convenience init(context:NSManagedObjectContext,title:String,notes:String,schedule:Date){
        self.init(context: context)
        self.title = title
        self.notes = notes
        self.schedule = schedule
//        iscomplete_ = isCompleted
    }
    
    
}
