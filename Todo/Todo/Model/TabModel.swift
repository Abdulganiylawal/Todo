//
//  TabModel.swift
//  Todo
//
//  Created by Lawal Abdulganiy on 19/09/2023.
//

import Foundation


enum TabItems: Int,CaseIterable{
    case home = 0
    case search
    case settings
    
    var title:String {
        switch self {
        case .home:
            return "Home View"
        case .search:
            return "Search View"
        case .settings:
            return "Settings View"
        }
        
    }
    var iconName:String{
        switch self {
        case .home:
            return "house"
        case .search:
            return "magnifyingglass"
        case .settings:
            return "gear"
        }
    }
}
