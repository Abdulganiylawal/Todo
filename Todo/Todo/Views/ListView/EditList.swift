import SwiftUI


struct EditList: View {
    let itemsPerRow = 6
    @Environment(\.presentationMode) var presentationMode
    @Binding var list:CDList
    @ObservedObject  var model:ListViewManger
    @State private var color:String? = "#ffde22"
    @State private var icon:String? = "list.bullet"
    @State private var name:String = ""
    @Binding  var reloadFlag:Bool
    @FocusState private var isFocused:Bool
    private let resultGridLayout = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
  
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("", text: $name)
                        .focused($isFocused)
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                }
                Section {
                    LazyVGrid(columns: resultGridLayout,spacing: 10, content: {
                        ForEach(popularColors, id: \.self) { color in
                            ColorCapsule(color: color, selectedColor: $color)
                        }
                    })

                }
                Section {
                    LazyVGrid(columns: resultGridLayout,spacing: 10, content: {
                        ForEach(todoIcons, id: \.self) { icon in
                            IconView(icon: icon, selectedIcon: $icon, color: $color)
                        }
                    })
                }
            }
        }.onAppear(perform: {
            self.color = list.color_
            self.icon = list.image_
            self.name = list.name_ ?? ""
            isFocused.toggle()
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                   list.color_ =   self.color
                   list.image_ =    self.icon
                  list.name_ =    self.name
                    Task{
                        await PersistenceController.shared.save()
                    }
                    reloadFlag.toggle()
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Text("Save")
                }.disabled(name.isEmpty)
            }
            
                ToolbarItem(placement: .principal) {
                    Image(systemName: self.icon!)
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(hex: self.color!))
                }
            
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "xmark" )
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color(hex: list.color ))
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        })
    }
}



