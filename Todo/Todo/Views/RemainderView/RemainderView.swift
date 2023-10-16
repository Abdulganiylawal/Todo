//  RemainderView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI
import CoreData
@available(iOS 17.0, *)
struct RemainderView: View {
    @FocusState  var isItemFocused: Bool
    var model:CDList
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CDRemainder.fetch(), animation: .bouncy) var remainders
    
    init(model:CDList){
        self.model = model
        let request = CDRemainder.fetch()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDRemainder.schedule_?.date_, ascending: true)]
        let predicate1 = NSPredicate(format: "list == %@", self.model as CVarArg)
        let predicate2 = NSPredicate(format: "isCompleted_ == false")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
        self._remainders = FetchRequest(fetchRequest: request, animation: .bouncy)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List{
                    remainder
                        .focused($isItemFocused,equals: true)
                        .listStyle(PlainListStyle())
                        .padding([.bottom], 10)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItemGroup(placement:.bottomBar) {
                        Button {
                            let remainder = CDRemainder(context: self.context, title: "", notes: "")
                            remainder.list = model
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isItemFocused = true
                            }
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
                    Text(remainders.isEmpty ? "Empty" : "")
                )
                
            }.toolbar(content: {
                ToolbarItemGroup(placement: .principal) {
                    Text(model.name)
                        .foregroundColor(Color(hex: model.color))
                }
                ToolbarItem {
                    DropdownMenu(model: model)
                }
                ToolbarItem {
                    if isItemFocused {
                        Button(action: {
                            withAnimation {
                                isItemFocused.toggle()
                            }
                            PersistenceController.shared.save()
                        }) {
                            Text("Done")
                                .foregroundColor(Color(hex: model.color))
                        }
                    }
                }
            })
        }
    }
    
    // MARK: -  Remainder Loop
    var remainder: some View{
        ForEach(remainders) { remainder in
            RemainderRow(remainder: remainder, color: model.color)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        CDRemainder.delete(remainder: remainder)
                    } label: {
                        Label("Delete", systemImage: "xmark.bin")
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        remainder.isCompleted_.toggle()
                        PersistenceController.shared.save()
                    } label: {
                        Label("Completed", systemImage: "checkmark")
                    }
                }
            
        }
    }
}


