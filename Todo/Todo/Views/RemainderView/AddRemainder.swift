//
//  AddRemainder.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 08/11/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct AddRemainder: View {
    @StateObject var  model:AddRemainderModel
    @Environment(\.presentationMode) var presentationMode
    @FocusState var isFocused:Bool
    @State var isDateClicked:Bool = false
    @State var isTimeClicked:Bool = false
    @State var isEndTimeClicked:Bool = false
    @State var isRepeatClicked:Bool = false
    @State var focused:Bool = false
    @EnvironmentObject var sheetManager:SheetManager
    var dateFormatter = DateFormatterModel()
    
    init(model:CDList){
        _model = StateObject(wrappedValue:AddRemainderModel(model: model))
    }
    var body: some View {
        VStack(alignment:.leading){
            TextField("", text: $model.name)
                .foregroundStyle(Color.white)
                .focused($isFocused)
                .onTapGesture {
                    isFocused.toggle()
                    sheetManager.dismiss()
                }
                .placeholder(when: model.name.isEmpty) {
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
                    ActionButton(text: "Date", imageName: "calendar", colorHex: model.model.color, width: 90, height: 35, action: {
                        withAnimation(.spring) {
                            isFocused = false
                            isDateClicked.toggle()
                            isTimeClicked = false
                            isEndTimeClicked = false
                            isRepeatClicked = false
                            sheetManager.present()
                        }})
                    
                    ActionButton(text: "Time", imageName: "clock", colorHex: model.model.color, width: 90, height: 35 ,action:{
                        withAnimation(.spring) {
                            isFocused = false
                            isTimeClicked.toggle()
                            isDateClicked = false
                            
                            isEndTimeClicked = false
                            isRepeatClicked = false
                            sheetManager.present()
                        }
                    })
                    ActionButton(text: "End Time", imageName: "stopwatch.fill", colorHex: model.model.color, width: 120, height: 35, action:{
                        withAnimation(.spring) {
                            isFocused = false
                            isEndTimeClicked.toggle()
                            isTimeClicked = false
                            isDateClicked = false
                            isRepeatClicked = false
                            sheetManager.present()
                            
                        }
                    } )
    
                    ActionButton(text: "Repeat", imageName: "repeat", colorHex: model.model.color, width: 100, height: 35, action: {
                        withAnimation(.spring) {
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
                    .placeholder(when: model.notes.isEmpty) {
                        Text("Add notes").foregroundColor(.gray)
                    }
            }.padding(.leading,15)
            Divider()
            Spacer()
        }.navigationTitle("New Task")
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
                        Task{
                            model.durationTime = dateFormatter.timeDifference(from: model.time, to: model.endTime)
                            await model.addRemainders(title: model.name, notes: model.notes, repeatcycle: model.repeatCycle, date: model.date, time: model.time, duration:model.durationTime ?? "" )
                            isFocused = true
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Create")
                            .foregroundStyle(Color(hex: model.model.color))
                    })
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


@available(iOS 17.0, *)
struct AddRemainder_Previews: PreviewProvider {
    static var previews: some View {
        
        return Group {
            AddRemainder(model: CDList(name: "Test", color: "7EAA92", image: "book", context: PersistenceController.shared.container.viewContext))
                .environmentObject(SheetManager())
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
    
    var body: some View {
        Button(action: action, label: {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color(hex: colorHex)).opacity(0.6)
                .frame(width: width, height: height)
                .overlay {
                    Label(text, systemImage: imageName)
                        .foregroundStyle(Color.white)
                }
        })
    }
}
