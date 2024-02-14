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
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color(hex: "#1A1C20"))
                    .shadow(color: .black, radius: 0.5)
                    .overlay {
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
                                selection: $dates,
                                displayedComponents: [.date]
                            )
                            .padding()
                            .datePickerStyle(.graphical)
                            .accentColor(Color(hex: color))
                            .onChange(of: dates, initial: false) { oldValue, newValue in
                                date = dateFormatter.formattedDatesString(from: dates, isTime: false)
                            }
                        }
                
                    }
                    .padding()
        }
        .transition(.move(edge: .bottom))
        .frame(width: 400)
        .frame(minHeight: 500,maxHeight: 500)
    }
        
}








@available(iOS 17.0, *)
#Preview {
    calender(didClose: {}, date: .constant(""), color: "7EAA92")
}



