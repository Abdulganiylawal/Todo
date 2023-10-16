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
                .resizable()
                .renderingMode(.template)
                .foregroundColor(colorScheme == .dark ? .white: .black)
                .fontWeight(isActive ?.bold: .regular)
                .frame(width: 24,height: 24)
            Spacer()
        }
        .frame(height: 50)
    }
}
