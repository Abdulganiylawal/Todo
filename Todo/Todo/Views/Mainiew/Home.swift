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
    let resultGridLayout = [GridItem(.adaptive(minimum: 150), spacing: 10 ,
                              alignment: .top)]

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
            ScrollView(showsIndicators: false){
                Section{
                    LazyVGrid(columns: resultGridLayout) {
                        ForEach(TaskGroup.allCases) { taskGroup in
                            ListView(icon: taskGroup.iconName, name: taskGroup.name, color: colorScheme == .light ? taskGroup.colorLight : taskGroup.colorDark, count: ListEssModel.getCount(item: taskGroup.rawValue), remainders: ListEssModel.get3Remainder(for: taskGroup))
                        }
                    }
                }
                .padding([.top,.leading,.trailing],20)
                LabeledContent {
                    Button {
                        isClicked.toggle()
                    } label: {
                        Image(systemName: "plus.app.fill")
                            .foregroundStyle(.green)
                    
                    }
                } label: {
                    Text("My Lists")
                        .foregroundStyle(.secondary)
                        .fontWeight(.medium)
                }
                .padding([.top,.leading,.trailing],20)
             
                Section{
                    LazyVGrid(columns: resultGridLayout) {
                        
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
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(colorScheme == .light ? Color(hex: "F3EEEA").opacity(0.4).frame(width:99999,height:99999) : Color(UIColor.black).frame(width:99999,height: 99999)  )
    
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
