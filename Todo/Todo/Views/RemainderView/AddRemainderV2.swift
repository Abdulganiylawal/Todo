//
//  AddRemainderV2.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 12/02/2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct AddRemainderV2: View {
    @State var name = ""
    @State var desc = ""
    @State var endTime = ""
    @State var date = ""
    @State var time = ""
    @State var repeatCycle = ""
    @State var durationTime:Double = 0.0
    @EnvironmentObject var sheetManager:SheetManager
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel:RemainderViewModel
    @FocusState var isFocused:Bool
    @State var isDateClicked:Bool = false
    @State var isTimeClicked:Bool = false
    @State var isEndTimeClicked:Bool = false
    @State var isRepeatClicked:Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: false){
                    title
                        .padding(.bottom,5)
                    
                    Divider()
                        .foregroundStyle(Color.white)
                    notes
                        .padding(.bottom,10)
                    
                    if !name.isEmpty {
                        buttons
                            .padding(.bottom,10
                        )
                    }
                    subTask
                }
                .padding()
                Spacer()
                Divider()
                    .foregroundStyle(.white)
            }
            
        }
        .onAppear(perform: {
            isFocused.toggle()
        })
        .overlay(alignment: .bottom) {
            if sheetManager.action.isPresented{
                if isDateClicked{
                    withAnimation {
                        calender(didClose: {
                            isFocused.toggle()
                            isDateClicked.toggle()
                            sheetManager.dismiss()}, date: $date, color: viewModel.model.color)
                    }
                }
                if isTimeClicked{
                    withAnimation {
                        TimeView(didClose: {
                            isFocused.toggle()
                            isTimeClicked.toggle()
                            sheetManager.dismiss()}, time: $time, color: viewModel.model.color)
                        .padding()
                        
                    }
                }
                if isRepeatClicked{
                    withAnimation {
                        Repeat(didClose: {
                            isFocused.toggle()
                            isRepeatClicked.toggle()
                            sheetManager.dismiss()}, repeatCycle: $repeatCycle, color: viewModel.model.color)
                        .padding()
                        
                    }
                }
                if isEndTimeClicked{
                    withAnimation {
                        Duration(didClose: {
                            isFocused.toggle()
                            isEndTimeClicked.toggle()
                            sheetManager.dismiss()}, time: $endTime, color: viewModel.model.color)
                        .padding()
                        
                    }
                }
            }
        }
        .navigationTitle("Adding a task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    isFocused = true
                    dismiss()}, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width:15, height: 15)
                    })
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    print("tap")
                    dismiss()
                    Task {
                        if date.isEmpty {
                            let currentDate = Date()
                            date = DateFormatterModel.shared.formattedDatesString(from: currentDate, isTime: false)
                            
                        }
                        if time.isEmpty{
                            let currentDate = Date()
                            time = DateFormatterModel.shared.formattedDatesString(from: currentDate, isTime: true)
                        }
                        durationTime = DateFormatterModel.shared.timeDifference(from: time, to: endTime) ?? 0.0
                        await viewModel.addRemainders(title: name, notes: desc , repeatcycle: repeatCycle, date: date, time: time, duration: durationTime )
                    }
                    
                }, label: {
                    Text("Create")
                        .foregroundStyle(name.isEmpty ? .red : Color(hex: viewModel.model.color))
                }
                ).disabled(name.isEmpty)
            }
        }
    }
    
    var buttons: some View{
        VStack {
          
            VStack{
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 20,topTrailing: 20))
                        .frame(height: 30)
                        .foregroundStyle(Color(hex: viewModel.model.color))
                        .overlay {
                            HStack(spacing:10){
                                ActionButton(imageName: !isDateClicked ? "calendar.circle" : "calendar.circle.fill" ,  action: {
                                    withAnimation(.bouncy) {
                                        isFocused = false
                                        isDateClicked.toggle()
                                        isTimeClicked = false
                                        isEndTimeClicked = false
                                        isRepeatClicked = false
                                        sheetManager.present()
                                    }})
                                
                                ActionButton(imageName: !isTimeClicked ? "clock.circle" : "clock.circle.fill" ,action:{
                                    withAnimation(.easeOut) {
                                        isFocused = false
                                        isTimeClicked.toggle()
                                        isDateClicked = false
                                        
                                        isEndTimeClicked = false
                                        isRepeatClicked = false
                                        sheetManager.present()
                                    }
                                })
                                ActionButton(imageName: !isEndTimeClicked ? "stopwatch" :"stopwatch.fill", action:{
                                    withAnimation(.easeOut) {
                                        isFocused = false
                                        isEndTimeClicked.toggle()
                                        isTimeClicked = false
                                        isDateClicked = false
                                        isRepeatClicked = false
                                        sheetManager.present()
                                        
                                    }
                                } )
                                ActionButton(imageName: !isRepeatClicked ? "repeat.circle" : "repeat.circle.fill", action: {
                                    withAnimation(.easeOut) {
                                        isFocused = false
                                        isRepeatClicked.toggle()
                                        isDateClicked = false
                                        isEndTimeClicked = false
                                        isTimeClicked = false
                                        sheetManager.present()
                                    }
                                })
                            }.frame(maxWidth:.infinity,alignment: .leading)
                            .padding()
                        }
                    VStack(spacing:5){
                        HStack{
                            Text("Date")
                                .foregroundStyle(.secondary)
                            Spacer()
                            if !date.isEmpty{
                                Text(DateFormatterModel.shared.formatDate(self.date)!)
                                    .foregroundStyle(.secondary)
                                
                            }
                        }
                     
                        HStack{
                            Text("Time")
                                .foregroundStyle(.secondary)
                            Spacer()
                            if !time.isEmpty{
                                Text(time)
                                    .foregroundStyle(.secondary)
                                
                            }
                        }
             
                        HStack{
                            Text("End Time")
                                .foregroundStyle(.secondary)
                            Spacer()
                            if !endTime.isEmpty{
                                Text(endTime)
                                    .foregroundStyle(.secondary)
                                
                            }
                        }
                       
                        HStack{
                            Text("Repeat")
                                .foregroundStyle(.secondary)
                            Spacer()
                            if !repeatCycle.isEmpty{
                                Text(self.repeatCycle)
                                    .foregroundStyle(.secondary)
                                
                            }
                        }
                        
                    }
                    .padding([.top,.bottom,.leading,.trailing],10)
                }
           
            
        }
        .frame(height: 160, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 20,style: .continuous)
                .fill(.thinMaterial)
                .shadow(color: .black, radius: 0.5)
        )
        
    }
    var title:some View {
        HStack {
            Image(systemName: "square.and.pencil")
            
            TextField("", text: $name)
                .foregroundStyle(Color(hex: viewModel.model.color))
                .focused($isFocused)
                .placeholder(when: name.isEmpty, alignment: .leading) {
                    Text("Task Name").foregroundColor(.secondary)
                }
            
        }
        .frame(height: 20)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20,style: .continuous)
                .fill(.thinMaterial)
                .shadow(color: .black, radius: 0.5)
        )
        
        
        //            .background(
        //                RoundedRectangle(cornerRadius: 30,style: .continuous)
        //                    .fill(.ultraThinMaterial)
        //            )
    }
    
    var notes:some View {
        TextField("", text: $desc)
            .foregroundStyle(Color(hex: viewModel.model.color))
            .placeholder(when: desc.isEmpty, alignment: .topLeading) {
                Text("Add a note...").foregroundColor(.secondary)
                
            }
            .padding()
            .frame(height: 150,alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 20,style: .continuous)
                    .fill(.thinMaterial)
                    .shadow(color: .black, radius: 0.5)
            )
    }
    
    var subTask:some View{
        VStack(alignment:.leading){
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 20,topTrailing: 20))
                .frame(height: 30)
                .foregroundStyle(Color(hex: viewModel.model.color))
                .overlay(alignment:.leading) {
                    Button(action: {viewModel.addSubTask()}, label: {
                        Label("Add SubTask", systemImage: "plus.circle")
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                    })
                    .padding()
                }
            ForEach($viewModel.subTasks){ $subTask in
                SubTaskItem(name: $subTask.subTaskName, color: viewModel.model.color)
            }
            .padding([.leading,.bottom],10)
        }
        .frame(minHeight: 150,alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 20,style: .continuous)
                .fill(.thinMaterial)
                .shadow(color: .black, radius: 0.5)
        )
    }
}


@available(iOS 17.0, *)
struct AddRemainderV2_Previews: PreviewProvider {
    static var previews: some View {
        AddRemainderV2(viewModel: RemainderViewModel(model: CDList(name: "", color:    "#384358", image: "", context: PersistenceController.shared.container.viewContext)))
            .environmentObject(SheetManager())
    }
}

struct ActionButton: View {
    let imageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 20,height: 20)
                .foregroundStyle(.black)
        }
        )
    }
}

struct SubTaskItem:View{
    @Binding var name:String
    @State private var isChecked = false
    var color:String
    var body: some View{
        HStack{
            Button(action: {
                isChecked.toggle()
                print(name)
            }, label: {
                Image(systemName: !isChecked ? "square" : "square.fill")
                    .foregroundStyle(Color(hex: color))
            })
            TextField("", text: $name)
                .placeholder(when: name.isEmpty, alignment: .topLeading) {
                    Text("Add a subTask...").foregroundColor(.secondary)
                }
        }
    }
}
