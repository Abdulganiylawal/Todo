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
    var context:NSManagedObjectContext
    var ListEssModel:ListEssentials
    @State private var reloadFlag = false
    @State var isClicked: Bool = false
    

    @GestureState var press = false
    init(context:NSManagedObjectContext){
        self.context = context
        _model = StateObject(wrappedValue: ListViewManger(context: context))
        ListEssModel = ListEssentials(context: context)
      
    }
    
    var menuItems: some View {
        Group {
            Button("Action 1", action: {})
            Button("Action 2", action: {})
            Button("Action 3", action: {})
        }
   }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                Section{
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(TaskGroup.allCases) { taskGroup in
                            ListView(icon: taskGroup.iconName, name: taskGroup.name, color: colorScheme == .light ? taskGroup.colorLight : taskGroup.colorDark, count: ListEssModel.getCount(item: taskGroup.rawValue), remainders: ListEssModel.get3Remainder(for: taskGroup))
                             
                            
                        }
                    }
                }
                LabeledContent {
                    Button {
                        isClicked.toggle()
                    } label: {
                        Image(systemName: "plus.app.fill")
                        
                        
                    }
                } label: {
                    Text("My Lists")
                        .foregroundStyle(.secondary)
                }
                Section{
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        
                        ForEach(model.myList,id: \.id) { list in
                            NavigationLink {
                                RemainderView(model: list)
                            } label: {
                                ListView(icon: list.image, name: list.name, color: list.color, count: ListEssModel.getRemainderCount(list: list), remainders: ListEssModel.get3Remainder(for: list))
                                    .contextMenu {
                                        menuItems
                                    }
                            }
                        }
                    }
                }
                
            }
            .frame(maxWidth: .infinity)
            .background(colorScheme == .light ? Color(hex: "C5DFF8").opacity(0.4).frame(width:99999,height:99999) : Color(UIColor.black).frame(width:99999,height: 99999)  )
            .padding()
            .id(reloadFlag)
        }
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
}


@available(iOS 17.0, *)
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        
        return Group {
            Home(context: PersistenceController.shared.container.viewContext)
        }
    }
}
