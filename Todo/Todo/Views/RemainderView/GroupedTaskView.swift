//
//  GroupedTaskView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 14/10/2023.
//

import SwiftUI
import CoreData

struct GroupedTaskView: View {
    @FetchRequest(fetchRequest: CDRemainder.fetch(), animation: .bouncy) var remainders
    
    var remaindersByList: [String: [CDRemainder]] {
        Dictionary(grouping: remainders) { remainder in
            remainder.list!.name
        }
    }
    
    init(selector: TaskGroup) {
        let request = CDRemainder.fetch()
        switch selector {
            case .all:
                request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.list!.name_, ascending: true)]
                request.predicate = nil
            case .completed:
                request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.list!.name_, ascending: true)]
                request.predicate = NSPredicate(format: "isCompleted_ == true")
            case .schedule:
                request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.list!.name_, ascending: true)]
                request.predicate = NSPredicate(format: "schedule_.date_ != %@", "")
            case .today:
                request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.list!.name_, ascending: true)]
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy MM dd"
                let formattedDates = dateFormatter.string(from: date)
                request.predicate = NSPredicate(format: "schedule_.date_ == %@", formattedDates as CVarArg)
        }
        self._remainders = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        List {
            ForEach(remaindersByList.keys.sorted(), id: \.self) { listName in
                if let listColor = remaindersByList[listName]?.first?.list?.color {
                    Section(header: Text(listName)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: listColor))
                    ) {
                        ForEach(remaindersByList[listName] ?? [], id: \.self) { remainder in
                            HStack(alignment: .top) {
                                if remainder.isCompleted_ {
                                    FilledCircle(color: remainder.list!.color)
                                        .frame(width: 20, height: 20)
                                } else {
                                    EmptyCircle(color: remainder.list!.color)
                                        .frame(width: 20, height: 20)
                                }
                                VStack(alignment: .leading) {
                                    Text(remainder.title)
                                        .foregroundColor(remainder.isCompleted_ ? .secondary : .primary)
                                    Text(remainder.notes)
                                        .foregroundColor(remainder.isCompleted_ ? .secondary : .primary)
                                    Text(remainder.schedule_!.date)
                                        .foregroundColor(remainder.isCompleted_ ? .secondary : .primary)
                                        .frame(alignment: .leading)
                                }
                            }
                            
                        }
                    }
                }
            }
            
        }.listStyle(PlainListStyle())
    }
}

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

struct GroupedTaskView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedTaskView(selector: .all)
    }
}
