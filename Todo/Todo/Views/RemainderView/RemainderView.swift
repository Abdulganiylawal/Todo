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
    @State var isClicked:Bool = false
    var repeatCycleManager = RepeatCycleManager()
    var model:CDList
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CDRemainder.fetch(), animation: .bouncy) var remainders
    
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
        
            VStack {
                ScrollView(showsIndicators: false){
                    remainder
                        .padding()
                }
               
                .environmentObject(SheetManager())
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItemGroup(placement:.bottomBar) {
                        Button {
                            isClicked.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .foregroundColor(Color(hex: model.color))
                                    .frame(width: 20, height: 20)
                                
                                Text("New Todo")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: model.color))
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 20)
                        }
                        Spacer()
                        Spacer()
                    }
                }
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
                ToolbarItemGroup(placement: .principal) {
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
        ForEach(remainders) { remainder in
            RemainderRow(remainder: remainder, color: model.color, duration: remainder.schedule_?.duration ?? 0.0)
                .padding(.bottom,10)
        }
    }
}


