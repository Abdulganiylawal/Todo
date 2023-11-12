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
        List {
            ForEach(remainders, id: \.self) {
                remainder in
                RemainderRow(remainder: remainder, color: selector.colorDark, duration: remainder.schedule_?.duration ?? 0.0)
                    .overlay {
                        Text(remainder.list!.name)
                            .foregroundStyle(Color(hex: remainder.list!.color))
                            .font(.caption)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .backgroundStyle1(cornerRadius: 10, opacity: 0.2)
                            .padding(.leading,270)
                            .padding(.top,-45)
                    }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
    }
    
    
    
    var scheduleView:some View{
        List{
            ForEach(remainders, id: \.self) {
                remainder in
                RemainderRow(remainder: remainder, color: selector.colorDark, duration: remainder.schedule_?.duration ?? 0.0)
                    .overlay {
                        ZStack(alignment: .topTrailing){
                            Text(remainder.list!.name)
                                .foregroundStyle(Color(hex: remainder.list!.color))
                                .font(.caption)
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .backgroundStyle1(cornerRadius: 10, opacity: 0.2)
                        }
                        .frame(alignment: .topTrailing)
                    }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
    }
    
    var todayView:some View{
        List{
            ForEach(remainders, id: \.self) {
                remainder in
                RemainderRow(remainder: remainder, color: selector.colorDark, duration: remainder.schedule_?.duration ?? 0.0)
                    .overlay {
                        Text(remainder.list!.name)
                            .foregroundStyle(Color(hex: remainder.list!.color))
                            .font(.caption)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .backgroundStyle1(cornerRadius: 10, opacity: 0.2)
                            .padding(.leading,270)
                            .padding(.top,-35)
                    }
          
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
    }
    
}
@available(iOS 17.0, *)
extension GroupedTaskView {
    
    func FilledCircle(color:String) ->some View{
        Circle()
            .stroke(Color(hex: color), lineWidth: 2)
            .overlay(alignment: .center) {
                GeometryReader { geo in
                    VStack {
                        Circle()
                            .fill(Color(hex: color))
                            .frame(width: geo.size.width*0.7, height: geo.size.height*0.7, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }
    func EmptyCircle(color:String) -> some View{
        return Circle()
            .stroke(Color(hex: color))
    }
    
}

@available(iOS 17.0, *)
struct GroupedTaskView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedTaskView(selector: .all)
    }
}

