//
//  Time.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 08/11/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct Duration: View {
    @Environment(\.colorScheme) var colorScheme
    let didClose:() -> Void
    var dateFormatter = DateFormatterModel()
    @Binding var time:String
    @State private var times = Date()
    var color:String
    var body: some View {
        HStack{
            DatePicker(
                "Time:",
                selection: $times,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .onChange(of: times, initial: false) { oldValue, newValue in
                time =  dateFormatter.formattedDatesString(from: times, isTime: true)
            }
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    didClose()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color(hex: color))
                    
                })
                .padding(-30)
            }
            
            .transition(.move(edge: .bottom))
            
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .stroke(Color(hex: color)).opacity(colorScheme == .dark ? 0.6 : 1)
             
                     .frame(width:370, height: 300)
                    .opacity(0.1)
                
            )
            
        }
        .padding(.top,30)
        .padding()
   
    }
}
@available(iOS 17.0, *)
#Preview {
    Duration(didClose: {}, time: .constant("Date()"),  color: "7EAA92")
}
