//  RemainderView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI

struct RemainderView: View {
//    var model: ListModel
    @State private var isPopoverVisible = false
    @State private var isDropdownMenuVisible = false
    @StateObject var viewModel:RemainderManager
    
    init(model:ListModel){
        _viewModel = StateObject(wrappedValue: RemainderManager(model: model))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List{
                    ForEach(Array(zip(self.viewModel.model.remainders.indices, self.viewModel.model.remainders)),id: \.0) { index , _ in
                        RemainderRow(ViewModel: viewModel)
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
                        viewModel.model.remainders.append(RemainderModel(title: "", description: "", schedule: ""))
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .foregroundColor(Color(hex: viewModel.model.color))
                                .frame(width: 20, height: 20)

                            Text("New Todo")
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: viewModel.model.color))
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
                Text(viewModel.model.remainders.isEmpty ? "Empty" : "")
            )
        }
        .toolbar{
            ToolbarItem(placement: .principal) {
                Text(viewModel.model.name)
                    .foregroundColor(Color(hex: viewModel.model.color)
            )}
            ToolbarItem {
                DropdownMenu(vm:viewModel.model )
            }
            ToolbarItem{
                Button {
                    viewModel.saveRemainder()
                } label: {
                    "Done"
                }
                
            }
        }
    }
    func delete(item:Int){
//      _ =  v.remainders.remove(at: item)
    }
}

//struct RemainderView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        RemainderView(model: .constant(ListModel(name: "law", image: "", color: "")))
//    }
//}
