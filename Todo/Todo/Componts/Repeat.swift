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
          RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color(hex: "#1A1C20"))
                .shadow(color: .black, radius: 0.5)
                .overlay(content: {
                    VStack(alignment:.trailing){
                        Button(action: {
                            withAnimation(.spring) {
                                didClose()
                            }
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Color(hex: color))
                        })
                        .padding()
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
                            
                    }
                })
            }
        .transition(.moveAndFade)
        .frame(height: 300)
    }
}
@available(iOS 17.0, *)
#Preview {
    Repeat(didClose: {}, repeatCycle: .constant(""), color: "7EAA92")
}
