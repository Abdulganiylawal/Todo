//
//  SwiftUIView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct DropdownMenu: View {
    var model:CDList
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
                .foregroundColor(Color(hex: model.color))

        }.sheet(isPresented: $isClicked, content: {
            NavigationStack{
                CompletedView(model: model)
            }
            .presentationDragIndicator(.visible)
            .presentationBackground(.ultraThinMaterial)
            .presentationCornerRadius(16)
        })
    }
}



