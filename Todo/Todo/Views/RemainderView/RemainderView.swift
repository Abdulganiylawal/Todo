//  RemainderView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI

struct RemainderView: View {
    @Binding var model: ListModel
    @State private var isDropdownMenuVisible = false

    var body: some View {
        NavigationStack {
            VStack {
                ForEach($model.remainders) { $remainder in
                    RemainderRow(model: $remainder,  color: model.color)
            }
                .listStyle(.inset)
                .padding([.trailing,.leading],20)
                .padding([.bottom],10)
                Spacer()
                Button {
                    model.remainders.append(RemainderModel(title: "", description: ""))
                   
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(Color(hex: model.color))
                            .frame(width: 20, height: 20)

                        Text("New Todo")
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: model.color))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Text(model.remainders.isEmpty ? "Empty" : "")
            )
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(model.name)
                    .foregroundColor(Color(hex: model.color))
            }
            ToolbarItem {
                DropdownMenu(vm: model)
            }
        }
    }
}

struct RemainderView_Previews: PreviewProvider {
    static var previews: some View {
        RemainderView(model: .constant(ListModel(name: "law", image: "", color: "")))
    }
}
