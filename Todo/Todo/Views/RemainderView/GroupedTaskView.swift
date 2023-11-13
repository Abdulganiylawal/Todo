//
//  GroupedTaskView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 14/10/2023.
//

import SwiftUI
import CoreData

@available(iOS 17.0, *)
struct GroupedTaskView: View {
    @FetchRequest(fetchRequest: CDRemainder.fetch(), animation: .bouncy) var remainders
    var selector:TaskGroup
    
    private var remaindersByList: [String: [CDRemainder]] {
        Dictionary(grouping: remainders) { remainder in
            remainder.list!.name
        }
    }
    
    private var remaindersByMonth: [String: [CDRemainder]] {
        Dictionary(
            grouping: remainders)
        { remainder in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-mm-yy"
            return  (remainder.schedule_?.date_)!
        }
    }
    
    
    init(selector: TaskGroup) {
        let request = CDRemainder.fetch()
        self.selector = selector
        switch selector {
            case .all:
                request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.list!.name_, ascending: true)]
                let request1 = NSPredicate(format: "title_ != %@", "")
                let request2 = NSPredicate(format: "notes_ != %@", "")
                let request3 = NSCompoundPredicate(orPredicateWithSubpredicates: [request1,request2])
                let request4 = NSPredicate(format: "isCompleted_ == false")
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [request3,request4])
            case .completed:
                request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.list!.name_, ascending: true)]
                request.predicate = NSPredicate(format: "isCompleted_ == true")
            case .schedule:
                request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.list!.name_, ascending: true)]
                let request1 = NSPredicate(format: "isCompleted_ == false")
                let request2 = NSPredicate(format: "schedule_.date_  != %@", "")
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [request1,request2])
            case .today:
                request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.list!.name_, ascending: true)]
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let formattedDates = dateFormatter.string(from: date)
                let request1 = NSPredicate(format: "schedule_.date_ == %@", formattedDates as CVarArg)
                let request2 = NSPredicate(format: "isCompleted_ == false")
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [request1,request2])
        }
        self._remainders = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        switch selector{
            case .all, .completed:
                allAndCompletedView
                    .padding(0)
                
            case .schedule:
                scheduleView
                    .padding(0)
            case .today:
                todayView
                    .padding(0)
        }
    }
    var allAndCompletedView: some View {
        ScrollView(showsIndicators: false) {
            ForEach(remainders, id: \.self) {
                remainder in
                RemainderRow(color: selector.colorDark, remainder: remainder, duration: remainder.schedule_?.duration ?? 0.0,select: "allandcompleted")
                    .padding(.bottom,10)
                
            }
            .padding()
            .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        Text(selector.rawValue.capitalized)
                            .foregroundColor(Color(hex: selector.colorDark))
                    }
                })
        }
    }
    
    
    
    var scheduleView:some View{
        ScrollView(showsIndicators: false){
            ForEach(remainders, id: \.self) {
                remainder in
                RemainderRow(color: selector.colorDark, remainder: remainder, duration: remainder.schedule_?.duration ?? 0.0,select: "schedule")
                    .padding(.bottom,10)
            }
            .padding()
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text(selector.rawValue.capitalized)
                        .foregroundColor(Color(hex: selector.colorDark))
                }
            })
        }
   
    }
    
    var todayView:some View{
        ScrollView(showsIndicators: false){
            ForEach(remainders, id: \.self) {
                remainder in
                RemainderRow(color: selector.colorDark, remainder: remainder, duration: remainder.schedule_?.duration ?? 0.0,select: "today")
                    .padding(.bottom,10)
            }
    
        }.padding()
        .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text(selector.rawValue.capitalized)
                        .foregroundColor(Color(hex: selector.colorDark))
                }
            })
    }
    
}


@available(iOS 17.0, *)
struct GroupedTaskView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedTaskView(selector: .all)
    }
}

