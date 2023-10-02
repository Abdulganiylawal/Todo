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
    @FocusState var isItemFocused: Int?
    @FocusState  var isFocused: Bool
    
    var body: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                TextField("New Reminder", text: $remainder.title)
                    .foregroundColor(remainder.isComplete ? .secondary : .primary)
                    .focused($isFocused, equals: true)
//                    .focused($isItemFocused, equals: 0)
//                    .onTapGesture {
//                        isItemFocused = 0
//                    }
                
                TextField("Add Note", text: $remainder.description)
                    .foregroundColor(remainder.isComplete ? .secondary : .primary)
                    .focused($isFocused, equals: true)
//                    .focused($isItemFocused, equals: 1)
//                    .onTapGesture {
//                        isItemFocused = 1
//                    }
                
                if  !remainder.schedule.isEmpty && !isFocused {
                    Text(remainder.schedule)
                        .frame(alignment: .leading)
                }
                
                if !remainder.schedule.isEmpty  && isFocused {
                    TextField("", text: $remainder.schedule)
                        .foregroundColor(remainder.isComplete ? .secondary : .primary)
                     
                }
            }
            
            if isFocused{
                infoMenu
            }
        }.sheet(isPresented: $isClicked, content: {
            NavigationStack{
                calender(date: $remainder.schedule)
            }
        })
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
                    isClicked = true
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
}



// MARK: - Commented Codes Will Come Back Later

//            Button {
//                withAnimation {
//                    remainder.isComplete.toggle()
//                    isItemFocused.toggle()
//                    model.addCompletedRemainders([remainder])
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        withAnimation {
//                            model.removeRemainder(withID: remainder.id)
//                        }
//                    }
//                }
//            } label: {
//                if remainder.isComplete {
//                    filledReminderLabel
//                } else {
//                    emptyReminderLabel
//                }
//            }
//            .frame(width: 20, height: 20)
//            .buttonStyle(.plain)

//var filledReminderLabel: some View {
//    Circle()
//        .stroke(Color(hex: color), lineWidth: 2)
//
//        .overlay(alignment: .center) {
//            GeometryReader { geo in
//                VStack {
//                    Circle()
//                        .fill(Color(hex: color))
//                        .frame(width: geo.size.width*0.7, height: geo.size.height*0.7, alignment: .center)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//        }
//}
//
//var emptyReminderLabel: some View {
//    Circle()
//        .stroke(Color(hex: color))
//
//}
//

//struct RemainderRow_Previews: PreviewProvider {
//    static var previews: some View {
//        let reminder = RemainderModel(title: "Sample Reminder", description: "Description", schedule: "2023 10 01")
//        let viewModel = ListModel(name: "Example List", image: "listIcon", color: "FF5733", remainders: [reminder])
//        return RemainderRow(remainder: .constant(reminder), color: viewModel.color, model: .constant(viewModel))
//            .previewLayout(.fixed(width: 300, height: 80))
//            .padding()
//    }
//}
