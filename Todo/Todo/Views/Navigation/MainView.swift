//
//  MainView.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/09/2023.
//

import SwiftUI

struct MainView: View {
    @AppStorage("SelectedTab") var selectedTab:TabItems = .home
    private var data = AuthenticationManager()
    var body: some View {
        ZStack{
            Group {
                switch selectedTab {
                case .home:
                    Home()
                case .search:
                    Search()
                case .settings:
                    Settings(vm: data)
                    
                }
                TabBar()
//                    .ignoresSafeArea()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
