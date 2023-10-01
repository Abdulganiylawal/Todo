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
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List{
                    ForEach(Array(zip($viewModel.remainders.indices, $viewModel.remainders)),id: \.0) { index , $remainder in
                        RemainderRow(remainder: $remainder, color: viewModel.color, model: $viewModel)
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
//                        viewModel.remainders.append(RemainderModel(title: "", description: "", schedule: ""))
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
            ToolbarItem(placement: .principal) {
                Text(viewModel.name)
                    .foregroundColor(Color(hex: viewModel.color))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                DropdownMenu(vm: viewModel)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Handle the button action here
                }) {
                    Text("Done")
                }
            }
        })
    }
    func delete(item:Int){
        _ =  viewModel.remainders.remove(at: item)
    }
}

//struct RemainderView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        RemainderView(model: .constant(ListModel(name: "law", image: "", color: "")))
//    }
//}
