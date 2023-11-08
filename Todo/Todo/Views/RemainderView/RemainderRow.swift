//
//  RemainderRow.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI
import CoreData
@available(iOS 17.0, *)
struct RemainderRow: View {
    @ObservedObject var remainder: CDRemainder
    var color:String
    @State var isClicked:Bool = false
    @Binding  var isFocused: Bool
    @FocusState  var isItemFocused: Bool

    @State  var editedDate: String = ""
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                TextField("New Reminder", text: $remainder.title)
                    .foregroundColor(remainder.isCompleted_ ? .secondary : .primary)
                    .focused($isItemFocused,equals: isFocused)
                    .onTapGesture(perform: {
                        isFocused = true
                    })
                
                TextField("Add Note", text: $remainder.notes)
                    .foregroundColor(remainder.isCompleted_ ? .secondary : .primary)
                    .focused($isItemFocused,equals: isFocused)
                    .onTapGesture(perform: {
                        isFocused = true
                        
                    })
                  
                
                if  let originalDate = remainder.schedule_?.date, let time = remainder.schedule_?.time, let repeatCycle = remainder.schedule_?.repeatCycle,!editedDate.isEmpty{
                    if !isFocused {
                        HStack{
                            Text(originalDate)
                                .foregroundColor(.secondary)
                            if !time.isEmpty{
                                Text(",  \(time)")
                                    .foregroundColor(.secondary)
                            }
                            if !repeatCycle.isEmpty{
                                Text(", \(Image(systemName: "repeat"))\(repeatCycle)")
                                    .foregroundColor(.secondary)
                            }
                            
                        }
                    } else {
                        HStack{
                            Text(editedDate)
                                .foregroundColor(.secondary)
                                
                            if !time.isEmpty{
                                Text(", \(time)")
                                    .foregroundColor(.secondary)
                            }
                             if !repeatCycle.isEmpty{
                                Text(", \(Image(systemName: "repeat"))\(repeatCycle)")
                                    .foregroundColor(.secondary)
                            }

                        }
                    }
                }
            }
            if isItemFocused{
                infoMenu
            }
        }
        .sheet(isPresented: $isClicked, content: {
            NavigationStack{
//                calender(dates: dateFromString(editedDate) ?? Date(), isFocused: $isFocused, schedule: $remainder.schedule_, editedDate: $editedDate)
            }
        })
        .onDisappear(perform: {
            editedDate = remainder.schedule_?.date ?? ""
        })
        .onAppear(perform: {
            editedDate = remainder.schedule_?.date ?? ""
        })
    }
    
    var infoMenu:some View{
        Menu {
            Menu {
                Button {
                    let today = Date()
                    let todayDateString = formattedDatesString(from: today)
                    remainder.schedule_?.date_ = todayDateString
                    editedDate = todayDateString
                    
                } label: {
                    Label("Today", systemImage: "sun.max")
                }
                Button {
                    let todayDate = Date()
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: todayDate)!
                    let tomorrowDateString = formattedDatesString(from: tomorrow)
                    remainder.schedule_?.date_ = tomorrowDateString
                    editedDate = tomorrowDateString
                } label: {
                    Label("Tomorrow", systemImage: "sunrise")
                }
                Button {
                    isClicked.toggle()
                    
                } label: {
                    Label("Pick a Date", systemImage: "calendar.badge.clock")
                }
                Divider()
                
                Button(role: .destructive) {
                    remainder.schedule_?.date = ""
                    editedDate = ""
                    remainder.schedule_?.repeatCycle = ""
                    remainder.schedule_?.time = ""
                } label: {
                    Label("Remove Due Date", systemImage: "minus.circle")
                }
                
            } label: {
                Label("Due Date", systemImage: "calendar")
            }
            
        } label: {
            Image(systemName: "info.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(hex:color))
        }
        .frame(alignment: .leading)
    }
    
    private func formattedDatesString(from component: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateComponents = component
        let formattedDates = dateFormatter.string(from: dateComponents)
        return formattedDates
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: dateString)
    }
}


