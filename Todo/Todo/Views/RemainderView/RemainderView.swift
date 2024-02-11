//  RemainderView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI
import CoreData
@available(iOS 17.0, *)
struct RemainderView: View ,ReminderHandler{
    @Environment(\.colorScheme) var colorScheme
    @State var selectedTab: TabModel = .today
    @State private var isClicked:Bool = false
     private var repeatCycleManager = RepeatCycleManager()
    private var model:CDList
    @State private var id = true
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CDRemainder.fetch(), animation: .bouncy) var remainders
    @State private var selectedRemainder:CDRemainder? = nil
    init(model:CDList){
        self.model = model
        let request = CDRemainder.fetch()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.schedule_?.date_, ascending: true)]
        let predicate1 = NSPredicate(format: "list == %@", self.model as CVarArg)
        let predicate2 = NSPredicate(format: "isCompleted_ == false")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
        self._remainders = FetchRequest(fetchRequest: request, animation: .bouncy)
    }
    
    var body: some View {

        ZStack(alignment:.bottom) {
            ScrollView(showsIndicators: false){
                remainder
                    .id(id)
                    .padding()
            }
            VStack{
                Spacer()
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(Color.gray, lineWidth: 0.5)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(.thinMaterial)
                    )
                    .frame(width: 150,height: 45)
                    .overlay {
                        HStack{
                            Button(action:{
                                
                                todayRemainders()
                            }, label: {
                                Image(systemName: selectedTab != .today ? "sun.max" : "sun.max.circle.fill"  )
                                    .resizable()
                                    .frame(width: 20,height: 20)
                                    .foregroundStyle(Color.white)
                            })
                            .sensoryFeedback(.success, trigger: selectedTab == .today)
                            .padding()
                            Spacer()
                           
                            Button(action:scheduleRemainders
                                   , label: {
                                Image(systemName: selectedTab != .scheduled ? "calendar" : "calendar.circle.fill")
                                    .resizable()
                                    .frame(width: 20,height: 20)
                                    .foregroundStyle(Color.white)
                            })
                            .sensoryFeedback(.success, trigger: selectedTab == .scheduled)
                            Spacer()
                            Button(action: {
                                selectedTab = .add
                                isClicked.toggle()
                            }, label: {
                                Image(systemName: selectedTab != .add ?  "square.and.pencil" : "square.and.pencil.circle.fill")
                                    .resizable()
                                    .frame(width: 20,height: 20)
                                    .foregroundStyle(Color.white)
                            })
                            .sensoryFeedback(.success, trigger: selectedTab == .add)
                            .padding()
                        }
                    }
                
            }
                .navigationBarTitleDisplayMode(.inline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .sheet(isPresented: $isClicked, content: {
                    NavigationStack{
                        AddRemainder(model: model)
                            .environmentObject(SheetManager())
                    }
                    .presentationBackground(.ultraThinMaterial)
                    .presentationCornerRadius(16)
                })
                .background(
                    Text(remainders.isEmpty ? "Empty" : "")
                )
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text(model.name)
                    .foregroundColor(Color(hex: model.color))
            }
            ToolbarItem {
                DropdownMenu(model: model)
            }
        })
        
    }
    
    // MARK: -  Remainder Loop
    var remainder: some View{
        ForEach(remainders,id: \.self) { remainder in
         
            RemainderRow(color: model.color, remainder: remainder, duration:remainder.schedule_?.duration ?? 0.0,select: "")
                .padding(.bottom,10)
                
                .contextMenu {
                        Group {
                            Button("Edit Remainders", action: {
                                selectedRemainder = remainder
                            })
                            Button("Delete Remainders", action: {
                                CDRemainder.delete(remainder: remainder)
                            })
                            Button("Completed", action: {
                                remainder.isCompleted_ = true
                                guard let repeatCycle = remainder.schedule_?.repeatCycle, !repeatCycle.isEmpty else{return}
                                repeatCycleManager.nextDueDate(remainder: remainder, context: context)
                                Task{
                                    await PersistenceController.shared.save()
                                }
                            })
                        }
                    
                }
           
        }
        .sheet(item: $selectedRemainder) {  remainder in
            NavigationStack{
                EditRemainder(remainders: .constant(remainder),id:$id)
            }
            .presentationBackground(.ultraThinMaterial)
            .presentationCornerRadius(16)
        }
    }
   func todayRemainders(){
        selectedTab = .today
        
    }
    
    func scheduleRemainders(){
        selectedTab = .scheduled
    }
    
}

protocol ReminderHandler {
    mutating func todayRemainders()
    mutating func scheduleRemainders()
}



