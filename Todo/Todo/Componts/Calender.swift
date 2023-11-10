//
//  Calender.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 27/09/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct calender: View {
    let didClose:() -> Void
    @Binding var date:String
    var dateFormatter = DateFormatterModel()
    @Environment(\.colorScheme) var colorScheme
    var color:String
    @State var dates:Date = Date()
    var body: some View {
        VStack{
            DatePicker(
                "",
                selection: $dates,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .foregroundStyle(Color(hex: color))
            .onChange(of: dates, initial: false) { oldValue, newValue in
                date = dateFormatter.formattedDatesString(from: dates, isTime: false)
            }
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    didClose()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color(hex: color))
                    
                })
                .padding(.top,-20)
            }
            .transition(.move(edge: .bottom))
            
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                   .backgroundStyle1(cornerRadius: 20, opacity: 0.4)
                   .customBackgroundForRemainderRow( colorscheme: colorScheme, color: color)
                .frame(width:370, height: 400)
                .opacity(0.1)
            
                
            )
  
        }
     
        .padding(.top,30)
        .padding()
    }
        
}








@available(iOS 17.0, *)
#Preview {
    calender(didClose: {}, date: .constant(""), color: "7EAA92")
}



