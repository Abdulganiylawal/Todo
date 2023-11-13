//  RemainderView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI
import CoreData
@available(iOS 17.0, *)
struct RemainderView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isClicked:Bool = false
     private var repeatCycleManager = RepeatCycleManager()
    private var model:CDList
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
        
        ZStack(alignment:.bottomTrailing) {
            ScrollView(showsIndicators: false){
                remainder
                    .padding()
            }
            Spacer()
            Image(systemName: "plus")
                .foregroundColor(Color(hex: model.color))
                .font(.body)
                .fontWeight(.bold)
                .padding()
                .background(.ultraThinMaterial)
                .backgroundStyle1(cornerRadius: 20,opacity: 0)
                .padding()
                .onTapGesture {
                    isClicked.toggle()
                }
                .padding(.top,630)
                .padding(.leading,300)
            
            
                .environmentObject(SheetManager())
                .navigationBarTitleDisplayMode(.inline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .sheet(isPresented: $isClicked, content: {
                    NavigationStack{
                        AddRemainder(model: model)
                            .environmentObject(SheetManager())
                    }
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
                EditRemainder(remainders: .constant(remainder))
            }
        }
    }
}

