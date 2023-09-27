//
//  RemainderRow.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI

struct RemainderRow: View {
    @Binding var model: RemainderModel
    var viewModel:ListModel
    @State var isClicked:Bool = false
    @FocusState private var isItemFocused: Bool

    var body: some View {
        HStack(alignment: .top) {
            Button {
                model.isComplete.toggle()
                self.isItemFocused = false
                
            } label: {
                if model.isComplete {
                    filledReminderLabel
                } else {
                    emptyReminderLabel
                    
                }
            }
            .frame(width: 20, height: 20)
            .buttonStyle(.plain)
            
            VStack(alignment:.leading){
                TextField("New Reminder", text: $model.title)
                    .foregroundColor(model.isComplete ? .secondary : .primary)
                if !isItemFocused{
                    Text(model.schedule)
                        .frame(alignment: .leading)
                }
                if isItemFocused {
                    TextField("Add Note", text: $model.description)
                        .foregroundColor(model.isComplete ? .secondary : .primary)
                }
                if isItemFocused {
                    TextField("", text: $model.schedule)
                        .foregroundColor(model.isComplete ? .secondary : .primary)
                }
            }
            if isItemFocused {
                infoMenu
            }
        }.sheet(isPresented: $isClicked, content: {
            NavigationStack{
                calender(date: $model.schedule)
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
                    model.schedule = todayDateString
                } label: {
                    Label("Today", systemImage: "sun.max")
                }
                Button {
                    let todayDate = Date()
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: todayDate)!
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy MM dd"
                    let tomorrowDateString = dateFormatter.string(from: tomorrow)
                    model.schedule = tomorrowDateString
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
                    model.schedule = ""
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
                .foregroundColor(Color(hex: viewModel.color))
        }
        .frame(alignment: .leading)
    }
    
    var filledReminderLabel: some View {
        Circle()
            .stroke(Color(hex: viewModel.color), lineWidth: 2)

            .overlay(alignment: .center) {
                GeometryReader { geo in
                    VStack {
                        Circle()
                            .fill(Color(hex: viewModel.color))
                            .frame(width: geo.size.width*0.7, height: geo.size.height*0.7, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    
                }
                
                
            }
    }
    
    var emptyReminderLabel: some View {
        Circle()
            .stroke(Color(hex: viewModel.color))

    }

}

struct RemainderRow_Previews: PreviewProvider {
    static let vm = ListModel(name: "", image: "", color: "")
    static var previews: some View {
        RemainderRow(model: .constant(RemainderModel(title: "", description: "", schedule: "")), viewModel: vm)
    }
}
