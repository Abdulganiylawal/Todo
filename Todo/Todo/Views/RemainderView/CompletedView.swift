//
//  CompletedView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 01/10/2023.
//

import SwiftUI
import CoreData
struct CompletedView: View {
    @FetchRequest(fetchRequest: CDRemainder.fetch()) var completedRemainders
    var model:CDList
    
    init(model:CDList){
        self.model = model
        let request = CDRemainder.fetch()
        let predicate1 = NSPredicate(format: "list == %@", self.model  as CVarArg )
        let predicate2 = NSPredicate(format: "isCompleted_ == true")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
        self._completedRemainders = FetchRequest(fetchRequest: request)
    }
    var body: some View {
        NavigationStack{
            List{
                ForEach(completedRemainders) { remainder in
                    HStack(alignment: .top)
                    {
                        filledReminderLabel
                            .frame(width: 20, height: 20)
                        VStack(alignment:.leading){
                            Text(remainder.title_ ?? "")
                            Text(remainder.notes_ ?? "")
                            Text(remainder.schedule_ ?? "")
                        }
                    }
                    
                }
            }.id(UUID())
            
        }
     
        
    }
    
    var filledReminderLabel: some View {
        Circle()
            .stroke(Color(hex: model.color), lineWidth: 2)
            .overlay(alignment: .center) {
                GeometryReader { geo in
                    VStack {
                        Circle()
                            .fill(Color(hex: model.color))
                            .frame(width: geo.size.width*0.7, height: geo.size.height*0.7, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }
    
}

//#Preview {
//    let model = ListModel(name: "", image: "", color: "")
//    return CompletedView(model:model)
//}
