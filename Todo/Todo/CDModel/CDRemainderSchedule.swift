//
//  CDRemainderSchedule.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 15/10/2023.
//

import Foundation
import CoreData


extension CDRemainderSchedule{
    var repeatCycle:String{
        get{
            repeatCycle_ ?? ""
        }set{
            repeatCycle_ = newValue
        }
    }
    
    var date:String{
        get{
            date_ ?? ""
        }set{
            date_ = newValue
        }
    }
    
    var time:String{
        get{
            time_ ?? ""
        }set{
            time_ = newValue
        }
    }
    
    var endTime:String{
        get{
            endTime_ ?? ""
        }set{
            endTime_ = newValue
        }
    }
    
    var duration:Double{
        get{
            duration_
        }set{
            duration_ = newValue
        }
    }
    
 
    static func delete(schedule:CDRemainderSchedule){
        guard let context = schedule.managedObjectContext else{return}
        context.delete(schedule)
    }

    convenience init(repeatCycle:String,date:String,time:String,duration:Double,endTime:String,context:NSManagedObjectContext) {
        self.init(context: context)
        self.repeatCycle = repeatCycle
        self.date = date
        self.time = time
        self.endTime = endTime
        self.duration = duration
     
    }
}
