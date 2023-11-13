import SwiftUI
import CoreData

struct AddList: View {
    let itemsPerRow = 6
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model:ListViewManger
    @State var color: String? = "#ffde22"
    @State var icon: String? = "list.bullet"
    @State var name:String = ""
    let resultGridLayout = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    
    init(manager: ListViewManger){
        self._model = ObservedObject(wrappedValue: manager)
    }
  
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("", text: $model.title)
                        .font(.system(size: 20, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .placeholder(when: model.title.isEmpty, alignment: .center) {
                            Text("Task").foregroundColor(.gray)
                                .frame(alignment: .center)
//                                .padding(.horizontal,150)
                        }
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.name = model.title
                    model.addList(name: self.name, image: self.icon!, color: self.color!)
                    model.title = ""
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Text("Save")
                }.disabled(!model.isEnabled)
            }
            ToolbarItem(placement: .principal) {
                Image(systemName: self.icon ?? "list.bullet")
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color(hex: self.color ?? "D83F31"))
            }
        }
    }
}


struct IconView: View {
    let icon: String
    @Binding var selectedIcon: String?
    @Binding var color:String?
    
    var body: some View {
        Image(systemName: icon)
            .frame(width: 40,height: 40)
            .foregroundColor(.gray)
            .onTapGesture {
                self.selectedIcon = icon
               
            }
            .overlay(
                Image(systemName: icon)
                    .frame(width: 40,height: 40)
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
            .frame(width: 40, height: 40)
            .onTapGesture {
                self.selectedColor = color.description
                
            }
            .overlay(
                Circle()
                    .foregroundColor(Color.black)
                    .frame(width: 13, height: 13)
                    .offset(x: 0, y: 0)
                    .opacity(self.selectedColor == color.description ? 1 : 0)
            )
    }
}

struct AddList_Previews: PreviewProvider {
    
    static var previews: some View {
        let model = ListViewManger(context: PersistenceController.shared.container.viewContext)
        
        AddList(manager: model)
            .preferredColorScheme(.dark)
    }
}
