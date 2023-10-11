//
//  RemainderModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import Foundation
import CoreData


class RemainderViewModel:ObservableObject{
    var model:CDList
    var context:NSManagedObjectContext
    @Published var remainders:[CDRemainder] = []
    @Published var completedRemainders:[CDRemainder] = []
    
    init(model: CDList,context:NSManagedObjectContext) {
        self.model = model
        self.context = context
    }
    
    func addRemainders(){
        let remainder :CDRemainder = CDRemainder(context: context, title: "", notes: "", schedule: "")
        remainder.list = model
        
    }
    
    func getRemainders(){
        let requests = CDRemainder.fetchRequest()
        requests.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.schedule_, ascending: true)]
        requests.predicate = NSPredicate.all
        do{
            let results = try context.fetch(requests)
            model.remainders = Set(results)
        }catch{
            print("\(error.localizedDescription)")
        }
    }
}
