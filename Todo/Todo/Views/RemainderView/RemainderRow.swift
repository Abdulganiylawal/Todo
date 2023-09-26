//
//  RemainderRow.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI

struct RemainderRow: View {
    @Binding var model: RemainderModel
    let color: String
  
    var body: some View {
        HStack(alignment:.top) {
            Button {
                model.isComplete.toggle()
            } label: {
                if model.isComplete {
                    filledReminderLabel
                } else {
                    emptyReminderLabel
                }
            }
            .frame(width: 20, height: 20)
            .buttonStyle(.plain)
            VStack{
                TextField("New Remainder", text: $model.title)
                    .foregroundColor(model.isComplete ? .secondary : .primary)
                TextField("Add Note", text: $model.description)
                    .foregroundColor(model.isComplete ? .secondary : .primary)
            }
        }
    }
    
    
    var filledReminderLabel: some View {
        Circle()
            .stroke(Color(hex: color), lineWidth: 2)

            .overlay(alignment: .center) {
                GeometryReader { geo in
                    VStack {
                        Circle()
                            .fill(Color(hex: color))
                            .frame(width: geo.size.width*0.7, height: geo.size.height*0.7, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    
                }
                
                
            }
    }
    
    var emptyReminderLabel: some View {
        Circle()
            .stroke(.secondary)

    }

}

struct RemainderRow_Previews: PreviewProvider {

    static var previews: some View {
        RemainderRow(model: .constant(RemainderModel(title: "", description: "")), color: "D83F31")
    }
}
