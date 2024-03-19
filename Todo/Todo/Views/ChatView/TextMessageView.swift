//
//  TextMessageView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/03/2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct TextMessageView: View {
    @ObservedObject  var viewModel:ChatAssistantViewModel
    @State var characterLimit: Int = 100
    @State var typedCharacters: Int = 0
    @State private var date = Date()
    @State private var time = Date()
    @State private var isDateClicked = false
    @State private var isTimeClicked = false

    @FocusState private var isFocused: Bool
    var body: some View {
        VStack{
            if isDateClicked{
                DatePicker(selection: $date, displayedComponents: .date) {
                }.datePickerStyle(WheelDatePickerStyle())
                    .transition(.move)
            }
            if isTimeClicked{
                DatePicker(selection: $time, displayedComponents: .hourAndMinute) {
                }.datePickerStyle(WheelDatePickerStyle())
                    .transition(.move)
                    .padding(.bottom,5)
            }
            VStack(alignment:.leading,spacing: 20){
                TextField("", text: $viewModel.message,axis: .vertical)
                    .focused($isFocused)
                    .placeholder(when: viewModel.message.isEmpty, alignment: .topLeading) {
                        Text("Ask me anything...")
                            .foregroundStyle(.secondary)
                            .onChange(of: viewModel.message) { result in
                                typedCharacters = viewModel.message.count
                                viewModel.message = String(viewModel.message.prefix(characterLimit))
                            }
                    }
                
                HStack{
                    Text("\(typedCharacters) / \(characterLimit)")
                        .foregroundColor(Color.gray)
                    Spacer()
                    Button {
                        withAnimation {
                            isFocused = false
                            isDateClicked = false
                            isTimeClicked.toggle()
                        }
                    } label: {
                        Image(systemName: "clock")
                    }.disabled(viewModel.message.isEmpty)
                    Button {
                        withAnimation {
                            isFocused = false
                            isTimeClicked = false
                            isDateClicked.toggle()
                        }
                    } label: {
                        Image(systemName: "calendar")
                    }.disabled(viewModel.message.isEmpty)

                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "paperplane.fill")
                            .rotationEffect(.degrees(45))
                    }).disabled(viewModel.message.isEmpty)
                }.onChange(of: date, initial: false) { oldValue, newValue in
                
                    viewModel.message = viewModel.message + " " + date.formatted(date:.abbreviated , time: .omitted)
                }
                .onChange(of: time, initial: false) { oldValue, newValue in
                    let time = DateFormatterModel.shared.formattedDatesString(from: newValue, isTime: true)
                    viewModel.message = viewModel.message + " " + time
                }.onChange(of: isFocused, initial: false) { oldValue, newValue in
                    if newValue {
                        isDateClicked = false
                        isTimeClicked = false
                    }
                }
            }
            .padding()
            .background{
                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                    .stroke(.white.opacity(0.5), lineWidth: 0.5)
                    .fill(.clear)
            }
            
            
        }.padding()
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        
    }
}

@available(iOS 17.0, *)
struct TextMessageView_Previews: PreviewProvider {
    static var previews: some View{
        TextMessageView(viewModel: ChatAssistantViewModel())
    }
    
}
