//
//  RemainderModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import Foundation
class AddRemainderModel: ObservableObject{
    @Published var name: String = ""
     @Published var notes: String = ""
     @Published var date: String = ""
     @Published var time: String = ""
     @Published var repeatCycle: String = ""
     @Published var durationTime: String? = ""
     @Published var endTime: String = ""
    
    let model:CDList
    init(model: CDList) {
        self.model = model
    }
    func addRemainders(title:String,notes:String,repeatcycle:String,date:String,time:String,duration:String) async{
        let remainder = CDRemainder(context: PersistenceController.shared.container.viewContext, title: title, notes: notes)
        remainder.schedule_ = CDRemainderSchedule(repeatCycle: repeatcycle, date: date, time: time, duration: duration, context: PersistenceController.shared.container.viewContext)
        remainder.list = model
        print(remainder.schedule_?.duration)
        await PersistenceController.shared.save()
    }
}
