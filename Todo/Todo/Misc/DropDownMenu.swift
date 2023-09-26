//
//  SwiftUIView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 26/09/2023.
//

import SwiftUI

struct DropdownMenu: View {
    private let model:ListModel
    
    init(vm:ListModel){
        self.model = vm
    }
    var body: some View {
        Menu {
            Button("Option 1") {
                // Handle Option 1
            }
            Button("Option 2") {
                // Handle Option 2
            }
            Button("Option 3") {
                // Handle Option 3
            }
        
        } label: {
            Image(systemName: "ellipsis.circle")

        }
    }
}

struct DropDownMenu_Previews: PreviewProvider {
    static let vm = ListModel(name: "", image: "", color: "")
    static var previews: some View {
        DropdownMenu(vm:vm)
    }
}
