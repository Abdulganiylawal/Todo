//
//  TaskGroup.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 14/10/2023.
//

import Foundation
import CoreData
enum TaskGroup: String, Identifiable, CaseIterable {
    case all
    case schedule
    case today
    case completed
    
    var id: String {
        switch self {
            case .all:
                ".all"
            case .today:
                ".today"
            case .schedule:
                ".schedule"
            case .completed:
                ".completed"
        }
    }
    
    var name: String {
        switch self{
            case .all:
                return "All"
            case .today:
                return "Today"
            case .schedule:
                return "Schedule"
            case .completed:
                return "Completed"
        }
    }
    
    var iconName: String {
        switch self{
            case .all:
                return "tray"
            case .today:
                return "sun.max"
            case .schedule:
                return "calendar.badge.clock"
            case .completed:
                return "checkmark"
        }
    }
 
    var colorDark:String{
        switch self {
            case .all:
                return "6499E9"
            case .today:
                return "#FFEB3B"
            case .schedule:
                return "#3AAFA9"
            case .completed:
                return "#9CCC65"
        }
    }
}

class ListEssentials{
    var context:NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getCount(item:String)->Int{
        var count = 0
        let request = CDRemainder.fetch()
        
        if item == "all"{
            let request1 = NSPredicate(format: "title_ != %@", "")
            let request2 = NSPredicate(format: "notes_ != %@", "")
            let request3 = NSPredicate(format: "isCompleted_ == false")
            let request4 = NSCompoundPredicate(orPredicateWithSubpredicates: [request1,request2])
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [request3,request4])
        }
        else if item == "completed"{
            request.predicate = NSPredicate(format: "isCompleted_ == true")
        }
        else if item == "schedule"{
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDates = dateFormatter.string(from: date)
            let request1 = NSPredicate(format: "isCompleted_ == false")
            let request2 = NSPredicate(format: "schedule_.date_  != %@", formattedDates as CVarArg)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [request1,request2])
        }
        else if item == "today"{
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDates = dateFormatter.string(from: date)
            let request1 = NSPredicate(format: "schedule_.date_ == %@", formattedDates as CVarArg)
            let request2 = NSPredicate(format: "isCompleted_ == false")
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [request1,request2])
        }
        do{
            count = try context.count(for: request)
        }catch{
            print(error)
        }
        request.predicate = nil
        return count
    }
    
    func getRemainderCount(list:CDList) ->Int{
        let request = CDRemainder.fetch()
        var count:Int = 0
        let predicate1 = NSPredicate(format: "list == %@", list as CVarArg)
        let predicate2 = NSPredicate(format: "isCompleted_ == false")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
        do{
            count = try context.count(for: request)
        }catch{
            print(error)
        }
        return count
    }
    
}


