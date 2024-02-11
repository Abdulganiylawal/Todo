//
//  AddRemainder.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 08/11/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct AddRemainder: View {
    @ObservedObject var  model:RemainderViewModel
    @Environment(\.presentationMode) var presentationMode
    @FocusState var isFocused:Bool
    @State var isDateClicked:Bool = false
    @State var isTimeClicked:Bool = false
    @State var isEndTimeClicked:Bool = false
    @State var isRepeatClicked:Bool = false
    @EnvironmentObject var sheetManager:SheetManager
    var dateFormatter = DateFormatterModel()

    var body: some View {
        VStack(alignment:.leading){
            TextField("", text: $model.name)
                .foregroundStyle( Color.white)
                .focused($isFocused)
                .onTapGesture {
                    sheetManager.dismiss()
                }
                .placeholder(when: model.name.isEmpty, alignment: .leading) {
                    Text("Task descriptions").foregroundColor(.gray)
                }
                .padding()
               
          
              
            Divider()
            if model.date.isEmpty{
                HStack{
                    Image(systemName: model.model.image)
                        .foregroundStyle(Color(hex: model.model.color))
                    Text(model.model.name)
                        .foregroundStyle(Color.white)
                }.padding([.leading,.top],15)
            }
            else{
                VStack(alignment: .leading){
                    if !model.date.isEmpty{
                        HStack{
                            LabeledContent {
                                Button(role: .destructive) {
                                    model.date = ""
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(Color.red)
                                        .padding(.trailing,10)
                                }
                            } label: {
                                HStack{
                                    Image(systemName: "calendar")
                                    Text(model.date)
                                        .foregroundStyle(Color.white)
                                }
                            }
                        }.padding([.top, .bottom],5)
                            .padding(.leading,15)
                    }
                }
            }
            VStack{
                if !model.time.isEmpty{
                    
                    LabeledContent {
                        Button(role: .destructive) {
                            model.time = ""
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                            
                                .padding(.trailing,10)
                        }
                    } label: {
                        HStack{
                            Image(systemName: "clock")
                            Text(model.time)
                        
                                .foregroundStyle(Color.white)
                        }
                   
                    }
                    .padding(.bottom,5)
                }
                
                if !model.endTime.isEmpty{
                    LabeledContent {
                        Button(role: .destructive) {
                            model.endTime = ""
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                                .padding(.trailing,10)
                        }
                    } label: {
                        HStack{
                            Image(systemName: "stopwatch.fill")
                            Text(model.endTime)
                                .foregroundStyle(Color.white)
                        }
                    }
                    .padding(.bottom,5)
                }
                if !model.repeatCycle.isEmpty{
                    LabeledContent {
                        Button(role: .destructive) {
                            model.repeatCycle = ""
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                                .padding(.trailing,10)
                        }
                    } label: {
                        HStack{
                            Image(systemName: "repeat")
                            Text(model.repeatCycle)
                                .foregroundStyle(Color.white)
                        }
                    }
                    .padding(.bottom,5)
                }
            }
            .padding(.leading,15)
            
            ScrollView(.horizontal,showsIndicators: false){
                
                HStack{
                    ActionButton(text: "Date", imageName: "calendar", colorHex: model.model.color, width: 100, height: 35, action: {
                        withAnimation(.bouncy) {
                            isFocused = false
                            isDateClicked.toggle()
                            isTimeClicked = false
                            isEndTimeClicked = false
                            isRepeatClicked = false
                            sheetManager.present()
                        }})
                    
                    ActionButton(text: "Time", imageName: "clock", colorHex: model.model.color, width: 100, height: 35 ,action:{
                        withAnimation(.easeOut) {
                            isFocused = false
                            isTimeClicked.toggle()
                            isDateClicked = false
                            
                            isEndTimeClicked = false
                            isRepeatClicked = false
                            sheetManager.present()
                        }
                    })
                    ActionButton(text: "End Time", imageName: "stopwatch.fill", colorHex: model.model.color, width: 130, height: 35, action:{
                        withAnimation(.easeOut) {
                            isFocused = false
                            isEndTimeClicked.toggle()
                            isTimeClicked = false
                            isDateClicked = false
                            isRepeatClicked = false
                            sheetManager.present()
                            
                        }
                    } )
                    
                    ActionButton(text: "Repeat", imageName: "repeat", colorHex: model.model.color, width: 130, height: 35, action: {
                        withAnimation(.easeOut) {
                            isFocused = false
                            isRepeatClicked.toggle()
                            isDateClicked = false
                            isEndTimeClicked = false
                            isTimeClicked = false
                            sheetManager.present()
                        }
                    })
                }.padding()
            
            }
            Divider()
            Section{
                Text("Notes")
                    .foregroundStyle(Color.white)
               
                TextField("", text: $model.notes)
                    .foregroundStyle(Color.white)
                    .onTapGesture {
                            sheetManager.dismiss()
                        }
                    .placeholder(when: model.notes.isEmpty, alignment: .leading) {
                        Text("Add notes")
                            .foregroundColor(.gray)
                    }
            }.padding(.leading,15)
            Divider()
            Spacer()
        }
        .navigationTitle("New Task")
            .foregroundStyle(Color(hex: model.model.color))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isFocused = true
                        presentationMode.wrappedValue.dismiss()}, label: {
                        Text("Cancel")
                            .foregroundStyle(Color(hex: model.model.color))
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        Task {
                            if model.date.isEmpty {
                                let currentDate = Date()
                                model.date = DateFormatterModel.shared.formattedDatesString(from: currentDate, isTime: false)
        
                            }
                            if model.time.isEmpty{
                                let currentDate = Date()
                                model.time = DateFormatterModel.shared.formattedDatesString(from: currentDate, isTime: true)
                            }
                            model.durationTime = dateFormatter.timeDifference(from: model.time, to: model.endTime)
                            await model.addRemainders(title: model.name, notes: model.notes, repeatcycle: model.repeatCycle, date: model.date, time: model.time, duration: model.durationTime ?? 0.0)
                            
                            isFocused = true
                            presentationMode.wrappedValue.dismiss()
                        }

                    }, label: {
                        Text("Create")
                            .foregroundStyle(Color(hex: model.isClickable ? model.model.color : "BE3144"))
                    }
                    ).disabled(!model.isClickable)
                }
            })
            .onAppear(perform: {
                isFocused.toggle()
            })
            
            .overlay(alignment: .bottom) {
                if sheetManager.action.isPresented{
                    if isDateClicked{
                        withAnimation {
                            calender(didClose: {sheetManager.dismiss()}, date: $model.date, color: model.model.color)
                                .padding()
                                .ignoresSafeArea()
                        }
                    }
                    if isTimeClicked{
                        withAnimation {
                            TimeView(didClose: {sheetManager.dismiss()}, time: $model.time, color: model.model.color)
                                .padding()
                                .ignoresSafeArea()
                        }
                    }
                    if isRepeatClicked{
                        withAnimation {
                            Repeat(didClose: {sheetManager.dismiss()}, repeatCycle: $model.repeatCycle, color: model.model.color)
                                .padding()
                                .ignoresSafeArea()
                        }
                    }
                    if isEndTimeClicked{
                        withAnimation {
                            Duration(didClose: {sheetManager.dismiss()}, time: $model.endTime, color: model.model.color)
                                .padding()
                                .ignoresSafeArea()
                        }
                    }
                }
            }
        
    }
}




struct ActionButton: View {
    let text: String
    let imageName: String
    let colorHex: String
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action, label: {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color(hex: colorHex)).opacity(0.5 )
                .frame(width: width, height: height)
                .overlay {
                    Label(text, systemImage: imageName)
                        .foregroundStyle(Color.white)
                }
        }
        )
        .backgroundStyle1(cornerRadius: 5, opacity: 0.1)
    }
}
