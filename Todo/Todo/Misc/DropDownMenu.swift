//
//  SwiftUIView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI

struct DropdownMenu: View {
    var model:ListModel
    @State var isClicked:Bool = false
    
  
    var body: some View {
        Menu {
            Button(action: {
                isClicked.toggle()
            }, label: {
                Label("Show Completed", systemImage: "eye")
            })
        } label: {
            Image(systemName: "ellipsis.circle")

        }.sheet(isPresented: $isClicked, content: {
            CompletedView(model: model)
                
        })
    }
}



