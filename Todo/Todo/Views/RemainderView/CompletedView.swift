//
//  CompletedView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 01/10/2023.
//

import SwiftUI

struct CompletedView: View {
    var model:ListModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(model.completedRemainders,id: \.id) { remainder in
                    HStack(alignment: .top)
                    {
                        filledReminderLabel
                            .frame(width: 20, height: 20)
                        VStack(alignment:.leading){
                            Text("\(remainder.title)")
//                                .foregroundColor(Color(hex: model.color))
                            
                            Text("\(remainder.description)")
//                                .foregroundColor(Color(hex: model.color))
                            
                            Text("\(remainder.schedule)")
//                                .foregroundColor(Color(hex: model.color))
                        }
                    }
                    
                }
            }
            
        }
     
        
    }
    
    var filledReminderLabel: some View {
        Circle()
            .stroke(Color(hex: model.color), lineWidth: 2)
        
            .overlay(alignment: .center) {
                GeometryReader { geo in
                    VStack {
                        Circle()
                            .fill(Color(hex: model.color))
                            .frame(width: geo.size.width*0.7, height: geo.size.height*0.7, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
    }
    
}

#Preview {
    let model = ListModel(name: "", image: "", color: "")
    return CompletedView(model:model)
}
