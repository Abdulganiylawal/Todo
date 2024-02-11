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
    @State private var selectedRemainder:CDRemainder? = nil
    @FetchRequest(fetchRequest: CDRemainder.fetch(), animation: .bouncy) var remainders
    private var GroupLogicModel = Grouping()
    private let selector:TaskGroup
    private var repeatCycleManager = RepeatCycleManager()
    @State private var reloadFlag = true
    
    private var groupedByRemainderListName:[String:[CDRemainder]]{
        Dictionary(grouping: remainders) { el in
            GroupLogicModel.groupByName(remainder: el)
        }
    }
    
    private var timeOfDay: [String:[CDRemainder]] {
        Dictionary(grouping:remainders) { el in
            GroupLogicModel.groupByTimeOfDay(for: el)
        }
    }
    
    private var byMonth: [String:[CDRemainder]] {
        Dictionary(grouping:remainders) { el in
            GroupLogicModel.groupByMonth(for: el)
        }
    }
    init(selector: TaskGroup,context:NSManagedObjectContext) {
        self.selector = selector
        let request = CDRemainder.fetch()
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
        Group{
            switch selector{
                case .all, .completed:
                    allAndCompletedView
                        
                case .schedule:
                    scheduleView
                       
                        .padding(0)
                case .today:
                    todayView
                      
                        .padding(0)
            }
            
        }
        .id(reloadFlag)
        .sheet(item: $selectedRemainder) {  remainder in
            NavigationStack{
                EditRemainder(remainders: .constant(remainder) , id:$reloadFlag)
            }
            .presentationBackground(.ultraThinMaterial)
            .presentationCornerRadius(16)
        }
    }
    
    var allAndCompletedView: some View {
        ScrollView(showsIndicators: false) {
            ForEach(groupedByRemainderListName.sorted(by: {$0.key < $1.key}),id:\.key){
                key,value in
                Section {
                    
                    ForEach(value){ remainder in
                        RemainderRow(color: selector.colorDark, remainder: remainder, duration: remainder.schedule_?.duration ?? 0.0,select: "")
                            .padding(.bottom,10)
                            .contextMenu {
                                Button("Delete Remainders", action: {
                                        CDRemainder.delete(remainder: remainder)
                                })
                            }
                    }
                } header: {
                    Text(key)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: value[0].list!.color_!).opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }
            
            .padding()
            
        }.toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text(selector.rawValue.capitalized)
                    .foregroundColor(Color(hex: selector.colorDark))
            }
        })
    }
    
    
    
    var todayView:some View{
        ScrollView(showsIndicators: false){
            ForEach(timeOfDay.sorted(by: {$0.value[0].schedule_!.time_!.description < $1.value[0].schedule_!.time_!.description}), id: \.key) {
                key, value in
                Section {
                    ForEach(value){ (remainder:CDRemainder) in
                        RemainderRow(color: selector.colorDark, remainder: remainder, duration: remainder.schedule_?.duration ?? 0.0,select: "today")
                            .padding(.top,10)
                            .contextMenu {
                                Group {
                                    Button("Edit Remainders", action: {
                                       selectedRemainder = remainder
                                    }
                                    )
                                    Button("Delete Remainders", action: {
                                        
                                            CDRemainder.delete(remainder: remainder)
                                         
                                      
                                    })
                                    Button("Completed", action: {
                                        remainder.isCompleted_ = true
                                        
                                        guard let repeatCycle = remainder.schedule_?.repeatCycle, !repeatCycle.isEmpty else{return}
                                        repeatCycleManager.nextDueDate(remainder: remainder, context: PersistenceController.shared.container.viewContext)
                                  
                                            CDRemainder.delete(remainder: remainder)
                                      
                                        Task{
                                            
                                            await PersistenceController.shared.save()
                                        }
                                    })
                                }
                                
                            }
                        
                    }
                } header: {
                    Text(key)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: selector.colorDark).opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text(selector.rawValue.capitalized)
                    .foregroundColor(Color(hex: selector.colorDark))
            }
        })
        
    }
    
    var scheduleView:some View{
        ScrollView(showsIndicators: false){
            ForEach(byMonth.sorted(by: {$0.value[0].schedule_!.time_!.description < $1.value[0].schedule_!.time_!.description}), id: \.key) {
                key, value in
                Section {
                    ForEach(value){ remainder in
                        RemainderRow(color: selector.colorDark, remainder: remainder, duration: remainder.schedule_?.duration ?? 0.0,select: "today")
                            .padding(.top,10)
                            .contextMenu {
                                Button("Delete Remainders", action: {
                                  
                                        CDRemainder.delete(remainder: remainder)
                                  
                                  
                                })
                            }
                    }
                } header: {
                    Text(key)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: selector.colorDark).opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text(selector.rawValue.capitalized)
                    .foregroundColor(Color(hex: selector.colorDark))
            }
        })
    }
    
}
