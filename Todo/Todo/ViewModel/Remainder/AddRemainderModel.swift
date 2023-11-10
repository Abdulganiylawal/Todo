//
//  RemainderModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import Foundation
import Combine
import CoreData
class AddRemainderModel: ObservableObject{
    @Published var name: String = ""
     @Published var notes: String = ""
     @Published var date: String = ""
     @Published var time: String = ""
     @Published var repeatCycle: String = ""
    @Published var durationTime: Double? = 0.0
     @Published var endTime: String = ""
    @Published var isClickable:Bool = false
    @Published var duration:String = ""
    

    
    let model:CDList
    init(model: CDList) {
        self.model = model
  
        clickable
            .assign(to: &$isClickable)
    }
    
    lazy var clickable: AnyPublisher<Bool,Never> = {
        $name
            .map { value in
                return value.count >= 1
            }.eraseToAnyPublisher()
    }()
    
    func addRemainders(title:String,notes:String,repeatcycle:String,date:String,time:String,duration:Double) async{
        let remainder = CDRemainder(context: PersistenceController.shared.container.viewContext, title: title, notes: notes)
        remainder.schedule_ = CDRemainderSchedule(repeatCycle: repeatcycle, date: date, time: time, duration: duration, context: PersistenceController.shared.container.viewContext)
        
        remainder.list = model
        await PersistenceController.shared.save()
    }
}
