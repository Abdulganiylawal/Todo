//  RemainderView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI
import CoreData
@available(iOS 17.0, *)
struct RemainderView: View{
    @Environment(\.colorScheme) var colorScheme
    @State var selectedTab: TabModel = .today
    @State private var isClicked:Bool = false
     private var repeatCycleManager = RepeatCycleManager()
    private var model:CDList
    @State private var id = true
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CDRemainder.fetch(), animation: .bouncy) var remainders
    @State private var selectedRemainder:CDRemainder? = nil
    @StateObject var viewModel:RemainderViewModel
    init(model:CDList){
        self.model = model
        _viewModel = StateObject(wrappedValue: RemainderViewModel(model: model))
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
                RemaindersTab(selectedTab: $selectedTab, isClicked: $isClicked, model: viewModel,colors: model.color)
            }
                .navigationBarTitleDisplayMode(.inline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .sheet(isPresented: $isClicked, content: {
                    NavigationStack{
                        AddRemainder(model: viewModel)
                            .environmentObject(SheetManager())
                    }
                    .presentationBackground(.ultraThinMaterial)
                    .presentationCornerRadius(16)
                })
                .background(
                    Text(viewModel.remainders.isEmpty ? "Empty" : "")
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
        ForEach(viewModel.remainders,id: \.self) { remainder in
         
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

    
}





