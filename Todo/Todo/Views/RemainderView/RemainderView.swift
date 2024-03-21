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
    @State private var hasAppeared:Bool = false
    @EnvironmentObject var sheetManager:SheetManager
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
                RemaindersTab(selectedTab: $selectedTab, isClicked: $isClicked, sheetManager: .constant(sheetManager), model: viewModel,colors: model.color)
            
            }
                .navigationBarTitleDisplayMode(.inline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .sheet(isPresented: $isClicked, content: {
                    NavigationStack{
                        AddRemainderV2(viewModel: viewModel)
                            .environmentObject(SheetManager())
                    }
                    .presentationBackground(.ultraThinMaterial)
                    .presentationCornerRadius(16)
                    .presentationDragIndicator(.visible)
                })
                .background(
                    Text(viewModel.remainders.isEmpty ? "Empty" : "")
                )
        }
        .onAppear {
            hasAppeared.toggle()
            withAnimation(.spring) {
                viewModel.todayRemainders()
            }
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
        ForEach(Array(viewModel.remainders.enumerated()),id: \.offset) { index,remainder in
         
            RemainderRow(color: model.color, remainder: remainder, duration:remainder.schedule_?.duration ?? 0.0, select: "")
//                .hiddenNavBar(true)
                .padding(.bottom,10)
                .scrollTransition(.animated(.easeOut)) { view, phase in
                    view.blur(radius: phase.isIdentity ? 0 : 30);}
                .scrollTransition(.animated(.easeOut)) { view, phase in
                    view.scaleEffect(phase.isIdentity ? 1 : 0.6)
                                 }
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
                            .sensoryFeedback(.success, trigger: remainder.isCompleted_ )
                        }
                }
        }
        .sheet(item: $selectedRemainder) {  remainder in
            NavigationStack{
                EditRemainder(reloadFlag: $id, remainder: .constant(remainder))
            }
            .presentationBackground(.ultraThinMaterial)
            .presentationCornerRadius(16)
        }
    }

    
}





