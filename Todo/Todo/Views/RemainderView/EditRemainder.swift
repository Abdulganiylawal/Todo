import SwiftUI

@available(iOS 17.0, *)
struct EditRemainder: View {
    @State var name = ""
    @State var desc = ""
    @State var endTime = ""
    @State var date = ""
    @State var time = ""
    @State var repeatCycle = ""
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
                    buttons
                        .padding(.bottom,5)
                    notes
                        .padding(.bottom,5)
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
        })
        .overlay(alignment: .bottom) {
            if sheetManager.action.isPresented{
                if isDateClicked{
                    withAnimation {
                        calender(didClose: {
                            isFocused.toggle()
                            isDateClicked.toggle()
                            sheetManager.dismiss()}, date: $date, color: remainder.list!.color)
                        .padding()
                        
                    }
                }
                if isTimeClicked{
                    withAnimation {
                        TimeView(didClose: {
                            isFocused.toggle()
                            isTimeClicked.toggle()
                            sheetManager.dismiss()}, time: $time, color: remainder.list!.color)
                        .padding()
                        
                    }
                }
                if isRepeatClicked{
                    withAnimation {
                        Repeat(didClose: {
                            isFocused.toggle()
                            isRepeatClicked.toggle()
                            sheetManager.dismiss()}, repeatCycle: $repeatCycle, color:remainder.list!.color)
                        .padding()
                        
                    }
                }
                if isEndTimeClicked{
                    withAnimation {
                        Duration(didClose: {
                            isFocused.toggle()
                            isEndTimeClicked.toggle()
                            sheetManager.dismiss()}, time: $endTime, color: remainder.list!.color)
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
            if !name.isEmpty {
                VStack(spacing:15){
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
                    }.frame(maxWidth:.infinity,alignment: .trailing)
                    VStack{
                        HStack{
                            Text("Date")
                                .foregroundStyle(.secondary)
                            Spacer()
                            if !date.isEmpty{
                                Text(DateFormatterModel.shared.formatDate(self.date)!)
                                    .foregroundStyle(.secondary)
                                
                            }
                        }
                        Spacer()
                        HStack{
                            Text("Time")
                                .foregroundStyle(.secondary)
                            Spacer()
                            if !time.isEmpty{
                                Text(time)
                                    .foregroundStyle(.secondary)
                                
                            }
                        }
                        Spacer()
                        HStack{
                            Text("End Time")
                                .foregroundStyle(.secondary)
                            Spacer()
                            if !endTime.isEmpty{
                                Text(endTime)
                                    .foregroundStyle(.secondary)
                                
                            }
                        }
                        Spacer()
                        HStack{
                            Text("Repeat")
                                .foregroundStyle(.secondary)
                            Spacer()
                            if !repeatCycle.isEmpty{
                                Text(self.repeatCycle)
                                    .foregroundStyle(.secondary)
                                
                            }
                        }
                        Spacer()
                    }
                    .frame(height: 100, alignment: .topLeading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20,style: .continuous)
                            .fill(.thinMaterial)
                            .shadow(color: .black, radius: 0.5)
                    )
                    Divider()
                        .foregroundStyle(Color.white)
                }
            } else {
                EmptyView()
            }
            
        }
        
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
}
