//
//  RemainderModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import Foundation
import Combine
import CoreData
class RemainderViewModel: ObservableObject{
    var context:NSManagedObjectContext = PersistenceController.shared.container.viewContext
    @Published var remainders:[CDRemainder] = [CDRemainder]()
    @Published var subTasks:[CDRemainderSubTasks] = [CDRemainderSubTasks]()
    private var remainder:CDRemainder? = nil
    let model:CDList
    init(model: CDList) {
        self.model = model
        todayRemainders()
    }
    
    @MainActor func addRemainders(title:String,notes:String,repeatcycle:String,date:String,time:String?,duration:Double) async{
        remainder = CDRemainder(context: PersistenceController.shared.container.viewContext, title: title, notes: notes)
        remainder!.schedule_ = CDRemainderSchedule(repeatCycle: repeatcycle, date: date, time: time ??  DateFormatterModel.shared.formattedDatesString(from: Date(), isTime: true), duration: duration, context: PersistenceController.shared.container.viewContext)
        remainder!.list = model
        subTasks.forEach {
            subTask in
            if !subTask.subTaskName.isEmpty{
                subTask.remainders = remainder
            }
        }
        await PersistenceController.shared.save()
        let currentDate = Date()
        let selectedDate = DateFormatterModel.shared.stringDateToDate(from: date, format: "dd/MM/yyyy")
        let isCurrentDate = Calendar.current.isDate(currentDate, inSameDayAs: selectedDate!)
        if isCurrentDate{
            todayRemainders()
        }else{
            scheduleRemainders()
        }
        
    }
    
    func addSubTask(){
        let subTask = CDRemainderSubTasks(context: PersistenceController.shared.container.viewContext, subTaskName: "")
        subTasks.append(subTask)
    }
    
    func todayRemainders(){
        let request = CDRemainder.fetch()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.list!.name_, ascending: true)]
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDates = dateFormatter.string(from: date)
        let predicate1 = NSPredicate(format: "list == %@", self.model as CVarArg)
        let predicate2 = NSPredicate(format: "schedule_.date_ == %@", formattedDates as CVarArg)
        let predicate3 = NSPredicate(format: "isCompleted_ == false")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2,predicate3])
        do{
            remainders = try context.fetch(request)
            //            remainders.forEach { print($0.subTasks.forEach({ print($0.subTaskName)
            //            }))
            //            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func scheduleRemainders(){
        let request = CDRemainder.fetch()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.list!.name_, ascending: true)]
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDates = dateFormatter.string(from: date)
        let predicate1 = NSPredicate(format: "list == %@", self.model as CVarArg)
        let predicate2 = NSPredicate(format: "isCompleted_ == false")
        let predicate3 = NSPredicate(format: "schedule_.date_  != %@", formattedDates as CVarArg)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2,predicate3])
        do{
            remainders = []
            remainders = try context.fetch(request)
        }catch{
            print(error.localizedDescription)
        }
    }
}


