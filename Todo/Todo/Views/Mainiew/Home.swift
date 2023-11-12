//
//  Home.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/09/2023.
//

import SwiftUI
import CoreData
import Combine
@available(iOS 17.0, *)
struct Home: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var model:ListViewManger
    @EnvironmentObject var navigationManager:NavigationManager
    
    var context:NSManagedObjectContext
    var ListEssModel:ListEssentials
    @State private var reloadFlag = false
    @State var isClicked: Bool = false
    let resultGridLayout = [GridItem(.adaptive(minimum: 150), spacing: 15,
                                     alignment: .top)]
    init(context:NSManagedObjectContext){
        self.context = context
        _model = StateObject(wrappedValue: ListViewManger(context: context))
        ListEssModel = ListEssentials(context: context)
        
    }
    
    
    
    var body: some View {
        NavigationStack(path: $navigationManager.routes){
            
            ZStack(alignment:.bottomTrailing) {
                ScrollView(showsIndicators: false){
                    Section{
                        LazyVGrid(columns: resultGridLayout) {
                            ForEach(TaskGroup.allCases) { taskGroup in
                                NavigationLink(value: Route.groupTaskView(selector: taskGroup)) {
                                    ListView(icon: taskGroup.iconName, name: taskGroup.name, color: taskGroup.colorDark, count: ListEssModel.getCount(item: taskGroup.rawValue), remainders: ListEssModel.get3Remainder(for: taskGroup))
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
                            ForEach(model.myList,id: \.id) { list in
                                NavigationLink(value: Route.remainderView(model: list)) {
                                    ListView(icon: list.image, name: list.name, color: list.color, count: ListEssModel.getRemainderCount(list: list), remainders: ListEssModel.get3Remainder(for: list))
//                                        .contextMenu {
//                                            menuItems
//                                        }
//                                        .sheet(isPresented: $isClicked) {
//                                            NavigationStack{
//                                                EditRemainder(remainders: li)
//                                            }
//                                            
//                                        }
                                }
                            }
                        }
                        .id(reloadFlag)
                        .padding()
                        
                        
                    }
                    
                    
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(Color(hex: "6e7b8b"))
                        .font(.body)
                        .fontWeight(.bold)
                        .padding()
                        .background(.ultraThinMaterial)
                        .backgroundStyle1(cornerRadius: 20,opacity: 0)
                        .padding()
                        .onTapGesture {
                            isClicked.toggle()
                        }
                    
                        .navigationTitle("")
                        .toolbar(content: {
                            ToolbarItem(placement: .topBarLeading) {
                                NavigationLink(value: Route.SettingsView) {
                                    Image(systemName: "gearshape")
                                        .font(.system(size: 15, weight: .bold))
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.secondary)
                                        .background(.ultraThinMaterial)
                                        .backgroundStyle1(cornerRadius: 10, opacity: 0.4)
                                    
                                    
                                }
                                
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                NavigationLink(value: Route.SearchView) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 15, weight: .bold))
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.secondary)
                                        .background(.ultraThinMaterial)
                                        .backgroundStyle1(cornerRadius: 10, opacity: 0.4)
                                    
                                }
                            }
                            
                        })
                        .onAppear {
                            model.fetchList()
                            reloadFlag.toggle()
                        }
                        .sheet(isPresented: $isClicked) {
                            NavigationStack{
                                AddList(manager: model)
                            }
                        }
                    
                }
                
                .navigationDestination(for: Route.self)  {  $0}
                
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
