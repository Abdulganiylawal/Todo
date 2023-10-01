//
//  RemainderRow.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI

struct RemainderRow: View {
    @Binding var remainder: RemainderModel
    var color:String
    @Binding var model:ListModel
    @State var isClicked:Bool = false
    @FocusState private var isItemFocused: Bool

    var body: some View {
        HStack(alignment: .top) {
            Button {
                withAnimation { 
                    remainder.isComplete.toggle()
                    isItemFocused.toggle()
                    model.addCompletedRemainders(remainder)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation {
                            model.removeRemainder(remainder)
                        }
                    }
                }
            } label: {
                if remainder.isComplete {
                    filledReminderLabel
                    
                } else {
                    emptyReminderLabel
                }
            }
            .frame(width: 20, height: 20)
            .buttonStyle(.plain)

            
            VStack(alignment:.leading){
                TextField("New Reminder", text: $remainder.title)
                    .foregroundColor(remainder.isComplete ? .secondary : .primary)
                if !isItemFocused{
                    Text(remainder.schedule)
                        .frame(alignment: .leading)
                }
               
                    TextField("Add Note", text: $remainder.description)
                        .foregroundColor(remainder.isComplete ? .secondary : .primary)
            
                if isItemFocused {
                    TextField("", text: $remainder.schedule)
                        .foregroundColor(remainder.isComplete ? .secondary : .primary)
                }
            }
            if isItemFocused {
                infoMenu
            }
        }.sheet(isPresented: $isClicked, content: {
            NavigationStack{
                calender(date: $remainder.schedule)
            }
        })
        .onTapGesture {
            isItemFocused = true
        }
        .focused($isItemFocused, equals: true)
    }

    var infoMenu:some View{
        Menu {
            Menu {
                Button {
                    let today = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy MM dd"
                    let todayDateString = dateFormatter.string(from: today)
                    remainder.schedule = todayDateString
                } label: {
                    Label("Today", systemImage: "sun.max")
                }
                Button {
                    let todayDate = Date()
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: todayDate)!
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy MM dd"
                    let tomorrowDateString = dateFormatter.string(from: tomorrow)
                    remainder.schedule = tomorrowDateString
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
                    remainder.schedule = ""
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
    
    var filledReminderLabel: some View {
        Circle()
            .stroke(Color(hex: color), lineWidth: 2)

            .overlay(alignment: .center) {
                GeometryReader { geo in
                    VStack {
                        Circle()
                            .fill(Color(hex: color))
                            .frame(width: geo.size.width*0.7, height: geo.size.height*0.7, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    
                }
                
                
            }
    }
    
    var emptyReminderLabel: some View {
        Circle()
            .stroke(Color(hex: color))

    }

}

