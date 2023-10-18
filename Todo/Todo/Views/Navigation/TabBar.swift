//
//  TabBar.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 18/09/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct TabBar: View {
    @AppStorage("SelectedTab") var selectedTab = 0
    private var data = AuthenticationManager()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                Home(context: PersistenceController.shared.container.viewContext)
                    .tag(0)

                Search(context: PersistenceController.shared.container.viewContext)
                    .tag(1)

                Settings(vm: data)
                    .tag(2)

            }
            ZStack{
                HStack{
                    ForEach((TabItems.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(3)
            }
            .frame(maxWidth: .infinity)
            .background(Color(hex: colorScheme == .light ? "C4C1A4" :  "040D12"))
            .overlay(
                GeometryReader { geometry in
                    Color.gray.opacity(0.5)
                        .frame(width: geometry.size.width, height: 1)
                        .offset(y: -1)
                }
            )

        }

    }
}

@available(iOS 17.0, *)
struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
