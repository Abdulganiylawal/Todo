//
//  AddListV2.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 12/02/2024.
//

import SwiftUI

struct AddListV2: View {
    @State private var name:String = ""
    @State private var color: String? = "#384358"
    @State private var icon: String? = "list.bullet"
    @ObservedObject var model:ListViewManger
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isFocused:Bool
    @EnvironmentObject var sheetManager:SheetManager
    
    let resultGridLayout = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        
        VStack {
            HStack{
                Button(action: { sheetManager.dismiss()}, label: {
                    Image(systemName: "xmark.app.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
                Spacer()
                Button {
                    self.name = model.title
                    model.addList(name: self.name, image: self.icon!, color: self.color!)
                    model.title = ""
                    withAnimation(.spring) {
                        sheetManager.dismiss()
                    }
                } label: {
                    Text("Save")
                }.disabled(!model.isEnabled)
            }.padding()
            
            RoundedRectangle(cornerRadius: 20,style: .continuous)
                .stroke(Color.gray, lineWidth: 0.5)
                .background(
                    RoundedRectangle(cornerRadius: 20,style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .padding()
                .frame(height: 400)
                .overlay {
                    VStack{
                        Image(systemName: self.icon ?? "list.bullet")
                            .resizable()
                            .foregroundColor(Color(hex: self.color ?? "D83F31"))
                            .frame(width: 20, height: 20)
                            .padding(.top,30)
                        Spacer()
                        title
                            .padding(.top,15)
                        Spacer()
                        Divider()
                            .foregroundStyle(Color.white)
                            .padding(.bottom,5)
                        Spacer()
                        colors
                            .padding(.bottom,5)
                      
                        Spacer()
                        icons
                            .padding(.bottom,25)
                        Spacer()
                    }
                    .padding([.leading,.trailing],40)
                    .onAppear(perform: {
                        isFocused.toggle()
                    })
                    
                }
        }
        .transition(.moveAndFade)
        .onDisappear(perform: {
            model.title = ""
        })
        
    }
    
    var title:some View {
        TextField("", text: $model.title)
            .focused($isFocused)
            .placeholder(when: model.title.isEmpty, alignment: .leading) {
                Text("Name").foregroundColor(.gray)
                
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 30,style: .continuous)
                    .fill(.ultraThinMaterial)
            )
    }
    
    var colors:some View{
        ScrollView(.vertical,showsIndicators: false){
            LazyVGrid(columns: resultGridLayout,spacing: 8, content: {
                ForEach(popularColors, id: \.self) { color in
                    ColorCapsule(color: color, selectedColor: $color)
                }
               
            })
         
            .padding([.top,.bottom],15)
            .padding([.leading,.trailing],1)
        }
        .background(
            RoundedRectangle(cornerRadius: 10,style: .continuous)
                .fill(.ultraThinMaterial)
        )
    }
    
    var icons:some View{
        
        ScrollView(.vertical,showsIndicators: false){
            LazyVGrid(columns: resultGridLayout,spacing: 8, content: {
                ForEach(todoIcons, id: \.self) { icon in
                    IconView(icon: icon, selectedIcon: $icon, color: $color)
                }
            })
            .padding([.top,.bottom],15)
            .padding([.leading,.trailing],1)
        }
        .background(
            RoundedRectangle(cornerRadius: 10,style: .continuous)
                .fill(.ultraThinMaterial)
    )
        
    }
    
    
}

#Preview {
    AddListV2(model:ListViewManger(context: PersistenceController.shared.container.viewContext))
}

struct IconView: View {
    let icon: String
    @Binding var selectedIcon: String?
    @Binding var color:String?
    
    var body: some View {
        Image(systemName: icon)
            .frame(width: 20,height: 20)
            .foregroundColor(.gray)
            .onTapGesture {
                self.selectedIcon = icon
               
            }
            .overlay(
                Image(systemName: icon)
                    .frame(width: 20,height: 20)
                    .foregroundColor(self.selectedIcon == icon ? Color(hex: self.color ?? "D83F31") : .gray)
                    .opacity(self.icon == selectedIcon ? 1 : 0)
            )
    }
}

struct ColorCapsule: View {
    let color: String
    @Binding var selectedColor: String?
    
    var body: some View {
        Capsule()
            .foregroundColor(Color(hex: self.color))
            .frame(width: 20, height: 20)
            .onTapGesture {
                self.selectedColor = color.description
            }
            .overlay(
                Circle()
                    .foregroundColor(Color.black)
                    .frame(width: 7, height: 7)
                    .offset(x: 0, y: 0)
                    .opacity(self.selectedColor == color.description ? 1 : 0)
            )
    }
}
