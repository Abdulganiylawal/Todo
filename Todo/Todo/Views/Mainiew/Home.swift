//
//  Home.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/09/2023.
//

import SwiftUI
import CoreData
import Combine
import SlideButton
@available(iOS 17.0, *)
struct Home: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var model:ListViewManger
    @EnvironmentObject var navigationManager:NavigationManager
    @EnvironmentObject var sheetManager:SheetManager
    @State var isEditing:Bool = false
    @State var isAdding:Bool = false
    var context:NSManagedObjectContext
    var ListEssModel:ListEssentials
    @State private var reloadFlag = false
    let resultGridLayout = [GridItem(.flexible()),GridItem(.flexible())]
    @State private var selectedList:CDList? = nil
    @FetchRequest(fetchRequest: CDList.fetch(), animation: .bouncy) var lists
    init(context:NSManagedObjectContext){
        self.context = context
        _model = StateObject(wrappedValue: ListViewManger(context: context))
        ListEssModel = ListEssentials(context: context)
        let request = CDList.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDList.name_, ascending: true)]
        request.predicate = NSPredicate.all
        self._lists = FetchRequest(fetchRequest: request)
    }
    
    
    
    var body: some View {
        NavigationStack(path: $navigationManager.routes){
            ZStack {
                ScrollView(showsIndicators: false){
                    Section{
                        LazyVGrid(columns: resultGridLayout) {
                            ForEach(TaskGroup.allCases) { taskGroup in
                                NavigationLink(value: Route.groupTaskView(selector: taskGroup, context: self.context)) {
                                    ListView(icon: taskGroup.iconName, name: taskGroup.name, color: taskGroup.colorDark, count: ListEssModel.getCount(item: taskGroup.rawValue))
                                }
                            }
                        }
                    }
                    
                    .padding([.top,.leading,.trailing],20)
                    .id(reloadFlag)
                    
                    HStack{
                        Text("List")
                            .foregroundStyle(.gray)
                            .fontWeight(.medium)
                            .padding([.top,.leading,.trailing],20)
                        Spacer()
                    }
                    
                    
                    Section{
                        LazyVGrid(columns: resultGridLayout) {
                            ForEach(lists,id: \.id) { list in
                                NavigationLink(value: Route.remainderView(model: list)) {
                                    ListView(icon: list.image, name: list.name, color: list.color, count: ListEssModel.getRemainderCount(list: list))
                                    
                                        .contextMenu {
                                            Group {
                                                Button("Edit List", action: {
                                                    selectedList = list
                                                    sheetManager.present()
                                                    isAdding = true
                                                    isEditing = true
                                                    
                                                })
                                                Button("Delete List", action: {
                                                    Task{
                                                        do{
                                                            await CDList.delete(list: list)
                                                            reloadFlag.toggle()
                                                        }
                                                    }
                                                    
                                                })
                                                
                                            }
                                        }
                                }
                            }
                        
                        }
                    }
                    .padding()
                    .id(reloadFlag)
                    .onAppear(perform: {
                        reloadFlag.toggle()
                    })
                    .navigationTitle("")
                    .toolbar(content: {
                        if !sheetManager.action.isPresented{
                            ToolbarItem(placement: .topBarLeading) {
                                NavigationLink(value: Route.SettingsView) {
                                    Image(systemName: "gearshape")
                                        .font(.system(size: 15, weight: .bold))
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color(hex: "#acb7ae"))
                                    
                                }
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                NavigationLink(value: Route.searchView(context: context)) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 15, weight: .bold))
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color(hex: "#acb7ae"))
                                }
                            }
                            
                        }})
                }
                VStack{
                    Spacer()
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.gray, lineWidth: 0.5)
                        .background(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(.ultraThinMaterial)
                        )
                        .frame(width: 200,height: 35)
                        .overlay {
                            SlideButton(styling: SlideButtonStyling(
                                indicatorSize:40,
                                indicatorSpacing:0,
                                indicatorColor: .clear,
                                indicatorSystemName: "plus",textAlignment: .globalCenter
                            )) {
                                sheetManager.present()
                                isEditing = false
                                isAdding = true
                              
                            } label: {
                                //                                Text("Add")
                            }
                        }
                }
                .navigationDestination(for: Route.self)  {  $0}
            }
            .disabled(sheetManager.action.isPresented)
            .blur(radius: sheetManager.action.isPresented ? 20 : 0)
            .overlay{
                    if sheetManager.action.isPresented {
                        if isAdding {
                            withAnimation(.bouncy) {
                                AddListV2(model: model)
                            }
                        }
                        if isEditing {
                            withAnimation(.bouncy) {
                                EditListV2( reloadFlag: $reloadFlag, list: Binding.constant(selectedList!))
                            }
                            }
                            
                    }
            }
        }
    }
}

@available(iOS 17.0, *)
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        
        return Group {
            Home(context: PersistenceController.shared.container.viewContext)
                .preferredColorScheme(.dark)
                .environmentObject(NavigationManager())
            
        }
    }
}
