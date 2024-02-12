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
    @Published var name: String = ""
    @Published var notes: String = ""
    @Published var date: String = ""
    @Published var time: String = ""
    @Published var repeatCycle: String = ""
    @Published var durationTime: Double? = 0.0
    @Published var endTime: String = ""
    @Published var isClickable:Bool = false
    @Published var duration:String = ""
    var context:NSManagedObjectContext = PersistenceController.shared.container.viewContext
    @Published var remainders:[CDRemainder] = [CDRemainder]()

    let model:CDList
    init(model: CDList) {
        self.model = model
       todayRemainders()
        clickable
            .receive(on: DispatchQueue.main)
            .assign(to: &$isClickable)
    }
    
    lazy var clickable: AnyPublisher<Bool,Never> = {
        $name
            .map { value in
                return value.count >= 1
            }.eraseToAnyPublisher()
    }()
    
    func reset() {
           DispatchQueue.main.async {
               self.name = ""
               self.notes = ""
               self.date = ""
               self.time = ""
               self.repeatCycle = ""
               self.durationTime = 0.0
               self.endTime = ""
               self.isClickable = false
               self.duration = ""
           }
       }

    
    func addRemainders(title:String,notes:String,repeatcycle:String,date:String,time:String?,duration:Double) async{
        let remainder = CDRemainder(context: PersistenceController.shared.container.viewContext, title: title, notes: notes)
        remainder.schedule_ = CDRemainderSchedule(repeatCycle: repeatcycle, date: date, time: time ??  DateFormatterModel.shared.formattedDatesString(from: Date(), isTime: true), duration: duration, context: PersistenceController.shared.container.viewContext)
        remainder.list = model
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
        }catch{
            print(error.localizedDescription)
        }
        reset()
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
        reset()
    }
    
    

}


