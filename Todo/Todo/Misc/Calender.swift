//
//  Calender.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 27/09/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct calender: View {
    @State private var dates = Date()
    @State private var time = Date()
    @State private var showDate = false
    @State private var showTime = false
    let repeatCycles = ["Never", "Daily", "Weekly", "Monthly", "Yearly"]
    @State private var picked = "Never"
    @Environment(\.presentationMode) var presentationMode
    @Binding var schedule:CDRemainderSchedule?
    @Binding var editedDate: String
    
    var body: some View {
        List {
            Toggle("Date", systemImage: "calendar", isOn: $showDate)
                .toggleStyle(SwitchToggleStyle(tint: Color(hex: (schedule?.remainder?.list?.color)!)))
            if showDate {
                DatePicker(
                    "Start Date",
                    selection: $dates,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
        
            }
            Toggle("Time", systemImage: "clock.badge", isOn: $showTime)
                .toggleStyle(SwitchToggleStyle(tint: Color(hex: (schedule?.remainder?.list?.color)!)))
                .onChange(of: showTime, initial: false) {
                    showDate.toggle()
                }
            
            if showTime{
                HStack{
                    DatePicker(
                        "",
                        selection: $time,
                        displayedComponents: [.hourAndMinute]
                    )
                    .datePickerStyle(.wheel)
                    
                }
            }
                Picker(selection: $picked) {
                    ForEach(repeatCycles,id: \.self){
                        repeatCycle in
                        Text(repeatCycle)
                    }
                } label: {
                    Label("Repeat", systemImage: "repeat")
                }.onChange(of: picked, initial: false) { oldValue, newValue in
                    if newValue != "Never"{
                        schedule?.repeatCycle = newValue
                }
                }.disabled(!showDate)
        }
        .toolbar(content: {
            ToolbarItem {
                Button {
                    schedule?.date = formattedDatesString(from: dates, isTime: false)
                    editedDate = schedule!.date
                    if showTime{
                        schedule?.time = formattedDatesString(from: time, isTime: true)
                    }
              
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                }

            }
        })
    }
    
    private func formattedDatesString(from component: Date,isTime:Bool) -> String {
        let dateFormatter = DateFormatter()
        if isTime{
            dateFormatter.dateFormat = "HH:mm"
        }
        else{
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }
        let dateComponents = component
        let formattedDates = dateFormatter.string(from: dateComponents)
        return formattedDates
    }
}

@available(iOS 17.0, *)
struct calender_Previews: PreviewProvider {
    static var previews: some View {
        let list = CDList(name: "", color: "D83F31", image: "", context: PersistenceController.shared.container.viewContext)
        let remainders = CDRemainder(context: PersistenceController.shared.container.viewContext, title: "", notes: "")
        remainders.list = list
        remainders.schedule_ = CDRemainderSchedule(repeatCycle: "", date: "", time: "", context: PersistenceController.shared.container.viewContext)

        return Group {
            calender(schedule: .constant(remainders.schedule_), editedDate: .constant(""))
        }
    }
}

