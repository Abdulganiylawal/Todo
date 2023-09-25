import SwiftUI

struct AddList: View {
    let itemsPerRow = 6
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model:ListViewManger
    
    init(manager: ListViewManger){
        self._model = ObservedObject(wrappedValue: manager)
    }
    @State var color: String? = "D83F31"
    @State var icon: String? = "list.bullet"
    @State var name:String = ""
    
    var colorGrid: some View {
        VStack(spacing: 16) {
            ForEach(0..<popularColors.count, id: \.self) { index in
                if index % itemsPerRow == 0 {
                    let endIndex = min(index + itemsPerRow, popularColors.count)
                    let rowColors = popularColors[index..<endIndex]
                    
                    ColorRow(rowColors: Array(rowColors), selectedColor: $color)
                }
            }
        }
        .padding()
    }
    
    var IconGrid: some View {
            VStack(spacing: 16) {
                ForEach(0..<todoIcons.count, id: \.self) { index in
                    if index % itemsPerRow == 0 {
                        let endIndex = min(index + itemsPerRow, todoIcons.count)
                        let rowIcons = todoIcons[index..<endIndex]
                        
                        IconRow(rowIcons: Array(rowIcons), selectedIcon: $icon,  color: $color)
                    }
                }
            }
            .padding()
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("", text: $model.title)
                        .font(.system(size: 30, weight: .regular))
                        .multilineTextAlignment(.center)
                        .background(
                            ZStack(alignment: .leading) {
                                if model.title.isEmpty {
                                    Text("Title")
                                        .font(.system(size: 25, weight: .regular))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 10)
                                }
                            }
                        )
                }
                Section {
                    colorGrid
                }
                Section {
                    IconGrid
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

struct ColorRow: View {
    let rowColors: [String]
    @Binding var selectedColor: String?
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(rowColors, id: \.self) { color in
                ColorCapsule(color: color, selectedColor: $selectedColor)
            }
        }
    }
}



struct IconRow: View {
    let rowIcons: [String]
    @Binding var selectedIcon: String?
    @Binding var color:String?
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(rowIcons, id: \.self) { icon in
                IconView(icon: icon, selectedIcon: $selectedIcon, color: $color)
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
        let model = ListViewManger()
        AddList(manager: model)
    }
}
