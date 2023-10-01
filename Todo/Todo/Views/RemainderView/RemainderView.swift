//  RemainderView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI

struct RemainderView: View {
    @Binding var viewModel: ListModel
    @State private var isPopoverVisible = false
    @State private var isDropdownMenuVisible = false
    @FocusState  var isItemFocused: Bool
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List{
                    ForEach($viewModel.remainders, id:\.self.id) { $remainder in
                        RemainderRow(remainder: $remainder, color: viewModel.color, model: $viewModel)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                Button(role: .destructive) {
                                    if let index = viewModel.remainders.firstIndex(where: { $0.id == remainder.id }) {
                                        delete(item: index)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "xmark.bin")
                                }
                            })
                            .focused($isItemFocused)
                    }
                    .padding([.bottom],10)
                }
                .listStyle(.inset)
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItemGroup(placement:.bottomBar) {
                    Button {
                        
                        viewModel.addRemainder()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .foregroundColor(Color(hex: viewModel.color))
                                .frame(width: 20, height: 20)
                            
                            Text("New Todo")
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: viewModel.color))
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
                Text(viewModel.remainders.isEmpty ? "Empty" : "")
            )
            
        }.toolbar(content: {
            ToolbarItemGroup(placement: .principal) {
                Text(viewModel.name)
                    .foregroundColor(Color(hex: viewModel.color))
            }
            ToolbarItem {
                DropdownMenu(model: viewModel)
            }
            ToolbarItem {
                if isItemFocused {
                    withAnimation {
                        HStack {
                            Button("Done") {
                                isItemFocused.toggle()
                            }
                        }
                    }
                }
            }
        })

    }
    func delete(item:Int){
        _ =  viewModel.remainders.remove(at: item)
    }
}

//#Preview{
//        let viewModel = ListModel(name: "Example List", image: "listIcon", color: "FF5733")
//    return RemainderView(viewModel: .constant(viewModel),isItemFocused:)
//}
