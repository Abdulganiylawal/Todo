import SwiftUI

@available(iOS 17.0, *)
struct EditRemainder: View {
    @State var name = ""
    @State var desc = ""
    @State var endTime = ""
    @State var date = ""
    @State var time = ""
    @State var repeatCycle = ""
    @State var subTasks:[CDRemainderSubTasks] = []
    @State var durationTime:Double = 0.0
    @Binding var reloadFlag:Bool
    @Binding var remainder:CDRemainder
    @EnvironmentObject var sheetManager:SheetManager
    @Environment(\.dismiss) private var dismiss
    @FocusState var isFocused:Bool
    @State var isDateClicked:Bool = false
    @State var isTimeClicked:Bool = false
    @State var isEndTimeClicked:Bool = false
    @State var isRepeatClicked:Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(showsIndicators:false){
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
            }
            
        }
        .onAppear(perform: {
            isFocused.toggle()
            name = remainder.title
            desc = remainder.notes
            date = remainder.schedule_!.date_!
            time = remainder.schedule_!.time_!
            if let value = remainder.schedule_?.repeatCycle{
                repeatCycle = value
            }
            subTasks = Array(remainder.subTasks)
        })
        .overlay(alignment: .bottom) {
            if sheetManager.action.isPresented{
                if isDateClicked{
                    withAnimation(.snappy){
                        calender(didClose: {
                            isFocused = false
                            isDateClicked.toggle()
                            sheetManager.dismiss()}, date: $date, color: remainder.list!.color)
                        .padding()
                        
                    }
                }
                if isTimeClicked{
                    withAnimation(.snappy){
                        TimeView(didClose: {
                            isFocused = false
                            isTimeClicked.toggle()
                            sheetManager.dismiss()}, time: $time, color: remainder.list!.color)
                        .padding()
                        
                    }
                }
                if isRepeatClicked{
                    withAnimation(.snappy) {
                        Repeat(didClose: {
                            isFocused = false
                            isRepeatClicked.toggle()
                            sheetManager.dismiss()}, repeatCycle: $repeatCycle, color:remainder.list!.color)
                        .padding()
                        
                    }
                }
                if isEndTimeClicked{
                    withAnimation(.snappy) {
                        Duration(didClose: {
                            isFocused = false
                            isEndTimeClicked.toggle()
                            sheetManager.dismiss()}, time: $endTime, color: remainder.list!.color)
                        .padding()
                        
                    }
                }
            }
        }
        .navigationTitle("Editing a task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: {
                    dismiss()}, label: {
                        Image(systemName: "xmark")
                               .resizable()
                               .frame(width:15, height: 15)
                    })
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    Task{
                        if date.isEmpty {
                            let currentDate = Date()
                            date = DateFormatterModel.shared.formattedDatesString(from: currentDate, isTime: false)
                            
                        }
                        if time.isEmpty{
                            let currentDate = Date()
                            time = DateFormatterModel.shared.formattedDatesString(from: currentDate, isTime: true)
                        }
                        durationTime = DateFormatterModel.shared.timeDifference(from: time, to: endTime) ?? 0.0
                        remainder.title = name
                        remainder.notes = desc
                        remainder.schedule_!.date_! = date
                        remainder.schedule_!.time_! = time
                        remainder.schedule_?.repeatCycle = repeatCycle
                        remainder.schedule_?.duration = durationTime
                        remainder.subTasks = Set(subTasks.map({ $0 }).sorted(by: { $0.createdDate > $1.createdDate}))
                        reloadFlag.toggle()
                        await PersistenceController.shared.save()
                        dismiss()
                    }
                }, label: {
                    Text("Edit")
                        .foregroundStyle(name.isEmpty ? .red : Color(hex: remainder.list!.color))
                        .padding([.top,.bottom,.leading,.trailing],10)
                }
                ).disabled(name.isEmpty)
            }
        }
    }
    
    var buttons: some View{
        VStack {
            VStack(alignment:.leading){
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 20,topTrailing: 20))
                        .frame(height: 30)
                        .foregroundStyle(Color(hex: remainder.list!.color))
                        .overlay(alignment:.leading) {
                            HStack(spacing:10){
                                ActionButton(imageName: date.isEmpty ? "calendar.circle" : "calendar.circle.fill" ,  action: {
                                    withAnimation(.bouncy) {
                                        isFocused = false
                                        isDateClicked.toggle()
                                        isTimeClicked = false
                                        isEndTimeClicked = false
                                        isRepeatClicked = false
                                        sheetManager.present()
                                    }})
                                
                                ActionButton(imageName: time.isEmpty ? "clock.circle" : "clock.circle.fill" ,action:{
                                    withAnimation(.easeOut) {
                                        isFocused = false
                                        isTimeClicked.toggle()
                                        isDateClicked = false
                                        
                                        isEndTimeClicked = false
                                        isRepeatClicked = false
                                        sheetManager.present()
                                    }
                                })
                                ActionButton(imageName: endTime.isEmpty ? "stopwatch" :"stopwatch.fill", action:{
                                    withAnimation(.easeOut) {
                                        isFocused = false
                                        isEndTimeClicked.toggle()
                                        isTimeClicked = false
                                        isDateClicked = false
                                        isRepeatClicked = false
                                        sheetManager.present()
                                    }
                                } )
                                ActionButton(imageName: repeatCycle.isEmpty ? "repeat.circle" : "repeat.circle.fill", action: {
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
                .foregroundStyle(Color(hex: remainder.list!.color))
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
    }
    
    var notes:some View {
        TextField("", text: $desc)
            .foregroundStyle(Color(hex: remainder.list!.color))
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
                .foregroundStyle(Color(hex: remainder.list!.color))
                .overlay(alignment:.leading) {
                    Button(action: {subTasks.append(CDRemainderSubTasks(context: PersistenceController.shared.container.viewContext, subTaskName: ""))}, label: {
                        Label("Add SubTask", systemImage: "plus.circle")
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                    })
                    .padding()
                }
       
                
                ForEach($subTasks, id: \.subTaskName){ $subTask in
                    HStack{
                        Button {
                            if let index = subTasks.firstIndex(of: subTask){
                                subTasks.remove(at: index)
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(.gray)
                        }
                        SubTaskItem(name: $subTask.subTaskName, isCompleted: $subTask.isCompleted, isEditing: true, color:remainder.list!.color)
                    }
                }
                .padding(.bottom,5)
                .padding(.leading,10)
        }
        .frame(minHeight: 150,alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 20,style: .continuous)
                .fill(.thinMaterial)
                .shadow(color: .black, radius: 0.5)
        )
    }
}
