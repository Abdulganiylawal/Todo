//
//  Tab.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/09/2023.
//

import SwiftUI


@available(iOS 17.0, *)
extension TabBar{
  
    func CustomTabItem(imageName: String, isActive: Bool) -> some View{
        HStack(){
            Spacer()
            Image(systemName: imageName)
                .renderingMode(.template)
                .font(.title2)
                .imageScale(.medium)
                .foregroundColor(colorScheme == .dark ? .gray: .black)
                .fontWeight(isActive ?.bold: .regular)
        
            Spacer()
        }
        .frame(height: 50)
    }
}
