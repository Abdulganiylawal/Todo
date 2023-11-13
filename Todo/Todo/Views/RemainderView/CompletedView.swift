//
//  CompletedView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 01/10/2023.
//

import SwiftUI
import CoreData
@available(iOS 17.0, *)
struct CompletedView: View {
    @FetchRequest(fetchRequest: CDRemainder.fetch()) var completedRemainders
    var model:CDList
    
    init(model:CDList){
        self.model = model
        let request = CDRemainder.fetch()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.schedule_?.date_, ascending: true)]
        let predicate1 = NSPredicate(format: "list == %@", self.model  as CVarArg )
        let predicate2 = NSPredicate(format: "isCompleted_ == true")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
        self._completedRemainders = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
            ScrollView{
                ForEach(completedRemainders){
                    remainder in
                    RemainderRow(remainder: remainder, color: model.color, duration: remainder.schedule_?.duration ?? 0.0)
                }
            }.padding()
            
        
     
        
    }
}

//#Preview {
//    let model = ListModel(name: "", image: "", color: "")
//    return CompletedView(model:model)
//}


