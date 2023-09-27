//  RemainderView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI

struct RemainderView: View {
    @Binding var model: ListModel
    @State private var isPopoverVisible = false
    @State private var isDropdownMenuVisible = false

    var body: some View {
        NavigationStack {
            VStack {
                List{
                    ForEach(Array(zip($model.remainders.indices, $model.remainders)),id: \.0) { index , $remainder in
                        RemainderRow(model: $remainder, viewModel: $model)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                Button(role: .destructive) {
                                   delete(item: index)
                                } label: {
                                    Label("Delete", systemImage: "xmark.bin")
                                }

                            })
                    }
                    .padding([.bottom],10)
                }
                .listStyle(.inset)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItemGroup(placement:.bottomBar) {
                    Button {
                        model.remainders.append(RemainderModel(title: "", description: "", schedule: ""))
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
                    Spacer()
                    Spacer()
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
    func delete(item:Int){
      _ =  model.remainders.remove(at: item)
    }
}

struct RemainderView_Previews: PreviewProvider {
    
    static var previews: some View {
        RemainderView(model: .constant(ListModel(name: "law", image: "", color: "")))
    }
}
