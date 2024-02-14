//
//  TimeView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 08/11/2023.
//

import SwiftUI


@available(iOS 17.0, *)
struct TimeView: View {
    @Environment(\.colorScheme) var colorScheme
    let didClose:() -> Void
    @State private var times = Date()
    var dateFormatter = DateFormatterModel()
    @Binding var time:String
    var color:String
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous)
                .fill(Color(hex: "#1A1C20"))
                .shadow(color: .black, radius: 0.5)
                .overlay(content: {
                    VStack(alignment:.trailing){
                        Button(action: {
                            didClose()
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Color(hex: color))
                            
                        })
                        .padding()
                        DatePicker(
                            "",
                            selection: $times,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .onChange(of: times, initial: false) { oldValue, newValue in
                            time =  dateFormatter.formattedDatesString(from: times, isTime: true)
                        }
                    }
                })
        }
        .transition(.move(edge: .bottom))
        .frame(height: 300)
    }
    
}

@available(iOS 17.0, *)
#Preview {
    TimeView(didClose: {}, time: .constant(""), color: "7EAA92")
}
