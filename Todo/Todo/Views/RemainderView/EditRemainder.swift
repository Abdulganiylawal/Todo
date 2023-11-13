
import SwiftUI

@available(iOS 17.0, *)
struct EditRemainder: View {
    @Binding var remainders:CDRemainder
    @Environment(\.presentationMode) var presentationMode
    @FocusState var isFocused:Bool
    @State var isDateClicked:Bool = false
    @State var isTimeClicked:Bool = false
    @State var isEndTimeClicked:Bool = false
    @State var isRepeatClicked:Bool = false
    @State var endTime = ""
    @State var date = ""
    @State var time = ""
    @State var repeatCycle = ""
    @EnvironmentObject var sheetManager:SheetManager
    var dateFormatter = DateFormatterModel()

    
    var body: some View {
        VStack(alignment:.leading){
            TextField("", text: $remainders.title)
                .foregroundStyle( Color.white)
                .focused($isFocused)
                .onTapGesture {
                    
                    sheetManager.dismiss()
                }
                .placeholder(when: remainders.title.isEmpty, alignment: .center) {
                    Text("Task descriptions").foregroundColor(.gray)
                }
                .padding()
            Divider()
            if  self.date.isEmpty {
                if let listImage = remainders.list?.image, let listColor = remainders.list?.color, let listName = remainders.list?.name {
                    HStack {
                        Image(systemName: listImage)
                            .foregroundStyle(Color(hex: listColor))
                        Text(listName)
                            .foregroundStyle(Color.white)
                    }.padding([.leading, .top], 15)
                }
            }
            else{
                VStack(alignment: .leading){
                    if !self.date.isEmpty{
                        HStack{
                            LabeledContent {
                                Button(role: .destructive) {
                                    remainders.schedule_?.date_ = ""
                                    self.date = ""
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(Color.red)
                                        .padding(.trailing,10)
                                }
                            } label: {
                                HStack{
                                    Image(systemName: "calendar")
                                    Text(self.date)
                                        .foregroundStyle(Color.white)
                                }
                            }
                        }.padding([.top, .bottom],5)
                            .padding(.leading,15)
                    }
                }
            }
            VStack{
                if !self.time.isEmpty{
                    LabeledContent {
                        Button(role: .destructive) {
                            remainders.schedule_?.time_ = ""
                            self.time = ""
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                            
                                .padding(.trailing,10)
                        }
                    } label: {
                        HStack{
                            Image(systemName: "clock")
                            Text(self.time)
                                .foregroundStyle(Color.white)
                        }
                   
                    }
                    .padding(.bottom,5)
                }
                
                if !self.endTime.isEmpty{
                    LabeledContent {
                        Button(role: .destructive) {
                            self.endTime = ""
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                                .padding(.trailing,10)
                        }
                    } label: {
                        HStack{
                            Image(systemName: "stopwatch.fill")
                            Text(self.endTime)
                                .foregroundStyle(Color.white)
                        }
                    }
                    .padding(.bottom,5)
                }
                if !self.repeatCycle.isEmpty{
                    LabeledContent {
                        Button(role: .destructive) {
                            remainders.schedule_?.repeatCycle_ = ""
                            self.repeatCycle = ""
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color.red)
                                .padding(.trailing,10)
                        }
                    } label: {
                        HStack{
                            Image(systemName: "repeat")
                            Text(self.repeatCycle)
                                .foregroundStyle(Color.white)
                        }
                    }
                    .padding(.bottom,5)
                }
            }
            .padding(.leading,15)
            
            ScrollView(.horizontal,showsIndicators: false){
                
                HStack{
                    ActionButton(text: "Date", imageName: "calendar", colorHex: remainders.list!.color_!, width: 100, height: 35, action: {
                        withAnimation(.bouncy) {
                            isFocused = false
                            isDateClicked.toggle()
                            isTimeClicked = false
                            isEndTimeClicked = false
                            isRepeatClicked = false
                            sheetManager.present()
                        }})
                    
                    ActionButton(text: "Time", imageName: "clock", colorHex: remainders.list!.color_!, width: 100, height: 35 ,action:{
                        withAnimation(.easeOut) {
                            isFocused = false
                            isTimeClicked.toggle()
                            isDateClicked = false
                            
                            isEndTimeClicked = false
                            isRepeatClicked = false
                            sheetManager.present()
                        }
                    })
                    ActionButton(text: "End Time", imageName: "stopwatch.fill", colorHex: remainders.list!.color_!, width: 130, height: 35, action:{
                        withAnimation(.easeOut) {
                            isFocused = false
                            isEndTimeClicked.toggle()
                            isTimeClicked = false
                            isDateClicked = false
                            isRepeatClicked = false
                            sheetManager.present()
                            
                        }
                    } )
                    
                    ActionButton(text: "Repeat", imageName: "repeat", colorHex: remainders.list!.color_!, width: 130, height: 35, action: {
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
               
                TextField("", text: $remainders.notes)
                    .foregroundStyle(Color.white)
                    .onTapGesture {
                            sheetManager.dismiss()
                        }
                    .placeholder(when: remainders.notes.isEmpty, alignment: .leading) {
                        Text("Add notes")
                            .foregroundColor(.gray)
                    }
            }.padding(.leading,15)
            Divider()
            Spacer()
        }.onAppear(perform: {
            date = remainders.schedule_?.date_ ?? ""
            time = remainders.schedule_?.time_ ?? ""
            repeatCycle = remainders.schedule_?.repeatCycle_ ?? ""
        })
        .navigationTitle("New Task")
            .foregroundStyle(Color(hex: remainders.list!.color_!))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isFocused = true
                        presentationMode.wrappedValue.dismiss()}, label: {
                        Text("Cancel")
                            .foregroundStyle(Color(hex: remainders.list!.color_!))
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        remainders.schedule_?.date_  = date
                        remainders.schedule_?.time_   = time
                        remainders.schedule_?.repeatCycle_  = repeatCycle
                        isFocused = true
                        if let time = remainders.schedule_?.time_{
                            let durationTime = dateFormatter.timeDifference(from: time, to: self.endTime)
                            if !(remainders.schedule_?.duration_.isZero)! {
                                remainders.schedule_?.duration_ = durationTime ?? 0.0
                            }
                        }
                        Task{
                            await PersistenceController.shared.save()
                        }
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                            .foregroundStyle(Color(hex: !remainders.title.isEmpty ? remainders.list!.color_! : "000000"))
                    }
                    ).disabled(remainders.title.isEmpty)
                }
            })
            .onAppear(perform: {
                isFocused.toggle()
            })
            .overlay(alignment: .bottom) {
                if sheetManager.action.isPresented{
                    if isDateClicked{
                        withAnimation {
                            calender(didClose: {sheetManager.dismiss()}, date: $date, color: remainders.list!.color_!)
                                .padding()
                                .ignoresSafeArea()
                        }
                    }
                    if isTimeClicked{
                        withAnimation {
                            TimeView(didClose: {sheetManager.dismiss()}, time: $time, color: remainders.list!.color_!)
                                .padding()
                                .ignoresSafeArea()
                        }
                    }
                    if isRepeatClicked{
                        withAnimation {
                            Repeat(didClose: {sheetManager.dismiss()}, repeatCycle:  $repeatCycle, color: remainders.list!.color_!)
                                .padding()
                                .ignoresSafeArea()
                        }
                    }
                    if isEndTimeClicked{
                        withAnimation {
                            Duration(didClose: {sheetManager.dismiss()}, time: $endTime, color: remainders.list!.color_!)
                                .padding()
                                .ignoresSafeArea()
                        }
                    }
                }
            }
    }
}


@available(iOS 17.0, *)
struct EditRemainder_Previews: PreviewProvider {
    static var previews: some View {
        let list = CDList(name: "", color: "D83F31", image: "", context: PersistenceController.shared.container.viewContext)
        let remainders = CDRemainder(context: PersistenceController.shared.container.viewContext, title: "Hello", notes: "djdjdjlkjnankasnckcnkscnknc")
        remainders.list = list
        remainders.isCompleted_ = true
        remainders.schedule_ = CDRemainderSchedule(repeatCycle: "monthly", date: "26-08-02", time: "12:00", duration: 3600, context: PersistenceController.shared.container.viewContext)
        return Group {
            EditRemainder(remainders: .constant(remainders))
                .environmentObject(SheetManager())
                .preferredColorScheme(.dark)
        }
    }
}


