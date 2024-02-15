//
//  EditListV2.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 12/02/2024.
//

import SwiftUI

struct EditListV2: View {
    @State private var name:String = ""
    @State private var color: String? = "#ffde22"
    @State private var icon: String? = "list.bullet"
    @FocusState private var isFocused:Bool
    @Binding  var reloadFlag:Bool
    @Binding var list:CDList
    @EnvironmentObject var sheetManager:SheetManager
    private let resultGridLayout = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
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
                    list.color_ =   self.color
                    list.image_ =    self.icon
                    list.name_ =    self.name
                    Task{
                         await PersistenceController.shared.save()
                     }
                    reloadFlag.toggle()
                    sheetManager.dismiss()
                } label: {
                    Text("Save")
                }.disabled(name.isEmpty)
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
                        Spacer()
                        Divider()
                            .foregroundStyle(Color.white)
                            .padding(.bottom,5)
                        Spacer()
                        colors
                            .padding(.bottom,5)
                        Spacer()
                        icons
                            .padding(.bottom,30)
                        Spacer()
                    }
                    .padding([.leading,.trailing],40)
                    .onAppear(perform: {
                        isFocused.toggle()
                    })
                    
                }
        }
        .onAppear(perform: {
            self.color = list.color_
            self.icon = list.image_
            self.name = list.name_ ?? ""
            isFocused.toggle()
        })
        
    }
    
    var title:some View {
        TextField("", text: $name)
            .focused($isFocused)
            .placeholder(when: name.isEmpty, alignment: .leading) {
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
            RoundedRectangle(cornerRadius: 20,style: .continuous)
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
            RoundedRectangle(cornerRadius: 20,style: .continuous)
                .fill(.ultraThinMaterial)
        )
        
    }
    
}

#Preview {
    EditListV2(reloadFlag: .constant(false), list: .constant(CDList(name: "", color: "", image: "", context: PersistenceController.shared.container.viewContext)))
}
