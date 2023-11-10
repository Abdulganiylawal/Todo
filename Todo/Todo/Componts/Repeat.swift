//
//  Repeat.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 08/11/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct Repeat: View {
    @Environment(\.colorScheme) var colorScheme
    let didClose:() -> Void
    @State private var picked:RepeatCycle = .never
    @Binding var repeatCycle:String
    var color:String
    var body: some View {
        VStack{
            Picker("", selection: $picked) {
                ForEach(RepeatCycle.allCases,id: \.self){
                    cycle in
                    Text(cycle.rawValue).tag(cycle)
                }
            }.pickerStyle(WheelPickerStyle())
                .onChange(of: picked, initial: false) { oldValue, newValue in
                    if newValue != .never{
                        repeatCycle = newValue.rawValue
                    }
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
                    
                       .backgroundStyle1(cornerRadius: 20, opacity: 0.4)
                       .customBackgroundForRemainderRow( colorscheme: colorScheme, color: color)
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
    Repeat(didClose: {}, repeatCycle: .constant(""
                                               ), color: "7EAA92")
}
