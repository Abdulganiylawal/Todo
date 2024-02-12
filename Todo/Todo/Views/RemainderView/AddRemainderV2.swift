////
////  AddRemainderV2.swift
////  Todo
////
////  Created by Lawal Abdulganiy on 12/02/2024.
////
//
//import SwiftUI
//
//@available(iOS 17.0, *)
//struct AddRemainderV2: View {
//    @State var name = ""
//    @State var desc = ""
//    @State var endTime = ""
//    @State var date = ""
//    @State var time = ""
//    @State var repeatCycle = ""
//    @EnvironmentObject var sheetManager:SheetManager
//    @ObservedObject var viewModel:RemainderViewModel
//    @FocusState var isFocused:Bool
//    @State var isDateClicked:Bool = false
//    @State var isTimeClicked:Bool = false
//    @State var isEndTimeClicked:Bool = false
//    @State var isRepeatClicked:Bool = false
//    var body: some View {
//        VStack {
//            VStack{
//                RoundedRectangle(cornerRadius: 20,style: .continuous)
//                    .stroke(Color.gray, lineWidth: 0.5)
//                    .background(
//                        RoundedRectangle(cornerRadius: 20,style: .continuous)
//                            .fill(.ultraThinMaterial)
//                    )
//                
//                    .padding()
//                    .frame(height: 400)
//                    .overlay {
//                        VStack(alignment:.leading){
//                            buttons
//                                .padding(.bottom,5)
//                            title
//                                .padding(.bottom,5)
//                            notes
//                                .padding(.bottom,5)
//                        }
//                        .padding([.leading,.trailing],40)
//                    }
//            }
//            Spacer()
//            .onAppear(perform: {
//                isFocused.toggle()
//            })
//        }
//        .overlay(alignment: .bottom) {
//            if sheetManager.action.isPresented{
//                if isDateClicked{
//                    withAnimation {
//                        calender(didClose: {
//                            isFocused.toggle()
//                            isDateClicked.toggle()
//                            sheetManager.dismiss()}, date: $date, color: viewModel.model.color)
//                            .padding()
//                           
//                    }
//                }
//                if isTimeClicked{
//                    withAnimation {
//                        TimeView(didClose: {
//                            isFocused.toggle()
//                            isTimeClicked.toggle()
//                            sheetManager.dismiss()}, time: $time, color: viewModel.model.color)
//                            .padding()
//                           
//                    }
//                }
//                if isRepeatClicked{
//                    withAnimation {
//                        Repeat(didClose: {
//                            isFocused.toggle()
//                            isRepeatClicked.toggle()
//                            sheetManager.dismiss()}, repeatCycle: $repeatCycle, color: viewModel.model.color)
//                            .padding()
//                      
//                    }
//                }
//                if isEndTimeClicked{
//                    withAnimation {
//                        Duration(didClose: {
//                            isFocused.toggle()
//                            isEndTimeClicked.toggle()
//                            sheetManager.dismiss()}, time: $endTime, color: viewModel.model.color)
//                            .padding()
//                           
//                    }
//                }
//            }
//    }
//    }
//    
//    var buttons: some View{
//        HStack(spacing:10){
//            ActionButton(imageName: !isDateClicked ? "calendar.circle" : "calendar.circle.fill" , colorHex: viewModel.model.color, width: 100, height: 35, action: {
//                withAnimation(.bouncy) {
//                    isFocused = false
//                    isDateClicked.toggle()
//                    isTimeClicked = false
//                    isEndTimeClicked = false
//                    isRepeatClicked = false
//                    sheetManager.present()
//                }})
//          
//            ActionButton(imageName: !isTimeClicked ? "clock.circle" : "clock.circle.fill", colorHex: viewModel.model.color, width: 100, height: 35 ,action:{
//                withAnimation(.easeOut) {
//                    isFocused = false
//                    isTimeClicked.toggle()
//                    isDateClicked = false
//                    
//                    isEndTimeClicked = false
//                    isRepeatClicked = false
//                    sheetManager.present()
//                }
//            })
//            ActionButton(imageName: !isEndTimeClicked ? "stopwatch" :"stopwatch.fill", colorHex: viewModel.model.color, width: 130, height: 35, action:{
//                withAnimation(.easeOut) {
//                    isFocused = false
//                    isEndTimeClicked.toggle()
//                    isTimeClicked = false
//                    isDateClicked = false
//                    isRepeatClicked = false
//                    sheetManager.present()
//                    
//                }
//            } )
//            ActionButton(imageName: !isRepeatClicked ? "repeat.circle" : "repeat.circle.fill", colorHex: viewModel.model.color, width: 130, height: 35, action: {
//                withAnimation(.easeOut) {
//                    isFocused = false
//                    isRepeatClicked.toggle()
//                    isDateClicked = false
//                    isEndTimeClicked = false
//                    isTimeClicked = false
//                    sheetManager.present()
//                }
//            })
//        }
//    }
//    
//    var title:some View {
//        TextField("", text: $name)
//            .focused($isFocused)
//            .placeholder(when: name.isEmpty, alignment: .leading) {
//                Text("Name").foregroundColor(.gray)
//                
//            }
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 30,style: .continuous)
//                    .fill(.ultraThinMaterial)
//            )
//    }
//    
//    var notes:some View {
//        TextField("", text: $desc)
//            .placeholder(when: desc.isEmpty, alignment: .leading) {
//                Text("Add Note").foregroundColor(.gray)
//                
//            }
//            .padding()
//            .frame(height: 150)
//            .background(
//                RoundedRectangle(cornerRadius: 30,style: .continuous)
//                    .fill(.ultraThinMaterial)
//            )
//            
//    }
//}
//
//
//@available(iOS 17.0, *)
//struct AddRemainderV2_Previews: PreviewProvider {
//    static var previews: some View {
//        AddRemainderV2(viewModel: RemainderViewModel(model: CDList(name: "", color: "", image: "", context: PersistenceController.shared.container.viewContext)))
//            .environmentObject(SheetManager())
//    }
//}
//
//struct ActionButton: View {
//    let imageName: String
//    let colorHex: String
//    let width: CGFloat
//    let height: CGFloat
//    let action: () -> Void
//    @Environment(\.colorScheme) var colorScheme
//    
//    var body: some View {
//        Button(action: action, label: {
//            Image(systemName: imageName)
//                .resizable()
//                .frame(width: 25,height: 25)
//                .foregroundStyle(Color(hex: colorHex))
//        }
//        )
//    }
//}
//
