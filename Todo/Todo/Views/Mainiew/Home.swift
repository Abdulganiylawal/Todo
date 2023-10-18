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
    var taskGroup:[TaskGroup] = [.all,.schedule,.today,.completed]
    var context:NSManagedObjectContext
    var taskCountModel:TaskGroupCount
    @State private var reloadFlag = false
    @State var isClicked: Bool = false
  
    init(context:NSManagedObjectContext){
        self.context = context
        _model = StateObject(wrappedValue: ListViewManger(context: context))
        taskCountModel = TaskGroupCount(context: context)
    }
    
    var body: some View {
        NavigationStack{
            VStack() {
                List{
                    Section{
                        GridView(context: context, taskGroups: taskGroup, model: taskCountModel)
                            .id(reloadFlag)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10,  trailing: 0))
                    Section{
                        ForEach(model.myList,id:\.self.id) { list in
                            NavigationLink {
                                RemainderView(model: list)
                            } label: {
                                HStack{
                                    Image(systemName: list.image)
                                        .foregroundColor(Color(hex: list.color))
                                    Text(list.name)
                                    Spacer()
                                    Text("\(taskCountModel.getRemainderCount(list: list))")
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 15))
                            .swipeActions(allowsFullSwipe:true) {
                                Button(role: .destructive) {
                                    model.delete(list: list)
                                    model.fetchList()
                                    reloadFlag.toggle()
                                } label: {
                                    Label("Delete", systemImage: "bin.xmark")
                                }
                            }
                        }
                        
                    }header: {
                        HStack{
                            Text("MY LISTS")
                                .fontWeight(.bold)
                            Spacer()
                            Button {
                                isClicked.toggle()
                            } label: {
                                Image(systemName: "plus.app.fill")
                                
                            }
                        }
                    }   .sheet(isPresented: $isClicked) {
                        NavigationStack{
                            AddList(manager: model)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
        
                .navigationTitle("Tasks")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: colorScheme == .dark ? "000000" : "C4C1A4"))
        }.onAppear {
            model.fetchList()
            reloadFlag.toggle()
        }
    }
}




struct GridView: View {
    @Environment(\.colorScheme) var colorScheme
    let context:NSManagedObjectContext
    var model:TaskGroupCount
    init(context: NSManagedObjectContext, taskGroups: [TaskGroup], model:TaskGroupCount) {
        self.context = context
        self.taskGroups = taskGroups
        self.model = model
    }
    
    let taskGroups: [TaskGroup]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                ForEach(taskGroups, id: \.self) { taskGroup in
                    NavigationLink {
                        GroupedTaskView(selector: taskGroup)
                    } label: {
                        CustomView(iconName: taskGroup.iconName, name: taskGroup.name,ColorDark: taskGroup.colorDark,ColorLight: taskGroup.colorLight)
                    }
                }
            }
          
        }
    }
}

extension GridView{
    func CustomView(iconName:String,name:String,ColorDark:String,ColorLight:String) -> some View{
        HStack{
            VStack(alignment:.leading){
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(hex: colorScheme == .dark ? ColorDark: ColorLight))
                Text(name)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if name == "All"{
                Text("\(model.getCount(item:name))")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(hex: colorScheme == .dark ? "FFFFFF" :  "0F0F0F" ))
            }
            else if name == "Completed"{
                Text("\(model.getCount(item:name))")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(hex: colorScheme == .dark ? "FFFFFF" :  "0F0F0F" ))
            }
            else if name == "Schedule"{
                Text("\(model.getCount(item:name))")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(hex: colorScheme == .dark ? "FFFFFF" :  "0F0F0F" ))
            }
            else if name == "Today"{
                Text("\(model.getCount(item:name))")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color(hex: colorScheme == .dark ? "FFFFFF" :  "0F0F0F" ))
            }
        }
        .padding(10)
        .background(Color(hex: colorScheme == .dark ? "272829" : "8ECDDD"))
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(colorScheme == .light ? 0.5 : 0), radius: 5, x: 0, y: 2)
    }
    

}

//#Preview
//{
//    return Home(context: PersistenceController.shared.container.viewContext)
//    
//}


// MARK: - Some code i might come back too


//    var All:some View{
//        HStack {
//            VStack {
//                Image(systemName: "tray")
//                    .resizable()
//                    .frame(width: 28, height: 25)
//                    .foregroundColor(Color(hex: colorScheme == .dark ? "27E1C1": "618264"))
//                    .fontWeight(.bold)
//                Text("All")
//                    .font(.body)
//                    .fontWeight(.bold)
//                    .foregroundColor(Color(hex: colorScheme == .dark ? "27E1C1": "618264"))
//            }
//            Spacer()
//            Text("1")
//                .font(.title2)
//                .fontWeight(.heavy)
//        }
//        .frame(maxWidth: .infinity)
//        .frame(height: 60)
//        .padding(10)
//        .background(Color(hex: colorScheme == .dark ? "272829":"FAF2D3"))
//        .cornerRadius(15)
//        .shadow(color: Color.gray.opacity(colorScheme == .light ? 0.5 : 0), radius: 5, x: 0, y: 2)
//
//    }
//
//    var Today:some View{
//        HStack{
//            VStack(alignment:.leading){
//                Image(systemName: "sun.max")
//                    .resizable()
//                    .frame(width: 25, height: 25)
//                    .foregroundColor(Color(hex: colorScheme == .dark ?  "F8DE22": "FFD966"))
//                Text("Today")
//                    .font(.body)
//                    .fontWeight(.bold)
//                    .foregroundColor(Color(hex: colorScheme == .dark ?  "F8DE22":"FFD966"))
//            }
//            Spacer()
//            Text("1")
//                .font(.title2)
//                .fontWeight(.heavy)
//        }
//        .padding(10)
//        .background(Color(hex: colorScheme == .dark ? "272829": "EFB495"))
//        .cornerRadius(15)
//        .shadow(color: Color.gray.opacity(colorScheme == .light ? 0.5 : 0), radius: 5, x: 0, y: 2)
//
//    }
//
