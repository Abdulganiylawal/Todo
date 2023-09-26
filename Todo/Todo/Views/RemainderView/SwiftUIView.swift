//
//  SwiftUIView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI


struct SwiftUIView: View {
    @State private var name = "Taylor"

       var body: some View {
           TextField("Enter your name", text: $name)
               .textFieldStyle(.roundedBorder)
               .toolbar {
                   ToolbarItemGroup(placement: .keyboard) {
                       Button("Click me!") {
                           print("Clicked")
                       }
                   }
               }
       }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
